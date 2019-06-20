//
//  JSCodeLoginVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/25.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSCodeLoginVC.h"

@interface JSCodeLoginVC ()<UITextFieldDelegate>

@end

@implementation JSCodeLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backBtn setImage:[UIImage imageNamed:@"app_navigationbar_icon_close_black"] forState:UIControlStateNormal];
}

#pragma mark - methods
/* 获取验证码 */
- (IBAction)codeAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]
        || ![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入11位有效手机号"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"mobile",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_SendSmsCode parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"验证码发送成功"];
            [self startTimeCount:self.codeBtn];
        }
    }];
}

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
    
    if ([NSString isEmpty:self.codeTF.text]) {
        [Utils showToast:@"请输入验证码"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"mobile",
                         self.codeTF.text, @"code",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_SmsLogin parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
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
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 100) {
        if (textField.text.length + string.length > 11) {
            return NO;
        }
    }
    return YES;
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
