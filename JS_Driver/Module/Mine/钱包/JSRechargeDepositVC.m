//
//  JSRechargeDepositVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/7.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSRechargeDepositVC.h"

@interface JSRechargeDepositVC ()

@end

@implementation JSRechargeDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴纳保证金";
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ExplainAction:(UIButton *)sender {
}

- (IBAction)payTypeAction:(UIButton *)sender {
}

- (IBAction)touchAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)rechagreBtnAction:(UIButton *)sender {
}

- (IBAction)showAgreeProtocolAction:(UIButton *)sender {
}
@end
