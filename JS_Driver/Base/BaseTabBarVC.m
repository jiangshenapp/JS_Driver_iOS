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

//创建tabbar
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
        nv.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中时的图片
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_pre",picArr[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置选中时字体的颜色(也可更改字体大小)
        [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:AppThemeColor} forState:UIControlStateSelected];
        [nv.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [array addObject:nv];
    }
    self.viewControllers = array;
}

@end
