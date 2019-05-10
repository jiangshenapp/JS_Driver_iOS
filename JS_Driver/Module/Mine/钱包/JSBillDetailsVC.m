//
//  JSBillDetailsVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/27.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSBillDetailsVC.h"

@interface JSBillDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JSBillDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单明细";
    if (_type>0) {
        UIButton *sender = [self.view viewWithTag:100+_type];
        [self titleBtnAction:sender];
    }
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSBillListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JSBillListTabCell1"];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)titleBtnAction:(UIButton *)sender {
    for (NSInteger index = 100; index<103; index++) {
        UIButton *tampBtn = [self.view viewWithTag:index];
        tampBtn.selected = NO;
    }
    sender.selected = YES;
    _type = sender.tag-100;
}
@end
@implementation JSBillListTabCell

@end
