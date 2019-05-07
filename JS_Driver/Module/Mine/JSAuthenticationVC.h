//
//  JSAuthenticationVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/26.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSAuthenticationVC : BaseVC

- (IBAction)titleViewAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *personTabHeadView;
@property (weak, nonatomic) IBOutlet UIView *companyTabHeadView;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;

/* 个人 */
@property (weak, nonatomic) IBOutlet UIButton *idCardFrontBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardBehindBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardHandBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idCardTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;

/* 公司 */
@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;
@property (weak, nonatomic) IBOutlet UITextField *companyNoTF;
@property (weak, nonatomic) IBOutlet UILabel *companyAddressLab;
@property (weak, nonatomic) IBOutlet UITextField *companyDetailAddressTF;
@property (weak, nonatomic) IBOutlet UIButton *companyPhotoBtn;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
