//
//  JSMyRouteDetailVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyRouteDetailVC.h"

@interface JSMyRouteDetailVC ()

/** 状态，0未启用，1启用 */
@property (nonatomic,assign) BOOL state;

@end

@implementation JSMyRouteDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"路线详情";
    
    [self getRouteInfo];
}

#pragma mark - 路线详情
/** 路线详情 */
- (void)getRouteInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetMyLines,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            weakSelf.state = [responseData[@"state"] boolValue];
            weakSelf.startLab.text = responseData[@"startAddressCodeName"];
            weakSelf.endLab.text = responseData[@"receiveAddressCodeName"];
            weakSelf.carLengthLab.text = responseData[@"carLengthName"];
            weakSelf.carModelLab.text = responseData[@"carModelName"];
            weakSelf.remarkLab.text = responseData[@"remark"];
            if ([responseData[@"arriveAddressCode"] integerValue]==0) {
                weakSelf.endLab.text = @"全国";
            }
            if ([responseData[@"startAddressCode"] integerValue]==0) {
                weakSelf.startLab.text = @"全国";
            }
        }
    }];
}

- (IBAction)applyJingpinAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_LineClassic,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"申请成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)openOrCloseAction:(id)sender {
    
}

- (void)startRouteAction {
    __weak typeof(self) weakSelf = self;
    self.state = 1;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?enable=%d&lineId=%@",URL_LineEnable,self.state,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"启用成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)stopRouteAction {
    self.state = 0;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?enable=%d&lineId=%@",URL_LineEnable,self.state,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"停用成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }
    }];
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
