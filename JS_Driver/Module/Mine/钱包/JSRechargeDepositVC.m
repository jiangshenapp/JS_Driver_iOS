//
//  JSRechargeDepositVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/7.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSRechargeDepositVC.h"

@interface JSRechargeDepositVC ()
/** 支付方式 0 支付宝  1微信  2账户余额 */
@property (nonatomic,assign) NSInteger payType;

@end

@implementation JSRechargeDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴纳保证金";
    _payType = 0;
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
    for (NSInteger index = 100; index<103; index++) {
        UIButton *tampBtn = [self.view viewWithTag:index];
        tampBtn.selected = NO;
    }
    sender.selected = YES;
    _payType = sender.tag-100;
}

- (IBAction)touchAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)rechagreBtnAction:(UIButton *)sender {
}

- (IBAction)showAgreeProtocolAction:(UIButton *)sender {
    NSLog(@"协议");
}
@end
