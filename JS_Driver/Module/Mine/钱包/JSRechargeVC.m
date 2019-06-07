//
//  JSRechargeVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/27.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSRechargeVC.h"
#import "PayRouteModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface JSRechargeVC ()

/** 支付路由数组 */
@property (nonatomic,retain) NSMutableArray *listData;
/** 支付宝支付路由 */
@property (nonatomic,retain) PayRouteModel *alipayRoute;
/** 微信支付路由 */
@property (nonatomic,retain) PayRouteModel *wechatRoute;

@end

@implementation JSRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kPaySuccNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:kPayFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCancel) name:kPayCancelNotification object:nil];
    
    [self getData];
}

#pragma mark - AppDelegate支付结果回调

//支付成功
- (void)paySuccess {
    XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"支付成功" leftButtonTitle:@"" rightButtonTitle:@"确定"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeMoneyNotification object:nil];
    [self backAction];
}

//支付失败
- (void)payFail {
    XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"支付失败" leftButtonTitle:@"" rightButtonTitle:@"确定"];
}

//支付取消
-(void)payCancel {
    XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"支付取消" leftButtonTitle:@"" rightButtonTitle:@"确定"];
}

#pragma mark - get data

- (void)getData {
    // business_id 1、运力端充值 2、货主端充值 3、货主端支付运费
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?business=%d&merchantId=%d",URL_GetPayRoute,1,1];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            self.listData = [PayRouteModel mj_objectArrayWithKeyValuesArray:responseData];
            for (PayRouteModel *payRouteModel in self.listData) {
                if ([payRouteModel.channelType isEqualToString:@"1"]) {
                    self.alipayRoute = payRouteModel;
                }
                if ([payRouteModel.channelType isEqualToString:@"2"]) {
                    self.wechatRoute = payRouteModel;
                }
            }
        }
    }];
}

#pragma mark - methods

//支付宝选中
- (IBAction)alipaySelectAction:(id)sender {
    self.alipayBtn.selected = YES;
    self.wechatBtn.selected = NO;
}

//微信选中
- (IBAction)wechetSelectAction:(id)sender {
    self.alipayBtn.selected = NO;
    self.wechatBtn.selected = YES;
}

//充值
- (IBAction)payAction:(id)sender {
    if ([Utils isBlankString:self.priceTF.text]) {
        [Utils showToast:@"请输入充值金额"];
        return;
    }
    if ([self.priceTF.text floatValue]<=0) {
        [Utils showToast:@"充值金额不能低于0元"];
        return;
    }
    [self.view endEditing:YES];
    if (self.alipayBtn.isSelected == YES) {
        [self alipay];
    }
    if (self.wechatBtn.isSelected == YES) {
        [self wechatPay];
    }
}

#pragma mark - 支付宝支付
- (void)alipay {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *urlStr = [NSString stringWithFormat:@"%@?channelType=%@&money=%@&routeId=%@",URL_Recharge,_alipayRoute.channelType,self.priceTF.text,_alipayRoute.routeId];
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            //应用注册scheme,在Info.plist定义URL types
            NSString *appScheme = kAPPScheme;
            NSString *orderInfo = responseData[@"orderInfo"];
            
            if (![Utils isBlankString:orderInfo]) {
                
                [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSInteger status = [resultDic[@"resultStatus"] integerValue];
                    
                    switch (status) {
                        case 9000:
                            [self paySuccess];
                            break;
                            
                        case 8000:
                            [Utils showToast:@"订单正在处理中"];
                            break;
                            
                        case 4000:
                            [self payFail];
                            break;
                            
                        case 6001:
                            [self payCancel];
                            break;
                            
                        case 6002:
                            [Utils showToast:@"网络连接出错"];
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
        }
    }];
}

#pragma mark - 微信支付
- (void)wechatPay {
    if (![WXApi isWXAppInstalled] && ![WXApi isWXAppSupportApi]) {
        [Utils showToast:@"您未安装微信客户端，请安装微信以完成支付"];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *urlStr = [NSString stringWithFormat:@"%@?channelType=%@&money=%@&routeId=%@",URL_Recharge,_wechatRoute.channelType,self.priceTF.text,_wechatRoute.routeId];
        [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status==Request_Success) {
                
                NSString *orderInfo = responseData[@"orderInfo"];
                
                if (![Utils isBlankString:orderInfo]) {
                    NSDictionary *orderDic = [Utils dictionaryWithJsonString:orderInfo];
                    //调起微信支付
                    PayReq *req             = [[PayReq alloc] init];
                    req.openID              = orderDic[@"appid"];
                    req.partnerId           = orderDic[@"partnerid"];
                    req.prepayId            = orderDic[@"prepayid"];
                    req.nonceStr            = orderDic[@"noncestr"];
                    NSMutableString *stamp  = orderDic[@"timestamp"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = orderDic[@"package"];
                    req.sign                = orderDic[@"sign"];
                    [WXApi sendReq:req];
                }
            }
        }];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
