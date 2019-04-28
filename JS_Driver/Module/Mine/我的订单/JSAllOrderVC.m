//
//  JSAllOrderVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/28.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSAllOrderVC.h"
#import "JSBaseOrderDetailsVC.h"
#import "JSReleaseOrderVC.h"

@interface JSAllOrderVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *classNameArr;
}
@end

@implementation JSAllOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    classNameArr = @[@"JSReleaseOrderVC",@"JSConfirmOrderVC",@"JSDeliveryOrderVC",@"JSCommentOrderVC",@"JSTransportOrderVC",@"JSFinishOrderVC",@"JSCancleOrderVC"];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return classNameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTabCell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JSBaseOrderDetailsVC *vc = (JSBaseOrderDetailsVC *)[Utils getViewController:@"Mine" WithVCName:@"JSBaseOrderDetailsVC"];;
//    JSReleaseOrderVC *vc = [UIViewController alloc]initw;
    [self.navigationController pushViewController:vc animated:YES];
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
    for (NSInteger tag = 100; tag<105; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        btn.selected = [btn isEqual:sender]?YES:NO;;
    }
}
@end

@implementation MyOrderTabCell

@end
