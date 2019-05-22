//
//  FilterCustomView.h
//  JS_Shipper
//
//  Created by zhanbing han on 2019/4/24.
//  Copyright © 2019年 zhanbing han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCustomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterCustomView : BaseCustomView

@end

@interface MyCollectionCell : UICollectionViewCell
/** 按钮 */
@property (nonatomic,retain) UIButton *button;
@end


NS_ASSUME_NONNULL_END
