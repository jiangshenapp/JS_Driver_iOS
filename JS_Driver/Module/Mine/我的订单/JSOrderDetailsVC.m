//
//  JSBaseOrderDetaileVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSOrderDetailsVC.h"
#import "JSAllOrderVC.h"
#import "JSOrderDistributionVC.h"
#import "XLGMapNavVC.h"

@interface JSOrderDetailsVC ()
{
    NSDictionary *startLocDic;
    NSDictionary *endLocDic;
}
/** 订单数据 */
@property (nonatomic,retain) OrderInfoModel *model;
@end

@implementation JSOrderDetailsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    _bgScroView.contentSize = CGSizeMake(0, _receiptView.bottom+50);
    
    self.tileView1.hidden = YES;
    self.titleView2.hidden = NO;
    
    self.bottomBtn.backgroundColor = AppThemeColor;
    [self.bottomBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    [self getOrderInfo];
}

-(void)getOrderInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetOrderInfo,_orderID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.model = [OrderInfoModel mj_objectWithKeyValues:responseData];
            [weakSelf refreshUI];
        }
    }];
}

- (void)refreshUI {
//    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.model.driverAvatar] placeholderImage:[UIImage imageNamed:@"personalcenter_driver_icon_head_land"]];
    self.nameLab.text = self.model.sendName;
    self.introduceLab.text = self.model.sendMobile;
    self.orderNoLab.text = [NSString stringWithFormat:@"订单编号：%@",self.model.orderNo];
    self.orderStatusLab.text = self.model.stateNameDriver;
    self.startAddressLab.text = self.model.sendAddress;
    self.startAddressAreaLab.text = self.model.sendAddressCodeName;
    self.endAddressLab.text = self.model.receiveAddress;
    self.endAddressAreaLab.text = self.model.receiveAddressCodeName;
    self.goodsTomeLab.text = self.model.loadingTime;
    self.carInfoLab.text = [NSString stringWithFormat:@"%@%@米/%@方/%@吨",self.model.carModelName,self.model.carLength,self.model.goodsVolume,self.model.goodsWeight];;
    self.goodsNameLab.text = self.model.goodsName;
    self.carTypeLab.text = self.model.useCarType;
    self.goodsPackTypeLab.text = self.model.packType;
    if ([self.model.payWay isEqualToString:@"1"]) {
        self.payTypeLab.text = @"线上支付";
    } else {
        self.payTypeLab.text = @"线下支付";
    }
    if ([self.model.feeType isEqualToString:@"1"]) {
        self.orderFeeLab.text = [NSString stringWithFormat:@"￥%@",self.model.fee];
    } else {
        self.orderFeeLab.text = @"面仪";
    }
    if ([self.model.payType isEqualToString:@"1"]) {
        self.goodsPayTypeLab.text = @"到付";
    } else {
        self.goodsPayTypeLab.text = @"现付";
    }
    self.depositLab.text = [NSString stringWithFormat:@"￥%@",self.model.deposit];
    self.explainLab.text = self.model.remark;
    self.receiptNameLab.text = self.model.receiveName;
    self.receiptNumerLab.text = self.model.receiveMobile;
    startLocDic = [Utils dictionaryWithJsonString:self.model.sendPosition];
    endLocDic = [Utils dictionaryWithJsonString:self.model.receivePosition];
    NSDictionary *locDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loc"];
    _distance1Lab.text = [NSString stringWithFormat:@"距离:%@",[Utils distanceBetweenOrderBy:[locDic[@"lat"] floatValue] :[locDic[@"lng"] floatValue] andOther:[startLocDic[@"latitude"] floatValue] :[startLocDic[@"longitude"] floatValue]]];;
    _distance2Lab.text = [NSString stringWithFormat:@"总里程:%@",[Utils distanceBetweenOrderBy:[startLocDic[@"latitude"] floatValue] :[startLocDic[@"longitude"] floatValue] andOther:[endLocDic[@"latitude"] floatValue] :[endLocDic[@"longitude"] floatValue]]];;;
    [self initView];
}

