//
//  JSMyInfoVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/29.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSMyInfoVC.h"

@interface JSMyInfoVC ()

@end

@implementation JSMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户中心";
    // Do any additional setup after loading the view.
}

#pragma mark - methods
/* 安全退出 */
- (IBAction)logoutAction:(id)sender {
    [Utils logout:YES];
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
