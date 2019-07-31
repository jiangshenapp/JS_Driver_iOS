/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>

#import "UIImageView+WebCache.h"

#import "EaseConversationListViewController.h"
#import "EaseMessageViewController.h"
#import "EaseUsersListViewController.h"
#import "EaseViewController.h"

#import "IModelCell.h"
#import "IModelChatCell.h"
#import "EaseMessageCell.h"
#import "EaseBaseMessageCell.h"
#import "EaseBubbleView.h"
#import "EaseUserCell.h"

#import "EaseChineseToPinyin.h"
#import "EaseEmoji.h"
#import "EaseEmotionEscape.h"
#import "EaseEmotionManager.h"
#import "EaseSDKHelper.h"
#import "EMCDDeviceManager.h"
#import "EaseConvertToCommonEmoticonsHelper.h"

#import "NSDate+Category.h"
#import "NSString+Valid.h"
#import "UIViewController+HUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "EaseLocalDefine.h"

//环信颜色
#define kColor_LightGray [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1.0]

#define kColor_Gray [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0]

#define kColor_Blue [UIColor colorWithRed:45 / 255.0 green:116 / 255.0 blue:215 / 255.0 alpha:1.0]

@interface EaseUI : NSObject

@end
