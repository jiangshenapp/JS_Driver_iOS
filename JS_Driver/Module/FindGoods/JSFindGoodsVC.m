//
//  JSFindGoodsVC.m
//  JS_Driver
//
//  Created by Jason_zyl on 2019/3/6.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSFindGoodsVC.h"
#import "CityCustomView.h"
#import "SortView.h"
#import "FilterCustomView.h"


@interface JSFindGoodsVC ()
{
    NSArray *titleArr1;
    NSArray *titleViewArr;
    CityCustomView *cityView1;
    CityCustomView *cityView2;
    SortView *mySortView;
    FilterCustomView *filteView;
}
/** 区域编码1 */
@property (nonatomic,copy) NSString *areaCode1;
/** 区域编码2 */
@property (nonatomic,copy) NSString *areaCode2;
@end

@implementation JSFindGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找货";
     titleArr1 = @[@"发货地",@"收货地",@"默认排序",@"筛选"];
     CGFloat btW = WIDTH/4.0;
    for (NSInteger index = 0; index<titleArr1.count; index++) {
        FilterButton *sender = [[FilterButton alloc]initWithFrame:CGRectMake(index*btW, 0, btW, self.filterView.height)];
        sender.tag = 20000+index;
        [sender setTitle:titleArr1[index] forState:UIControlStateNormal];
        [sender addTarget:self action:@selector(showViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterView addSubview:sender];
    }
    __weak typeof(self) weakSelf = self;
    cityView1 = [[CityCustomView alloc]init];
    cityView1.getCityData = ^(NSDictionary * _Nonnull dataDic) {
         FilterButton *tempBtn = [weakSelf.view viewWithTag:20000];
        tempBtn.isSelect = NO;
        [tempBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
        weakSelf.areaCode1 = dataDic[@"code"];
    };
    cityView2 = [[CityCustomView alloc]init];
    cityView2.getCityData = ^(NSDictionary * _Nonnull dataDic) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20001];
        [tempBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
        weakSelf.areaCode2 = dataDic[@"code"];
        tempBtn.isSelect = NO;
    };
    mySortView = [[SortView alloc]init];
    filteView = [[FilterCustomView alloc]init];
    titleViewArr = @[cityView1,cityView2,mySortView,filteView];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(btW-10, (self.filterView.height-5)/2.0, 20, 5)];
    imgView.image = [UIImage imageNamed:@"home_tab_icon_go"];
    [self.filterView addSubview:imgView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindGoodsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindGoodsTabCell"];
    return cell;
}

- (void)showViewAction:(FilterButton *)sender {
    sender.userInteractionEnabled = NO;
     sender.isSelect = !sender.isSelect;
    for (NSInteger index = 0; index<4; index++) {
        FilterButton *tempBtn = [self.view viewWithTag:20000+index];
        BaseCustomView *vv = titleViewArr[index];
        if (![sender isEqual:tempBtn]) {
            tempBtn.isSelect = NO;
            [vv hiddenView];
        }
        else {
            if (sender.isSelect) {
                [vv showView];
            }
            else {
                [vv hiddenView];
            }
        }
    }
    sender.userInteractionEnabled = YES;
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

@implementation FindGoodsTabCell

@end

@implementation FilterButton
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width-20, self.height)];
    _titleLab.textAlignment = NSTextAlignmentRight;
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.minimumScaleFactor = 0.5;
    _titleLab.adjustsFontSizeToFitWidth=YES;
    [self addSubview:_titleLab];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-15, (self.height-4)/2.0, 6, 4)];
    _imgView.image = [UIImage imageNamed:@"app_tab_arrow_down"];
    [self addSubview:_imgView];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    _titleLab.text = title;
}
-(void)setIsSelect:(BOOL)isSelect {
    if (_isSelect!=isSelect) {
        _isSelect = isSelect;
    }
    if (isSelect) {
        _titleLab.textColor = AppThemeColor;
        _imgView.image = [UIImage imageNamed:@"app_tab_arrow_up"];
    }
    else {
        _titleLab.textColor = kBlackColor;
        _imgView.image = [UIImage imageNamed:@"app_tab_arrow_down"];
    }
}


@end