#pragma mark - init view
- (void)initView {
    
    //2待接单，3待确认，4待货主付款，5待接货, 6待送达，7待确认收货，8待回单收到确认，9待货主评价，10已完成，11取消，12已关闭
    NSInteger state = [self.model.state integerValue];
    switch (state) {
        case 1:
        case 2://待接单
            [self.bottomLeftBtn setTitle:@"拒绝接单" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"立即接单" forState:UIControlStateNormal];
            break;
        case 3: //待确认
            [self.bottomLeftBtn setTitle:@"拒绝接单" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"立即确认" forState:UIControlStateNormal];
            break;
        case 4: //待货主付款
            [self.bottomLeftBtn setTitle:@"取消接货" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"等待货主支付" forState:UIControlStateNormal];
            self.bottomRightBtn.userInteractionEnabled = NO;
            break;
        case 5: //待接货
            [self.bottomLeftBtn setTitle:@"拒绝配送" forState:UIControlStateNormal];
            [self.bottomRightBtn setTitle:@"开始配送" forState:UIControlStateNormal];
            break;
        case 6: //待送达
            self.bottomBtn.hidden = NO;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            [self.bottomBtn setTitle:@"我已送达" forState:UIControlStateNormal];
            break;
        case 7: //待货主确认收货
            
            break;
        case 8: //待回单收到确认
            self.bottomBtn.hidden = NO;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            [self.bottomBtn setTitle:@"上传回执" forState:UIControlStateNormal];
            break;
        case 9: //待货主评价
            
            break;
        case 10: //已完成
            self.orderStatusLab.hidden = YES;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            self.bottomBtn.hidden = YES;
            break;
        case 11: //已取消
            self.bottomBtn.hidden = NO;
            self.bottomLeftBtn.hidden = YES;
            self.bottomRightBtn.hidden = YES;
            [self.bottomBtn setTitle:@"已取消" forState:UIControlStateNormal];
            break;
        case 12://已关闭
            
            break;
        default:
            break;
    }
}

#pragma mark - methods

/** 打电话 */
- (IBAction)callPhone:(id)sender {
    if ([Utils isBlankString:self.model.sendMobile]) {
        [Utils showToast:@"电话号码是空号"];
        return;
    }
    [Utils call:self.model.sendMobile];
}

/** 聊天 */
- (IBAction)chatAction:(id)sender {
    [Utils showToast:@"功能暂未开通，敬请期待"];
}

- (IBAction)bottomLeftBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"拒绝接单"]) {
        [self rejectOrder];
    }
    else if ([title isEqualToString:@"取消接货"]) {
         [self cancleReceiveGoodsOrder];
    }
    else if ([title isEqualToString:@"拒绝配送"]) {
        [self cancleDistributionOrder];
    }
}

- (IBAction)bottomRightBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"立即接单"]) {
        [self receiveOrder];
    }
    else if ([title isEqualToString:@"立即确认"]) {
        [self confirmOrder];
    }
    else if([title isEqualToString:@"开始配送"]) {
         [self distributionOrder];
    }
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"我已送达"]) {
        [self completeDistributionOrder];
    }
    else if ([title isEqualToString:@"上传回执"]) {
        [self commentOrder];
    }
}

- (IBAction)showNav1Action:(UIButton *)sender {
    [XLGMapNavVC share].destionName = _model.sendAddress;
    [XLGMapNavVC startNavWithEndPt:CLLocationCoordinate2DMake([startLocDic[@"latitude"] floatValue], [startLocDic[@"longitude"] floatValue])];
}

- (IBAction)showNav2Action:(id)sender {
    [XLGMapNavVC share].destionName = _model.receiveAddress;
    [XLGMapNavVC startNavWithEndPt:CLLocationCoordinate2DMake([endLocDic[@"latitude"] floatValue], [endLocDic[@"longitude"] floatValue])];
}

#pragma mark - 回执评价
/** 回执评价 */
- (void)commentOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CommentOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"评价成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 我已送达
/** 我已送达 */
- (void)completeDistributionOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CompleteDistributionOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"送达成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 拒绝接单
/** 拒绝接单 */
- (void)rejectOrder {
    __weak typeof(self) weakSelf = self;
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_RefuseOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"拒绝成功"];
                [weakSelf pushOrderList];
            }
        }];
}

#pragma mark - 接单
/** 接单 */
- (void)receiveOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_ReceiveOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"接单成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 立即确认
/** 立即确认 */
- (void)confirmOrder {
    __weak typeof(self) weakSelf = self;
    if ([self.model.feeType integerValue]==2) {
        [Utils showToast:@"价格不可为电议 ，请联系货主修改！"];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_ConfirmOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"确认成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 取消接货
/** 取消接货 */
- (void)cancleReceiveGoodsOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CancelReceiveOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"取消接货成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 拒绝配送
/** 拒绝配送 */
- (void)cancleDistributionOrder {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@/%@",URL_CancelDistributionOrder,self.model.ID] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"拒绝配送成功"];
            [weakSelf pushOrderList];
        }
    }];
}

#pragma mark - 开始配送
/** 开始配送 */
- (void)distributionOrder {
    
    JSOrderDistributionVC *vc = (JSOrderDistributionVC *)[Utils getViewController:@"Mine" WithVCName:@"JSOrderDistributionVC"];
    vc.orderID = self.model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushOrderList {
    JSAllOrderVC *vc =(JSAllOrderVC *)[Utils getViewController:@"Mine" WithVCName:@"JSAllOrderVC"];
    [self.navigationController pushViewController:vc animated:YES];
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
