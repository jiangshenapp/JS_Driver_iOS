//
//  JSMyRouteDetailVC.h
//  JS_Driver
//
//  Created by zhanbing han on 2019/6/9.
//  Copyright © 2019 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSMyRouteDetailVC : BaseVC
/** 路线id */
@property (nonatomic,copy) NSString *routeID;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UIButton *carLengthBtn;
@property (weak, nonatomic) IBOutlet UIButton *carModelBtn;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
- (IBAction)applyJingpinAction:(UIButton *)sender;
- (IBAction)startRouteAction:(UIButton *)sender;
- (IBAction)stopRouteAction:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
