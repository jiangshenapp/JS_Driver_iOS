//
//  Config.h
//  Chaozhi
//  Notes：接口地址【文档：http://192.168.199.4:9999/swagger-ui.html】
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma mark - ---------------接口地址---------------

NSString *domainUrl(void);

#pragma mark - ---------------接口名称---------------

#define URL_Login @"/app/subscriber/login" //密码登录
#define URL_SmsLogin @"/app/subscriber/smsLogin" //短信验证码登录
#define URL_Registry @"/app/subscriber/registry" //会员注册
#define URL_ResetPwdStep1 @"/app/subscriber/resetPwdStep1" //重置密码步骤1
#define URL_ResetPwdStep2 @"/app/subscriber/resetPwdStep2" //重置密码步骤2
#define URL_SendSmsCode @"/app/subscriber/sendSmsCode" //发送短信验证码
#define URL_SetPwd @"/app/subscriber/setPwd" //设置密码
#define URL_BindMobile @"/app/subscriber/bindMobile" //绑定手机号

#pragma mark - ---------------H5地址---------------

NSString *h5Url(void);

#pragma mark - ---------------H5名称---------------

#define H5_Privacy @"#/hybrid/chaozhi/privacy" //隐私协议

@end
