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
#import "JSOrderDetailsVC.h"

@interface JSFindGoodsVC ()<CLLocationManagerDelegate>
{
    NSArray *titleArr1;
    NSArray *titleViewArr;
    CityCustomView *cityView1;
    CityCustomView *cityView2;
    SortView *mySortView;
}
/** 分页 */
@property (nonatomic,assign) NSInteger page;
/** 区域编码1 */
@property (nonatomic,copy) NSString *areaCode1;
/** 区域编码2 */
@property (nonatomic,copy) NSString *areaCode2;
/** 筛选视图 */
@property (nonatomic,retain) FilterCustomView *myfilteView;;
/** 筛选条件 */
@property (nonatomic,retain) NSDictionary *allDicKey;
/** 排序，1发货时间 2距离; */
@property (nonatomic,copy) NSString *sort;
/** 列表数据源 */
@property (nonatomic,retain) NSMutableArray <OrderInfoModel *>*dataSource;

@property (retain, nonatomic) CLLocationManager* locationManager;
/** 当前经纬度 */
@property (nonatomic,assign) CLLocationCoordinate2D currentLoc;
@end

@implementation JSFindGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找货";
    [self setupView];
    [self getDicList];
    [self getNetData];
    [self startLocation];
}

-(void)setupView {
    _page = 1;
    _areaCode1 = @"";
    _areaCode2 = @"";
    _sort = @"2";
    _dataSource = [NSMutableArray array];
    NSDictionary *locDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"loc"];
    _currentLoc = CLLocationCoordinate2DMake([locDic[@"lat"] floatValue], [locDic[@"lng"] floatValue]);
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
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    cityView2 = [[CityCustomView alloc]init];
    cityView2.getCityData = ^(NSDictionary * _Nonnull dataDic) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20001];
        [tempBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
        weakSelf.areaCode2 = dataDic[@"code"];
        tempBtn.isSelect = NO;
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    mySortView = [[SortView alloc]init];
    mySortView.getSortString = ^(NSString * _Nonnull sorts) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20002];
        tempBtn.selected = NO;
        if ([sorts containsString:@"默认"]) {
            weakSelf.sort = @"1";
        }
        else {
            weakSelf.sort = @"2";
        }
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    _myfilteView = [[FilterCustomView alloc]init];
    _myfilteView.getPostDic = ^(NSDictionary * _Nonnull dic, NSArray * _Nonnull titles) {
        FilterButton *tempBtn = [weakSelf.view viewWithTag:20003];
        tempBtn.selected = NO;
        weakSelf.allDicKey = dic;
        [weakSelf.baseTabView.mj_header beginRefreshing];
    };
    titleViewArr = @[cityView1,cityView2,mySortView,_myfilteView];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(btW-10, (self.filterView.height-5)/2.0, 20, 5)];
    imgView.image = [UIImage imageNamed:@"home_tab_icon_go"];
    [self.filterView addSubview:imgView];
    
    self.baseTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getNetData];
    }];
    self.baseTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getNetData];
    }];
}

#pragma mark - 获取数据
- (void)getNetData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_areaCode2 forKey:@"arriveAddressCode"];
    [dic setObject:_areaCode1 forKey:@"startAddressCode"];
    [dic setObject:_sort forKey:@"sort"];
    [dic addEntriesFromDictionary:self.allDicKey];
    NSString *url = [NSString stringWithFormat:@"%@?current=%ld&size=%@",URL_Find,_page,PageSize];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (weakSelf.page==1) {
            [weakSelf.dataSource removeAllObjects];
        }
        NSArray *arr;
        if (status == Request_Success) {
            arr = [OrderInfoModel mj_objectArrayWithKeyValuesArray:responseData[@"records"]];
        }
        if (weakSelf.dataSource.count<[responseData[@"total"] integerValue]) {
            [weakSelf.dataSource addObjectsFromArray:arr];
            weakSelf.page++;
        }
        [weakSelf.baseTabView reloadData];
        if ([weakSelf.baseTabView.mj_footer isRefreshing]) {
            [weakSelf.baseTabView.mj_footer endRefreshing];
        }
        if ([weakSelf.baseTabView.mj_header isRefreshing]) {
            [weakSelf.baseTabView.mj_header endRefreshing];
        }
        
    }];
}

#pragma mark - 获取数据
- (void)getDicList {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_GetDictList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.myfilteView.dataDic = responseData;
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindGoodsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindGoodsTabCell"];
    OrderInfoModel *model = self.dataSource[indexPath.row];
    NSString *useCarType = model.useCarTypeName;
    cell.orderNOLab.text = [NSString stringWithFormat:@"订单编号：%@ %@",model.ID,useCarType];
    if (useCarType.length>0) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:cell.orderNOLab.text];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBValue(0x7ED321) range:NSMakeRange(cell.orderNOLab.text.length-useCarType.length, useCarType.length)];
        cell.orderNOLab.attributedText = attributeStr;
    }
   
    cell.timeLab.text = [Utils getTimeStrToCurrentDateWith:model.createTime];
    [cell.startDotNameLab setTitle:model.sendAddress forState:UIControlStateNormal];
    [cell.endDotNameLab setTitle:model.receiveAddress forState:UIControlStateNormal];
    cell.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.fee floatValue]];
    NSString *infoStr = [NSString stringWithFormat:@"%@ %@/%@方/%@吨",model.carModelName,model.carLengthName,model.goodsVolume,model.goodsWeight];
    cell.orderCarInfoLab.text = infoStr;
    
    NSDictionary *locDic = [Utils dictionaryWithJsonString:model.sendPosition];
    NSString *distanceStr = [NSString stringWithFormat:@"距离您：%@",[Utils distanceBetweenOrderBy:_currentLoc.latitude :[locDic[@"latitude"] floatValue] :_currentLoc.longitude :[locDic[@"longitude"] floatValue]]];
    cell.getGoodsTimeLab.text = [NSString stringWithFormat:@"装货时间：%@ %@",model.loadingTime,distanceStr];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:cell.getGoodsTimeLab.text];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBValue(0x4A90E2) range:NSMakeRange(cell.getGoodsTimeLab.text.length-distanceStr.length, distanceStr.length)];
    cell.getGoodsTimeLab.attributedText = attributeStr;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    OrderInfoModel *model = self.dataSource[indexPath.row];
    JSOrderDetailsVC *vc = (JSOrderDetailsVC *)[Utils getViewController:@"Mine" WithVCName:@"JSOrderDetailsVC"];;
    vc.orderID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark 定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {//判断定位操作是否被允许
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;//遵循代理
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8以上版本定位需要）
        [self.locationManager startUpdatingLocation];//开始定位
    }else{//不能定位用户的位置的情况再次进行判断，并给与用户提示
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.locationManager stopUpdatingLocation];
    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    _currentLoc = currLocation.coordinate;
    NSDictionary *locDic = @{@"lat":@(_currentLoc.latitude),@"lng":@(_currentLoc.longitude)};
    [[NSUserDefaults standardUserDefaults]setObject:locDic forKey:@"loc"];;
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
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

- (instancetype)initWithFrame:(CGRect)frame {
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

- (void)setIsSelect:(BOOL)isSelect {
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
