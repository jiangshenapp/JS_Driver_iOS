//
//  AppDelegate.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/5.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarVC.h"
#import <IQKeyboardManager.h>
#import "NetworkUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import <UserNotifications/UserNotifications.h>
#import "CustomEaseUtils.h"
#import "EMNotificationHelper.h"

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //监测网络
    [[NetworkUtil sharedInstance] listening];
    
    //键盘事件
    [self processKeyBoard];
    
    [self initEmData];
    
    NSString *WechatDescription = @"微信注册";
    [WXApi registerApp:kWechatKey withDescription:WechatDescription];
    
    //解决tabbar上移
    [[UITabBar appearance] setTranslucent:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tabVC = [[BaseTabBarVC alloc] init];
    _tabVC.delegate = self;
    self.window.rootViewController = _tabVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)processKeyBoard {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

#pragma mark - 支付宝、微信支付回调

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self applicationOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self applicationOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {
    return [self applicationOpenURL:url];
}

- (BOOL)applicationOpenURL:(NSURL *)url {
    
    //支付宝回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSInteger status = [resultDic[@"resultStatus"] integerValue];
            
            switch (status) {
                case 9000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccNotification object:nil];
                    break;
                    
                case 8000:
                    [Utils showToast:@"订单正在处理中"];
                    break;
                    
                case 4000:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailNotification object:nil];
                    break;
                    
                case 6001:
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotification object:nil];
                    break;
                    
                case 6002:
                    [Utils showToast:@"网络连接出错"];
                    break;
                    
                default:
                    break;
            }
        }];
        return YES;
    }
    
    //微信支付回调
    if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay",kWechatKey]].location == 0) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark - WXApiDelegate

-(void)onResp:(BaseResp *)resp {
    //微信支付信息
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *payResp = (PayResp *)resp;
        
        NSLog(@"微信支付成功回调：%d",payResp.errCode);
        
        switch (payResp.errCode) {
            case 0:
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccNotification object:nil];
                break;
            case -1:
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailNotification object:nil];
                break;
            case -2:
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayCancelNotification object:nil];
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //这里我判断的是当前点击的tabBarItem的标题
    NSString *tabBarTitle = viewController.tabBarItem.title;
    if ([tabBarTitle isEqualToString:@"我的"]) {
        if ([Utils isLoginWithJump:YES]) {
            return YES;
        } else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

- (void)initEmData {
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:ACCOUNT_LOGIN_CHANGED object:nil];
    //注册推送
    [self _registerRemoteNotification];
    
    EMOptions *options = [EMOptions optionsWithAppkey:EaseMobKey];
    options.apnsCertName = @"";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [CustomEaseUtils shareHelper];
    [EMNotificationHelper shared];
    
}

//注册远程通知
- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

- (void)loginStateChange:(NSNotification *)aNotif
{
    UINavigationController *navigationController = nil;
    
    BOOL loginSuccess = [aNotif.object boolValue];
    if (loginSuccess) {//登录成功加载主窗口控制器
        navigationController = (UINavigationController *)self.window.rootViewController;
    } else {//登录失败加载登录页面控制器
        [Utils logout:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStateChangeNotification object:@NO];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
