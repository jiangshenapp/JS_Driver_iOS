//
//  SortView.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/24.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "SortView.h"

@interface SortView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataSource;
    CGFloat viewH;
}
/** 列表 */
@property (nonatomic,retain) UITableView *myTab;
;
@end

@implementation SortView

-(instancetype)initWithFrame:(CGRect)frame {
    CGRect frame1 = CGRectMake(0, kNavBarH+46, WIDTH, HEIGHT-kNavBarH-46);
    self = [super initWithFrame:frame1];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
    [myWindow addSubview:self];
    self.hidden = YES;
    self.clipsToBounds = YES;
    
    dataSource = @[@"默认排序",@"距离排序"];
    _myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    viewH = self.height;
    _myTab.delegate = self;
    _myTab.dataSource = self;
    [self addSubview:_myTab];
    _myTab.tableFooterView = [[UIView alloc]init];
    _myTab.tintColor = AppThemeColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sortcell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sortcell"];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.selected = NO;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = dataSource[indexPath.row];
    if ([cell.textLabel.text containsString:@"默认排序"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)showView {
    __weak typeof(self) weakSelf = self;
    weakSelf.height = 0;
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = self->viewH;
    } completion:^(BOOL finished) {
    }];
}


- (void)hiddenView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = 0;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
