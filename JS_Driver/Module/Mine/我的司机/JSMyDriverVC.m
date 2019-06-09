
//
//  JSMyDriverVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSMyDriverVC.h"

@interface JSMyDriverVC ()<UITableViewDelegate,UITableViewDataSource>
/** <#object#> */
@property (nonatomic,retain) NSMutableArray *listData;
@end

@implementation JSMyDriverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的司机";
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [sender setTitle:@"添加司机" forState:UIControlStateNormal];
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:14];
    [sender addTarget:self action:@selector(addviewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    image.image = [UIImage imageNamed:@"consignee_icon_name"];
    self.searchTF.leftView = image;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    [self getData];
}

-(void)getData {
    self.listData = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_Drivers] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
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
    MyDriverTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyDriverTabCell"];
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
    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
    [myWindow addSubview:_addView];
    _addContentView.top = HEIGHT;
    _bgShdowView.alpha = 0.0;
    _addView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bgShdowView.alpha = 1.0;
        weakSelf.addContentView.center = CGPointMake(WIDTH/2.0, HEIGHT/2.0);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancleAddAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.bgShdowView.alpha = 0.0;
        weakSelf.addContentView.top = HEIGHT;;
    } completion:^(BOOL finished) {
        weakSelf.addView.hidden = YES;
    }];
}

- (IBAction)addDriverAction:(id)sender {
    [self cancleAddAction:nil];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_AddDriver] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"添加成功"];
            [weakSelf getData];
        }
        [weakSelf.baseTabView reloadData];
    }];
}
- (IBAction)cancleSearchAction:(UIButton *)sender {
}
@end
@implementation MyDriverTabCell


@end
