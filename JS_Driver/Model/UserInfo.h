//
//  UserInfo.h
//  Chaozhi
//  Notes：用户model
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"

@interface UserInfo : BaseItem

@property (nonatomic,copy) NSString *token; //用户token
@property (nonatomic,copy) NSString *mobile; //手机号码
@property (nonatomic,copy) NSString *nickName; //昵称
@property (nonatomic,copy) NSString *lastPosition; //
@property (nonatomic,copy) NSString *lastPositionTime; //
@property (nonatomic,copy) NSString *driverVerified; //
@property (nonatomic,copy) NSString *parkVerified; //
@property (nonatomic,copy) NSString *personConsignorVerified; //个人货主认证状态
@property (nonatomic,copy) NSString *companyConsignorVerified; //公司货主认证状态

+ (UserInfo *)share;

- (void)setUserInfo:(NSMutableDictionary *)userDic;

- (void)removeUserInfo;

@end
