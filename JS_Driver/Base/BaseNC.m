//
//  BaseNC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseNC.h"

@interface BaseNC () <UINavigationControllerDelegate>

@end

@implementation BaseNC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置UINavigationBar的样式
    [[UINavigationBar appearance] setTintColor:kBlueColor];
    [UINavigationBar appearance].barTintColor=[UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:kTitleColor}];
    //将导航条默认黑线改成阴影
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage imageNamed:@"NavbarShadow"]; //阴影图片
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *controllerArr = @[@"JSFindGoodsVC",@"JSServiceVC",@"JSMessageVC",@"JSCommunityVC",@"JSMineVC"];
    if (![controllerArr containsObject:NSStringFromClass(viewController.class)]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
