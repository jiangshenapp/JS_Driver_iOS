//
//  JSMyCarVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyCarVC.h"
#import "JSAddCarVC.h"

@interface JSMyCarVC ()

@end

@implementation JSMyCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车辆";
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [sender setTitle:@"添加车辆" forState:UIControlStateNormal];
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:14];
    [sender addTarget:self action:@selector(addCarAction) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    image.image = [UIImage imageNamed:@"consignee_icon_name"];
    self.searchTF.leftView = image;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCarTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarTabCell"];
    return cell;
}

- (void)addCarAction {
    JSAddCarVC *vc = [Utils getViewController:@"Mine" WithVCName:@"JSAddCarVC"];
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

- (IBAction)cancleSearchTF:(UIButton *)sender {
}
@end

@implementation MyCarTabCell


@end
