//
//  JSAddCarVC.m
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "JSAddCarVC.h"
#import "TZImagePickerController.h"
#import "ZHPickView.h"
#import "JSMyCarVC.h"
#import <UIButton+WebCache.h>

@interface JSAddCarVC ()
{
    NSMutableArray *carLengthNameArr;
    NSMutableArray *carModelNameArr;
    __block NSInteger imageType;
}
/** 车长数组 */
@property (nonatomic,retain) NSArray *carLengthArr;
/** 车型数组 */
@property (nonatomic,retain) NSArray *carModelArr;
/** 当前车类型 */
@property (nonatomic,copy) NSString *useCarTypeStr;
/** 当前车类型 */
@property (nonatomic,copy) NSString *useCarLengthStr;
/** 图1 */
@property (nonatomic,copy) NSString *image1;
/** 图2 */
@property (nonatomic,copy) NSString *image2;
/** 车数据 */
@property (nonatomic,retain) MyCarInfoModel *carModel;
@end

@implementation JSAddCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加车辆";
    if (![NSString isEmpty:_carDetaileID]) {
        self.title = @"车辆详情";
        _rightBtn1.hidden = YES;
        _rightBtn2.hidden = YES;
        _carModelBtn.hidden = YES;
        _carLengthModelBtn.hidden = YES;
        [_submitBtn setTitle:@"解绑" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = RGBValue(0xD0021B);
        _carNumLab.userInteractionEnabled = NO;
        _carWeightTF.userInteractionEnabled = NO;
        _carSpaceTF.userInteractionEnabled = NO;
        
        [self getData];
    }
    else {
        _useCarTypeStr = @"";
        _useCarLengthStr = @"";
        [self getCarModelInfo];
        [self getCarLengthInfo];
    }
    
    // Do any additional setup after loading the view.
}

-(void)getData {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_GetCarDetail,_carDetaileID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status==Request_Success) {
            weakSelf.carModel = [MyCarInfoModel mj_objectWithKeyValues:responseData];
            [weakSelf refrehsUI];
        }
    }];
}

- (void)refrehsUI {
    _carNumLab.text = _carModel.cphm;
    _carTypeLab.text = _carModel.carModelName;
    _carLengthLab.text = _carModel.carLengthName;
    _carSpaceTF.text = [NSString stringWithFormat:@"%@方",_carModel.capacityVolume];
    _carWeightTF.text = [NSString stringWithFormat:@"%@吨",_carModel.capacityTonnage];
    [self.carDriverBtn sd_setImageWithURL:[NSURL URLWithString:_carModel.image1] forState:UIControlStateNormal placeholderImage:DefaultImage];
    [self.carHeadIMgBtn sd_setImageWithURL:[NSURL URLWithString:_carModel.image2] forState:UIControlStateNormal placeholderImage:DefaultImage];
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
                weakSelf.carLengthArr = [NSArray arrayWithArray:arr];
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
                weakSelf.carModelArr = [NSArray arrayWithArray:arr];
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

- (IBAction)carDrivingLicenseAction:(UIButton *)sender {
    imageType = 1;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:nil];;
    vc.naviTitleColor = kBlackColor;
    vc.barItemTextColor = AppThemeColor;
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            UIImage *firstimg = [photos firstObject];
            [sender setImage:firstimg forState:UIControlStateNormal];
            [weakSelf postImage:firstimg];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)carHeadImgAction:(UIButton *)sender {
    if (_carDetaileID.length>0) {
        return;
    }
    imageType = 2;
    __weak typeof(self) weakSelf = self;
    TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:nil];;
    vc.naviTitleColor = kBlackColor;
    vc.barItemTextColor = AppThemeColor;
    vc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count>0) {
            UIImage *firstimg = [photos firstObject];
            [sender setImage:firstimg forState:UIControlStateNormal];
            [weakSelf postImage:firstimg];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)postImage:(UIImage *)iconImage {
    if (_carDetaileID.length>0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.01);
    NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
    [[NetworkManager sharedManager] postJSON:URL_FileUpload parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NSString *photo = responseData;
            if (imageType==1) {
                weakSelf.image1 = photo;
            }
            else if (imageType==2) {
                weakSelf.image2 = photo;
            }
        }
    }];
}

- (IBAction)selectCarTypeAction:(id)sender {
    [self.view endEditing:YES];
    carModelNameArr = [NSMutableArray array];
    for (NSDictionary *dic in self.carModelArr) {
        [carModelNameArr addObject:dic[@"label"]];
    }
    __weak typeof(self) weakSelf = self;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:carModelNameArr title:@"车型"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr) {
        weakSelf.carTypeLab.text = selectedStr;
        NSInteger index = [carModelNameArr indexOfObject:selectedStr];
        weakSelf.useCarTypeStr = weakSelf.carModelArr[index][@"value"];
    };
}

- (IBAction)selectCarLengthAction:(id)sender {
    [self.view endEditing:YES];
    carLengthNameArr = [NSMutableArray array];
    for (NSDictionary *dic in self.carLengthArr) {
        [carLengthNameArr addObject:dic[@"label"]];
    }
    __weak typeof(self) weakSelf = self;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:carLengthNameArr title:@"车长"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr) {
        weakSelf.carLengthLab.text = selectedStr;
        NSInteger index = [carLengthNameArr indexOfObject:selectedStr];
        weakSelf.useCarLengthStr = weakSelf.carLengthArr[index][@"value"];
    };
}

- (void)UntyingCar {
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_carWeightTF.text forKey:@"capacityTonnage"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_UnbindingCar,_carDetaileID];
    [[NetworkManager sharedManager] postJSON:url parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"解绑成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddCarSuccNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)submitDataAction:(id)sender {
    if (_carDetaileID.length>0) {
        [self UntyingCar];
        return;
    }
    if (_carNumLab.text.length==0) {
        [Utils showToast:@"请输入车牌号码"];
        return;
    }
    if (_carTypeLab.text.length==0) {
        [Utils showToast:@"请选择车型"];
        return;
    }
    if (_carLengthLab.text.length==0) {
        [Utils showToast:@"请选择车长"];
        return;
    }
    if (_carWeightTF.text.length==0) {
        [Utils showToast:@"请输入载货重量"];
        return;
    }
    if (_carSpaceTF.text.length==0) {
        [Utils showToast:@"请输入载货空间"];
        return;
    }
    if (_image1.length==0) {
        [Utils showToast:@"请拍照上传车辆行驶证"];
        return;
    }
    if (_image2.length==0) {
        [Utils showToast:@"请拍照上传车头照"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_carWeightTF.text forKey:@"capacityTonnage"];
    [dic setObject:_carSpaceTF.text forKey:@"capacityVolume"];
    [dic setObject:_useCarLengthStr forKey:@"carLengthId"];
    [dic setObject:_useCarTypeStr forKey:@"carModelId"];
    [dic setObject:_carNumLab.text forKey:@"cphm"];
    [dic setObject:_image1 forKey:@"image1"];
    [dic setObject:_image2 forKey:@"image2"];
    [dic setObject:@"0" forKey:@"state"];
    [[NetworkManager sharedManager] postJSON:[NSString stringWithFormat:@"%@",URL_AddCar] parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            [Utils showToast:@"提交审核成功，请等待审核结果"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddCarSuccNotification object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
