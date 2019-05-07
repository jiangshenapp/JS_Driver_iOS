//
//  JSAuthenticationVC.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "JSAuthenticationVC.h"
#import "HmSelectAdView.h"

@interface JSAuthenticationVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isPerson;//判断是个人还是公司
}

@property (nonatomic, assign) NSInteger photoType; //1、身份证正面 2、身份证反面 3、手持身份证 4、公司营业执照
@property (nonatomic, copy) NSString *idCardFrontPhoto;
@property (nonatomic, copy) NSString *idCardBehindPhoto;
@property (nonatomic, copy) NSString *idCardHandPhoto;
@property (nonatomic, copy) NSString *companyPhoto;

@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentArea;

@end

@implementation JSAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"货主身份认证";
    isPerson = YES;
    self.photoType = 0;
    self.idCardFrontPhoto = @"";
    self.idCardBehindPhoto = @"";
    self.idCardHandPhoto = @"";

    [self.baseTabView addSubview:_personTabHeadView];
    [self.baseTabView addSubview:_companyTabHeadView];
    _personTabHeadView.width = self.baseTabView.width;
    _companyTabHeadView.width = self.baseTabView.width;
    self.baseTabView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, _personTabHeadView.height)];
    self.baseTabView.tableHeaderView.userInteractionEnabled = NO;
}

#pragma mark - methods

/* 切换个人/公司 */
- (IBAction)titleViewAction:(UIButton *)sender {
    isPerson = sender.tag==100?YES:NO;
    for (NSInteger tag = 100; tag<102; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        if ([btn isEqual:sender]) {
            btn.backgroundColor = AppThemeColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    _personTabHeadView.hidden = !isPerson;
    _companyTabHeadView.hidden = isPerson;
    if (isPerson) {
        self.baseTabView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, _personTabHeadView.height)];
    }
    else {
        self.baseTabView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, _companyTabHeadView.height)];
    }
    [self.baseTabView setContentOffset:CGPointMake(0, 0)];
    self.baseTabView.tableHeaderView.userInteractionEnabled = NO;
}

/* 上传身份证正面 */
- (IBAction)uploadIdCardFrontAction:(id)sender {
    self.photoType = 1;
    [self selectPhoto];
}

/* 上传身份证反面 */
- (IBAction)uploadIdCardBehindAction:(id)sender {
    self.photoType = 2;
    [self selectPhoto];
}

/* 上传手持身份证 */
- (IBAction)uploadIdCardHandAction:(id)sender {
    self.photoType = 3;
    [self selectPhoto];
}

