//
//  JSAuthenticationVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSAuthenticationVC.h"

@interface JSAuthenticationVC ()
{
    BOOL isPerson;//判断是个人还是公司
}
@end

@implementation JSAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"货主身份认证";
    isPerson = YES;
    self.baseTabView.tableHeaderView = _personTabHeadView;
//    [self.baseTabView addSubview:_personTabHeadView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)titleViewAction:(UIButton *)sender {
    isPerson = sender.tag==100?YES:NO;
    for (NSInteger tag = 100; tag<102; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        if ([btn isEqual:sender]) {
            btn.backgroundColor = AppThemeColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    _personTabHeadView.hidden = !isPerson;
    _companyTabHeadView.hidden = isPerson;
    if (isPerson) {
        [self.baseTabView addSubview:_personTabHeadView];
    }
    else {
        [self.baseTabView addSubview:_companyTabHeadView];
    }
    [self.baseTabView setContentOffset:CGPointMake(0, 0)];
}
@end
