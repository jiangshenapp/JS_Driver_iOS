//
//  JSMyDriverVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyDriverVC : BaseVC
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIView *bgShdowView;
@property (weak, nonatomic) IBOutlet UIView *addContentView;
/** 添加司机的手机号 */
@property (weak, nonatomic) IBOutlet UITextField *addPhoneTF;
/** 添加姓名 */
@property (weak, nonatomic) IBOutlet UITextField *addNameTF;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
- (IBAction)cancleSearchAction:(UIButton *)sender;

/** 驾驶证类型 */
@property (weak, nonatomic) IBOutlet UITextField *addDriverTF;
- (IBAction)cancleAddAction:(id)sender;
- (IBAction)addDriverAction:(id)sender;


@end

@interface MyDriverTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *driverTypeLab;

@end

NS_ASSUME_NONNULL_END
