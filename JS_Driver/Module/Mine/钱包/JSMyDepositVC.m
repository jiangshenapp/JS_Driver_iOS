//
//  JSMyDepositVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyDepositVC.h"
#import "JSBillDetailsVC.h"
#import "JSWithdrawalMoneyVC.h"
#import "JSRechargeDepositVC.h"

@interface JSMyDepositVC ()

@end

@implementation JSMyDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的保证金";

    self.depositLab.text = self.accountInfo.driverDeposit;
}

- (IBAction)explainAction:(id)sender {
    [Utils showToast:@"违约说明"];
}

/*
#pragma mark - Navigation
 */

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"depositDetailID"]) {
        JSBillDetailsVC *vc = segue.destinationViewController;
        vc.type = 2;
    }
    if ([segue.identifier isEqualToString:@"depositWithdrawalID"]) {
        JSWithdrawalMoneyVC *vc = segue.destinationViewController;
        vc.maxMoney = self.accountInfo.driverDeposit;
        vc.withdrawType = @"1";
    }
    if ([segue.identifier isEqualToString:@"depositRechargeID"]) {
        JSRechargeDepositVC *vc = segue.destinationViewController;
        vc.accountInfo = self.accountInfo;
    }
}

@end
