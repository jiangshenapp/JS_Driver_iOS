//
//  BaseTabBarVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseTabBarVC.h"
#import "BaseNC.h"

@interface BaseTabBarVC ()

@end

@implementation BaseTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabBar];
}

- (void)createTabBar {
    //视图数组
    NSArray *controllerArr = @[@"JSFindGoodsVC",@"JSRouteVC",@"JSMessageVC",@"JSServiceVC",@"JSMineVC"];
    //标题数组
    NSArray *titleArr = @[@"找货",@"路线",@"消息",@"服务",@"我的"];
    //图片数组
    NSArray *picArr = @[@"nav_home",@"nav_chat",@"nav_search",@"nav_mine",@"nav_mine"];
    //storyboard name 数组
    NSArray *storyArr = @[@"FindGoods",@"Route",@"Message",@"Service",@"Mine"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0; i<picArr.count; i++) {
        UIViewController *controller = [[UIStoryboard storyboardWithName:storyArr[i] bundle:nil] instantiateViewControllerWithIdentifier:controllerArr[i]];
        controller.title = titleArr[i];
        
        BaseNC *nv = [[BaseNC alloc] initWithRootViewController:controller];
        nv.tabBarItem.title = titleArr[i];
        nv.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_pre",picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [array addObject:nv];
    }
    
    //设置字体的颜色和大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:AppThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateNormal];
    
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kTabBarH)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:barBgView atIndex:0];
    self.tabBar.opaque = YES;
    
    self.viewControllers = array;
}

@end
