//
//  JSMyRouteVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyRouteVC.h"
#import "JSAddRouteVC.h"

@interface JSMyRouteVC ()
/** <#object#> */
@property (nonatomic,retain) NSMutableArray *listData;
@end

@implementation JSMyRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [sender setTitle:@"添加路线" forState:UIControlStateNormal];
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:14];
    [sender addTarget:self action:@selector(addviewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    image.image = [UIImage imageNamed:@"consignee_icon_name"];
    self.searchTF.leftView = image;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData {
    self.listData = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_MyLines] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            if ([responseData[@"records"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = responseData[@"records"];
                [weakSelf.listData addObjectsFromArray:arr];
            }
        }
        [weakSelf.baseTabView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRouteTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRouteTabCell"];
    NSDictionary *dic = self.listData[indexPath.row];
    [cell.startAddressBtn setTitle:dic[@"startAddressCodeName"] forState:UIControlStateNormal];
    [cell.endAddressBtn setTitle:dic[@"startAddressCodeName"] forState:UIControlStateNormal];

    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"解绑";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_DelectDriver] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"解绑成功"];
                [weakSelf getData];
            }
            [weakSelf.baseTabView reloadData];
        }];
    }
}

- (void)addviewAction {
    JSAddRouteVC *vc = [Utils getViewController:@"Mine" WithVCName:@"JSAddRouteVC"];
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

@end
@implementation MyRouteTabCell

@end
