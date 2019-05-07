//
//  Config.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "Config.h"

@implementation Config

NSString *h5Url(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"https://m.chaozhiedu.com/"; //正式地址
    } else {
        return @"http://mtest.chaozhiedu.com/"; //测试地址
    }
}

NSString *ROOT_URL(void) {
    
    if (KOnline || [Utils getServer] == 1) {
        return @"http://gateway.jskj.com/logistic-biz"; //正式地址
    } else {
        //        return @"http://192.168.199.4:9999/logistic-biz"; //本机地址
        //        return @"http://gateway.jskj.com/logistic-biz"; //阿里云地址
        return @"http://47.96.122.74:9999/logistic-biz"; //阿里云地址
    }
}

NSString *PIC_URL(void) {
    
    if (KOnline || [Utils getServer] == 1) {
        return @"http://gateway.jskj.com/logistic-biz"; //正式地址
    } else {
        return @"http://47.96.122.74:9999/admin/file/download?fileName="; //阿里云地址
    }
}

@end
