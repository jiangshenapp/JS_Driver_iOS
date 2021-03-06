//
//  Config.h
//  Chaozhi
//  Notes：接口地址【文档：http://47.96.122.74:9999/swagger-ui.html】
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma mark - ---------------接口地址---------------

// 接口地址
NSString *ROOT_URL(void);
// 图片地址
NSString *PIC_URL(void);

#pragma mark - ---------------接口名称---------------

#pragma mark - 上传文件

#define URL_FileUpload @"http://gateway.jiangshen56.com/admin/file/upload" //上传文件

#pragma mark - APP账户接口

#define URL_GetPayRoute @"http://gateway.jiangshen56.com/pigx-pay-biz/pay/getRoute"//获取支付方式
#define URL_Recharge @"/app/account/recharge"//账户充值
#define URL_BalanceWithdraw @"/app/account/balanceWithdraw"//提现申请
#define URL_GetBySubscriber @"/app/account/getBySubscriber"//账户详情
#define URL_GetTradeRecord @"/app/account/getTradeRecord"//账单明细
#define URL_RechargeDriverDeposit @"/app/account/rechargeDriverDeposit"//运力端缴纳保证金

#pragma mark - 根据类型获取字典

#define URL_GetDictByType @"/app/dict/getDictByType"//根据类型获取字典
#define URL_GetDictList @"/app/dict/getDictList" //获取字典列表

#pragma mark - APP会员注册登录接口

#define URL_Login @"/app/subscriber/login2" //密码登录
#define URL_SmsLogin @"/app/subscriber/smsLogin2" //短信验证码登录
#define URL_Logout @"/app/subscriber/logout" //退出登录
#define URL_Profile @"/app/subscriber/profile" //获取当前登录人信息
#define URL_Registry @"/app/subscriber/registry" //会员注册
#define URL_ResetPwdStep1 @"/app/subscriber/resetPwdStep1" //重置密码步骤1
#define URL_ResetPwdStep2 @"/app/subscriber/resetPwdStep2" //重置密码步骤2
#define URL_SendSmsCode @"/app/subscriber/sendSmsCode" //发送短信验证码
#define URL_SetPwd @"/app/subscriber/setPwd" //设置密码
#define URL_BindMobile @"/app/subscriber/bindMobile" //绑定手机号
#define URL_ChangeAvatar @"/app/subscriber/changeAvatar" //修改头像
#define URL_ChangeNickname @"/app/subscriber/changeNickname" //修改昵称

#pragma mark - APP会员认证接口

#define URL_CompanyConsignorVerified @"/app/subscriber/verify/companyConsignorVerified" //企业货主认证
#define URL_DriverVerified @"/app/subscriber/verify/driverVerified" //个人司机认证
#define URL_GetCompanyConsignorVerifiedInfo @"/app/subscriber/verify/getCompanyConsignorVerifiedInfo" //获取企业货主认证信息
#define URL_GetDriverVerifiedInfo @"/app/subscriber/verify/getDriverVerifiedInfo" //获取司机认证信息
#define URL_GetParkVerifiedInfo @"/app/subscriber/verify/getParkVerifiedInfo" //获取园区认证信息
#define URL_GetPersonConsignorVerifiedInfo @"/app/subscriber/verify/getPersonConsignorVerifiedInfo" //获取个人货主认证信息
#define URL_ParkVerified @"/app/subscriber/verify/parkVerified" //园区认证
#define URL_PersonConsignorVerified @"/app/subscriber/verify/personConsignorVerified" //个人货主认证

#pragma mark - 我的车辆
#define URL_AddCar @"/app/car/add" //添加车辆"
#define URL_ReAuditCar @"/app/car/reAudit" //重新审核车辆
#define URL_GetCarDetail @"/app/car/get" //车辆详情
#define URL_CarList @"/app/car/list" //我的车辆列表
#define URL_UnbindingCar @"/app/car/unbinding" //解绑

#pragma mark - 我的司机
#define URL_Drivers @"/app/park/drivers" //司机列表
#define URL_BindDriver @"/app/park/binding" //绑定司机
#define URL_UnBindDriver @"/app/park/unbinding" //解绑司机
#define URL_FindDriverByMobile @"/app/driver/findByMobile" //查询司机

#pragma mark - 我的路线
#define URL_MyLines @"/app/line/myLines"//我的路线
#define URL_AddMyLines @"/app/line/add"//添加我的路线
#define URL_EditMyLines @"/app/line/edit"//编辑我的路线
#define URL_GetMyLines @"/app/line/get"//路线详情
#define URL_LineClassic @"/app/line/classic"//申请精品线路
#define URL_LineEnable @"/app/line/enable" //启用停用 1启用0停用
#define URL_LineDelete @"/app/line/remove"//删除线路
#define URL_LineEdit @"/app/line/edit"// 编辑线路

#define URL_Find @"/app/driver/order/find"//找货 所有待分配订单"


#pragma mark - 订单
#define URL_OrdeList @"/app/driver/order/list"//我的运单
#define URL_GetOrderInfo @"/app/driver/order/get"//订单详情
#define URL_RefuseOrder @"/app/driver/order/refuse"//拒绝接单
#define URL_ReceiveOrder @"/app/driver/order/receive"//接单
#define URL_ReceiveOrder @"/app/driver/order/receive"//接单
#define URL_ConfirmOrder @"/app/driver/order/confirm"//确认"
#define URL_CancelReceiveOrder @"/app/driver/order/cancelReceive"//取消接货"
#define URL_CancelDistributionOrder @"/app/driver/order/cancelDistribution"//拒绝配送"
#define URL_DistributionOrder @"/app/driver/order/distribution"//开始配送"
#define URL_CompleteDistributionOrder  @"/app/driver/order/completeDistribution"//完成配送"
#define URL_CommentOrder @"/app/driver/order/comment"//回执评价"

#pragma mark - ---------------H5地址---------------

NSString *h5Url(void);

#pragma mark - ---------------H5名称---------------

#define H5_Privacy @"yszc.html" //隐私协议
#define H5_Register @"yhzcxy.html" //用户注册协议

@end
