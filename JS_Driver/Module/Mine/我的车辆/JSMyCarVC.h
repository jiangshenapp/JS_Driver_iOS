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

NS_ASSUME_NONNULL_END
