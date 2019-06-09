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
    // Do any additional setup after loading the view.
}

#pragma mark - 车长
/** 车长 */
- (void)getRoutrInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetMyLines,_routeID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            weakSelf.state = [responseData[@"state"] boolValue];
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

- (IBAction)startRouteAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    self.state = 1;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(self.state) forKey:@"enable"];
    [dic setObject:_routeID forKey:@"lineId"];
    NSString *url = [NSString stringWithFormat:@"%@",URL_LineEnable];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"启用成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }
    }];
}

- (IBAction)stopRouteAction:(UIButton *)sender {
    self.state = 0;
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_routeID forKey:@"lineId"];
    [dic setObject:@(self.state) forKey:@"enable"];
    NSString *url = [NSString stringWithFormat:@"%@",URL_GetMyLines];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"停用成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }
    }];
}
@end
