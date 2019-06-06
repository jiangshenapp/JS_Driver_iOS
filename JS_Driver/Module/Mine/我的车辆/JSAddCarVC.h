//
//  JSAddCarVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSAddCarVC : BaseVC
/** 车辆详情 */
@property (nonatomic,copy) NSString *carDetaileID;
@property (weak, nonatomic) IBOutlet UITextField *carNumLab;
@property (weak, nonatomic) IBOutlet UITextField *carWeightTF;
@property (weak, nonatomic) IBOutlet UITextField *carSpaceTF;
- (IBAction)carDrivingLicenseAction:(UIButton *)sender;
- (IBAction)carHeadImgAction:(UIButton *)sender;
- (IBAction)submitDataAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authCarH;
@property (weak, nonatomic) IBOutlet UILabel *authStateLab;
- (IBAction)selectCarTypeAction:(id)sender;
- (IBAction)selectCarLengthAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *carLengthLab;
@property (weak, nonatomic) IBOutlet UIButton *carModelBtn;
@property (weak, nonatomic) IBOutlet UIButton *carLengthModelBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn1;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn2;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *carDriverBtn;
@property (weak, nonatomic) IBOutlet UIButton *carHeadIMgBtn;

@end

NS_ASSUME_NONNULL_END
