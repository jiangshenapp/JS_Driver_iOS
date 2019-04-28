//
//  JSPaswdLoginVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSPaswdLoginVC.h"

@interface JSPaswdLoginVC ()

@end

@implementation JSPaswdLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backBtn setImage:[UIImage imageNamed:@"app_navigationbar_icon_close_black"] forState:UIControlStateNormal];
}

#pragma mark - methods
/* 登录 */
- (IBAction)loginAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]) {
        [Utils showToast:@"请输入手机号"];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入正确的手机号"];
        return;
    }
    
    if ([NSString isEmpty:self.pswTF.text]) {
        [Utils showToast:@"请输入密码"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"mobile",
                         self.pswTF.text, @"password",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"登录成功"];
            
            NSString *token = responseData;
            [CacheUtil saveCacher:@"token" withValue:token];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
            
            // 跳转到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

/* 用户协议 */
- (IBAction)protocalAction:(id)sender {
    [Utils showToast:@"用户协议"];
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
