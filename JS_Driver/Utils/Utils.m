//
//  Utils.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "Utils.h"
#import "Toast.h"
#import "NetworkUtil.h"
#import "BaseNC.h"
#import "TZImageManager.h"
#import <AddressBook/AddressBook.h>

@interface Utils ()
{
    UIColor *_btnNormalColor; //按钮正常颜色
    UIColor *_btnSelectedColor; //按钮选中颜色
    UIColor *_btnBorderNormalColor; //按钮边框正常颜色
    UIColor *_btnBorderSelectedColor; //按钮边框选中颜色
}
@end

static Utils *_utils = nil;

@implementation Utils

/**
 类单例方法
 
 @return 类实例
 */
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _utils = [[Utils alloc] init];
    });
    return _utils;
}

/**
 存放服务器环境
 */
+ (void)setServer:(NSInteger)server {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:server forKey:kServerKey];
}

/**
 获取服务器环境
 */
+ (NSInteger)getServer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:kServerKey];
}

/**
 存放是否在非Wifi情况下播放视频状态
 */
+ (void)setWifi:(BOOL)wifi {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:wifi forKey:kWifiKey];
}

/**
 获取是否在非Wifi情况下播放视频状态
 */
+ (BOOL)getWifi {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kWifiKey];
}

/**
 判断网络状态
 
 @return YES 有网
 */
+ (BOOL)getNetStatus {
    if ([NetworkUtil currentNetworkStatus] != NotReachable) { //有网
        return YES;
    } else {
        return NO;
    }
}

/**
 获取当前时间
 
 @return 1990-09-18 12:23:22
 */
+ (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *fom = [[NSDateFormatter alloc]init];
    fom.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fom stringFromDate:date];
}

/**
 获取当前控制器
 
 @return 当前控制器
 */
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        if([nextResponder isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = nextResponder;
            BaseNC *nc = tab.selectedViewController;
            result = nc.topViewController;
        } else {
            result = nextResponder;
        }
    }
    else {
        result = window.rootViewController;
    }
    
    return result;
}

/**
 1、判断是否登录，2、是否跳转到登录页面
 
 @param isJump YES：跳转
 @return YES：登录
 */
+ (BOOL)isLoginWithJump:(BOOL)isJump{
    
    if (![Utils isBlankString:[UserInfo share].token]) {
        return YES;
    } else {
        if (isJump==YES) {
            //跳转到登录页面
            UIViewController *vc = [Utils getViewController:@"Login" WithVCName:@"JSPaswdLoginVC"];
            vc.hidesBottomBarWhenPushed = YES;
            [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
        }
        return NO;
    }
}

/**
 1、退出登录，2、是否跳转到登录页面
 
 @param isJumpLoginVC YES：跳转
 */
+ (void)logout:(BOOL)isJumpLoginVC {
    
    [[UserInfo share] setUserInfo:nil]; //清除用户信息
    
    if (isJumpLoginVC==YES) {
        UIViewController *vc = [Utils getViewController:@"Login" WithVCName:@"JSPaswdLoginVC"];
        vc.hidesBottomBarWhenPushed = YES;
        [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}

/**
 判断字符串是否为空
 
 @param string 字符串
 @return YES 空
 */
+ (BOOL)isBlankString:(id)string {
    
    string = [NSString stringWithFormat:@"%@",string];
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if([string isEqualToString:@"<null>"])
    {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return YES;
    }
    return NO;
}

/**
 仿安卓消息提示
 
 @param message 提示内容
 */
+ (void)showToast:(NSString *)message {
    [Toast showBottomWithText:message bottomOffset:HEIGHT/2 duration:1.5];
}

// 验证手机号
+ (BOOL)validateMobile:(NSString *)mobile {
    
    NSString *mobileRegex = @"^1[0123456789]\\d{9}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

/**
 设置控件阴影
 
 @param view 视图View
 */
+ (void)setViewShadowStyle:(UIView *)view {
    view.layer.shadowOffset =  CGSizeMake(0, 2); //阴影偏移量
    view.layer.shadowOpacity = 0.2; //透明度
    view.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    view.layer.shadowRadius = 5; //模糊度
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    [view.layer setMasksToBounds:NO];
}

/**
 设置按钮显示、点击效果
 
 @param btn 按钮
 @param shadow 是否显示阴影
 @param normalBorderColor 正常边框颜色
 @param selectedBorderColor 选中边框颜色
 @param borderWidth 边框宽度
 @param normalColor 正常按钮颜色
 @param selectedColor 选中按钮颜色
 @param radius 圆角
 */
- (void)setButtonClickStyle:(UIButton *)btn Shadow:(BOOL)shadow normalBorderColor: (UIColor *)normalBorderColor selectedBorderColor: (UIColor *)selectedBorderColor BorderWidth:(int)borderWidth normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor cornerRadius:(CGFloat)radius {
    
    _btnNormalColor = normalColor;
    _btnSelectedColor = selectedColor;
    _btnBorderNormalColor =normalBorderColor;
    _btnBorderSelectedColor =selectedBorderColor;
    btn.layer.borderColor =normalBorderColor.CGColor;
    [btn.layer setBorderWidth:borderWidth];
    btn.backgroundColor = normalColor;
    btn.layer.cornerRadius = radius;
    if (shadow == YES) {
        [Utils setViewShadowStyle:btn];
    }
    [btn addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)downClick:(UIButton *)button {
    button.layer.borderColor = _btnBorderSelectedColor.CGColor;
    button.backgroundColor = _btnSelectedColor;
    [button.layer setMasksToBounds:YES];
}

- (void)doneClick:(UIButton *)button {
    button.layer.borderColor = _btnBorderNormalColor.CGColor;
    button.backgroundColor = _btnNormalColor;
    [button.layer setMasksToBounds:NO];
}

/**
 屏幕快照
 
 @param view 视图View
 @return 屏幕截图
 */
+ (UIImage *)snapshotSingleView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIViewController *)getViewController:(NSString *)stordyName WithVCName:(NSString *)name{
    UIStoryboard *story = [UIStoryboard storyboardWithName:stordyName bundle:nil];
    return [story instantiateViewControllerWithIdentifier:name];
}

#pragma mark - 系统权限判断

+ (BOOL)isCameraPermissionOn {
    //相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [self permissionSetup:@"“匠神马帮”想访问您的相机"];
            return NO;
        } else {
            return YES;
        }
    } else {
        [Toast showBottomWithText:@"没有相机功能" bottomOffset:100.0 duration:1.2];
        return NO;
    }
}

+ (BOOL)isPhotoPermissionOn {
    if (![[TZImageManager manager] authorizationStatusAuthorized]) {
        [self permissionSetup:@"“匠神马帮”想访问您的相册"];
        return NO;
    } else {
        return YES;
    }
}

+ (void)checkAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"Error：%@",(__bridge NSError *)error);
                } else if (!granted) {
                    [self permissionSetup:@"“匠神马帮”想访问您的通讯录"];
                    block(NO);
                } else {
                    block(YES);
                }
            });
        });
    } else {
        block(YES);
    }
}

+ (void)checkMicrophoneAuthorization:(void (^)(bool isAuthorized))block {
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
        if (!granted){
            [self permissionSetup:@"“匠神马帮”想访问您的麦克风"];
            block(NO);
        } else {
            block(YES);
        }
    }];
}

//跳转到系统权限设置页面
+ (void)permissionSetup:(NSString *)title {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle: UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到系统设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    //弹出提示框；
    [[Utils getCurrentVC] presentViewController:alert animated:true completion:nil];
}

// 读取本地JSON文件
+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
