//
//  ListOrderModel.m
//  JS_Shipper
//
//  Created by zhanbing han on 2019/6/3.
//  Copyright © 2019 zhanbing han. All rights reserved.
//

#import "ListOrderModel.h"

@implementation ListOrderModel

- (NSString *)driverAvatar {
    _driverAvatar = [NSString stringWithFormat:@"%@%@",PIC_URL(),_driverAvatar];
    return _driverAvatar;
}

- (NSString *)commentImage1 {
    _commentImage1 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_commentImage1];
    return _commentImage1;
}

- (NSString *)commentImage2 {
    _commentImage2 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_commentImage2];
    return _commentImage2;
}

- (NSString *)commentImage3 {
    _commentImage3 = [NSString stringWithFormat:@"%@%@",PIC_URL(),_commentImage3];
    return _commentImage3;
}

@end