/* 选择照片 */
- (void)selectPhoto {
    [self.view endEditing:YES]; //隐藏键盘
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照",  nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:NO completion:^{}];
        }
            break;
        case 1:
        {
            if ([Utils isCameraPermissionOn]) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
                imagePickerController.delegate = self;
                
                if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                [self presentViewController:imagePickerController animated:NO completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *iconImage = info[UIImagePickerControllerEditedImage];
    if (self.photoType == 1) {
        [self.idCardFrontBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 2) {
        [self.idCardBehindBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 3) {
        [self.idCardHandBtn setImage:iconImage forState:UIControlStateNormal];
    }
    if (self.photoType == 4) {
        [self.companyPhotoBtn setImage:iconImage forState:UIControlStateNormal];
    }
    
    [picker dismissViewControllerAnimated:NO completion:^{
        NSData *imageData = UIImageJPEGRepresentation(iconImage, 0.01);
        NSMutableArray *imageDataArr = [NSMutableArray arrayWithObjects:imageData, nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"pigx",@"resourceId", nil];
        [[NetworkManager sharedManager] postJSON:URL_FileUpload parameters:dic imageDataArr:imageDataArr imageName:@"file" completion:^(id responseData, RequestState status, NSError *error) {

            if (status == Request_Success) {

                NSString *photo = responseData;
                if (self.photoType == 1) {
                    self.idCardFrontPhoto = photo;
                }
                if (self.photoType == 2) {
                    self.idCardBehindPhoto = photo;
                }
                if (self.photoType == 3) {
                    self.idCardHandPhoto = photo;
                }
                if (self.photoType == 4) {
                    self.companyPhoto = photo;
                }
            }
        }];
    }];
}

/* 选择区域 */
- (IBAction)selectAddressAction:(id)sender {
    // 这里传进去的self.currentProvince 等等的都是本页面的存储值
    HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
    selectV.confirmSelect = ^(NSArray *address) {
        self.currentProvince = address[0];
        self.currentCity = address[1];
        self.currentArea = address[2];
        self.addressTF.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
    };
    [selectV show];
}

/* 公司选择所在地 */
- (IBAction)selectCompanyAddressAction:(id)sender {
    // 这里传进去的self.currentProvince 等等的都是本页面的存储值
    HmSelectAdView *selectV = [[HmSelectAdView alloc] initWithLastContent:self.currentProvince ? @[self.currentProvince, self.currentCity, self.currentArea] : nil];
    selectV.confirmSelect = ^(NSArray *address) {
        self.currentProvince = address[0];
        self.currentCity = address[1];
        self.currentArea = address[2];
        self.companyAddressLab.text = [NSString stringWithFormat:@"%@%@%@", self.currentProvince, self.currentCity, self.currentArea];
    };
    [selectV show];
}

/* 上传公司营业执照 */
- (IBAction)uploadCompanyPhotoAction:(id)sender {
    self.photoType = 4;
    [self selectPhoto];
}

/* 勾选协议 */
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.isSelected;
}

/* 用户协议 */
- (IBAction)protocalAction:(id)sender {
    [Utils showToast:@"用户协议"];
}

/* 提交审核 */
- (IBAction)commitAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (isPerson == YES) { //个人
        if ([NSString isEmpty:self.idCardFrontPhoto]) {
            [Utils showToast:@"请上传货主本人真实身份证正面"];
            return;
        }
        if ([NSString isEmpty:self.idCardBehindPhoto]) {
            [Utils showToast:@"请上传货主本人真实身份证反面"];
            return;
        }
        if ([NSString isEmpty:self.idCardHandPhoto]) {
            [Utils showToast:@"请上传货主本人手持身份证照片"];
            return;
        }
        if ([NSString isEmpty:self.nameTF.text]) {
            [Utils showToast:@"请输入姓名"];
            return;
        }
        if ([NSString isEmpty:self.idCardTF.text]) {
            [Utils showToast:@"请输入身份证号"];
            return;
        }
        if ([NSString isEmpty:self.addressTF.text]) {
            [Utils showToast:@"请选择所在区域"];
            return;
        }
        if (self.selectBtn.isSelected == NO) {
            [Utils showToast:@"请勾选用户协议"];
            return;
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _idCardFrontPhoto, @"idImage",
                             _idCardBehindPhoto, @"idBackImage",
                             _idCardHandPhoto, @"idHandImage",
                             self.nameTF.text, @"personName",
                             self.idCardTF.text, @"idCode",
                             self.addressTF.text, @"address",
                             nil];
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[dic jsonStringEncoded], @"personVerifiedInfo", nil];
        [[NetworkManager sharedManager] postJSON:URL_PersonConsignorVerified parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"提交成功，前耐心等待审核"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
                self.tabBarController.selectedIndex = 4;
                // 跳转到首页
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    } else {
        if ([NSString isEmpty:self.companyNameTF.text]) {
            [Utils showToast:@"请输入公司名称"];
            return;
        }
        if ([NSString isEmpty:self.companyNoTF.text]) {
            [Utils showToast:@"请输入企业信用代码/注册号"];
            return;
        }
        if ([NSString isEmpty:self.companyAddressLab.text]) {
            [Utils showToast:@"请选择所在地"];
            return;
        }
        if ([NSString isEmpty:self.companyDetailAddressTF.text]) {
            [Utils showToast:@"请输入详细地址"];
            return;
        }
        if ([NSString isEmpty:self.companyPhoto]) {
            [Utils showToast:@"请上传公司营业执照"];
            return;
        }
        if (self.selectBtn.isSelected == NO) {
            [Utils showToast:@"请勾选用户协议"];
            return;
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.companyNameTF.text, @"companyName",
                             self.companyNoTF.text, @"registrationNumber",
                             self.companyAddressLab.text, @"address",
                             self.companyDetailAddressTF.text, @"detailAddress",
                             _companyPhoto, @"businessLicenceImage",
                             nil];
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[dic jsonStringEncoded], @"consignorCompanyVerifiedInfo", nil];
        [[NetworkManager sharedManager] postJSON:URL_CompanyConsignorVerified parameters:paramDic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"提交成功，前耐心等待审核"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
                self.tabBarController.selectedIndex = 4;
                // 跳转到首页
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
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
