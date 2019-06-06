//
//  JSMyCarVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/5/10.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyCarVC : BaseVC
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
- (IBAction)cancleSearchTF:(UIButton *)sender;

@end

@interface MyCarTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *carNumLab;
@property (weak, nonatomic) IBOutlet UILabel *checkStateLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIImageView *carImgView;
@end

@interface MyCarInfoModel : BaseItem
/** <#object#> */
@property (nonatomic,copy) NSString *image2;
/** object */
@property (nonatomic,copy) NSString *carModelId;
/** <#object#> */
@property (nonatomic,copy) NSString *image1;
/** object */
@property (nonatomic,copy) NSString *ID;
/** <#object#> */
@property (nonatomic,copy) NSString *capacityVolume;
/** object */
@property (nonatomic,copy) NSString *cphm;
/** <#object#> */
@property (nonatomic,copy) NSString *capacityTonnage;
/** object */
@property (nonatomic,copy) NSString *carLengthId;
/** 车辆状态，0待审核，1通过，2拒绝，3审核中 */
@property (nonatomic,copy) NSString *state;
/** object */
@property (nonatomic,copy) NSString *subscriberId;
/** <#object#> */
@property (nonatomic,copy) NSString *carModelName;
/** <#object#> */
@property (nonatomic,copy) NSString *carLengthName;
@end

NS_ASSUME_NONNULL_END
