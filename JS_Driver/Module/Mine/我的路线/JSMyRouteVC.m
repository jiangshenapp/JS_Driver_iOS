//
//  JSMyRouteVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyRouteVC.h"
#import "JSAddRouteVC.h"
#import "JSMyRouteDetailVC.h"

@interface JSMyRouteVC ()
/** <#object#> */
@property (nonatomic,retain) NSMutableArray *listData;
@end

@implementation JSMyRouteVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的路线";
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
    NSString *jingpin = [dic[@"classic"] integerValue]==1?@"精品":@"";
    cell.infoLab.text = [NSString stringWithFormat:@"%@ %@ %@",jingpin,dic[@"carLengthName"],dic[@"carModelName"]];
    if ([dic[@"classic"] integerValue]==1) {
        // 创建Attributed
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:cell.infoLab.text];
        // 改变颜色
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGBValue(0xD0021B) range:NSMakeRange(0,2)];
        cell.infoLab.attributedText = noteStr;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.listData[indexPath.row];
    JSMyRouteDetailVC *vc = (JSMyRouteDetailVC *)[Utils getViewController:@"Mine" WithVCName:@"JSMyRouteDetailVC"];
    vc.routeID = [NSString stringWithFormat:@"%@",dic[@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
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
        [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_MyLines] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"解绑成功"];
                [weakSelf getData];
            }
            [weakSelf.baseTabView reloadData];
        }];
    }
}

//设置返回存放侧滑按钮数组
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //这是iOS8以后的方法
    UITableViewRowAction *deleBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    
    
    UITableViewRowAction *moreBtn = [UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    }];
    //设置背景颜色，他们的大小会分局文字内容自适应，所以不用担心
    deleBtn.backgroundColor = RGBValue(0xD0021B);
    moreBtn.backgroundColor = RGBValue(0x4A90E2);
    return @[deleBtn,moreBtn];
    
}

- (void)addviewAction {
    JSAddRouteVC *vc = (JSAddRouteVC *)[Utils getViewController:@"Mine" WithVCName:@"JSAddRouteVC"];
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
