//
//  JSAllOrderVC.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/3/28.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSAllOrderVC : BaseVC
- (IBAction)titleBtnAction:(UIButton *)sender;

@end

@interface MyOrderTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetaileLab;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;

@end

NS_ASSUME_NONNULL_END
