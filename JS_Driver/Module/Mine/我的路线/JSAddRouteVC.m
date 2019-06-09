//
//  JSAddRouteVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSAddRouteVC.h"
#import "CityCustomView.h"
#import "FilterCustomView.h"

@interface JSAddRouteVC ()
/** yes 起点   */
@property (nonatomic,assign) BOOL isStart;
/** 起止点 */
@property (nonatomic,retain)CityCustomView *cityView1;
/** 筛选 */
@property (nonatomic,retain) FilterCustomView *myfilteView;
/** 起点code */
@property (nonatomic,copy) NSString *areaCode1;
/** 终点code */
@property (nonatomic,copy) NSString *areaCode2;
/** fliter数据源 */
@property (nonatomic,retain) NSMutableDictionary *dataDic;
/** 车长数组 */
@property (nonatomic,retain) NSArray *carLengthArr;
/** 车型数组 */
@property (nonatomic,retain) NSArray *carModelArr;
/** 筛选的字典 */
@property (nonatomic,retain) NSDictionary *postDic;
@end

@implementation JSAddRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PageColor;
    self.title = @"添加路线";
    [self setupView];
    [self getCarModelInfo];
    [self getCarLengthInfo];
    // Do any additional setup after loading the view.
}

-(void)setupView {
    _areaCode1 = @"";
    _areaCode2 = @"";
    __weak typeof(self) weakSelf = self;
    _cityView1 = [[CityCustomView alloc]init];
    _cityView1.top = kNavBarH;
    _cityView1.viewHeight = HEIGHT-kNavBarH;
    _cityView1.getCityData = ^(NSDictionary * _Nonnull dataDic) {
        if (weakSelf.isStart) {
            [ weakSelf.addStartBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
            weakSelf.areaCode1 = dataDic[@"code"];
        }
        else {
            [ weakSelf.addEndBtn setTitle:dataDic[@"address"] forState:UIControlStateNormal];
            weakSelf.areaCode2 = dataDic[@"code"];
        }
    };
    _myfilteView = [[FilterCustomView alloc]init];\
    _myfilteView.getPostDic = ^(NSDictionary * _Nonnull dic, NSArray * _Nonnull titles) {
        weakSelf.postDic = dic;
    };
    _dataDic = [NSMutableDictionary dictionary];
}

#pragma mark - 车长
/** 车长 */
- (void)getCarLengthInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?type=carLength",URL_GetDictByType];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSArray *arr = responseData;
            if ([arr isKindOfClass:[NSArray class]]) {
                [weakSelf.dataDic setObject:arr forKey:@"carLength"];
            }
        }
    }];
}

#pragma mark - 车型
/** 车型 */
- (void)getCarModelInfo {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@?type=carModel",URL_GetDictByType];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            NSArray *arr = responseData;
            if ([arr isKindOfClass:[NSArray class]]) {
                [weakSelf.dataDic setObject:arr forKey:@"carModel"];
            }
        }
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

- (IBAction)addStartAddressAction:(UIButton *)sender {
    _isStart = YES;
    [_cityView1 showView];
}

- (IBAction)addEndAddressAction:(UIButton *)sender {
    _isStart = NO;
    [_cityView1 showView];
}

- (IBAction)selectCarTypeAction:(UIButton *)sender {
    self.myfilteView.dataDic = self.dataDic;
    [_myfilteView showView];
}

- (IBAction)addRouteAction:(UIButton *)sender {
    NSString *remark = @"";
    if (_areaCode2.length==0) {
        [Utils showToast:@"请选择目的地"];
        return;
    }
    if (_areaCode1.length==0) {
        [Utils showToast:@"请选择出发地"];
        return;
    }
    if (_contentTv.text.length>0) {
        remark = _contentTv.text;
    }
   
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:_postDic];
    [dic addEntriesFromDictionary:_postDic];
    [dic setObject:_areaCode1 forKey:@"startAddressCode"];
    [dic setObject:_areaCode2 forKey:@"arriveAddressCode"];
    [dic setObject:remark forKey:@"remark"];
    NSString *url = [NSString stringWithFormat:@"%@",URL_AddMyLines];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            [Utils showToast:@"添加成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}
@end
