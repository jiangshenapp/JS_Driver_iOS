//
//  JSMyDepositVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyDepositVC.h"
#import "JSBillDetailsVC.h"

@interface JSMyDepositVC ()

@end

@implementation JSMyDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的保证金";

    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation
 */

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"despositID"]) {
        JSBillDetailsVC *vc = segue.destinationViewController;
        vc.type = 2;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
