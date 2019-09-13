//
//  Utils.h
//  BeikoCube
//
//  Created by Qingyang Xu on 2018/8/14.
//  Copyright © 2018年 光磊信息. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
@interface Utils : NSObject


/**
 *  生成固定长度的随机字符串
 *
 *  @param iLength 长度
 *
 *  @return 随机字符串
 */
+ (NSString *)generateRandomStringWithLength:(NSInteger)iLength;

/**
 *  判断字符串是否是电话号码
 *
 *  @param mobileNum 字符串
 *
 *  @return 是否是电话号码
 */
+ (BOOL)validateMobile:(NSString *)mobileNum;
/**
 *  判断字符串是否是邮箱
 *
 *  @param email 字符串
 *
 *  @return 是否是邮箱
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  判断是否是合法的银行卡号
 *
 *  @return 是否是银行卡号
 */
+ (BOOL)isBankCardNumber:(NSString *)strCardNo;

/**
 *  判断密码6-16位数字字母
 *
 *  @param pwd 字符串
 *
 *  @return 是否是数字字母密码
 */
+ (BOOL)validatePassWord:(NSString  *)pwd;
/**
 *  生成设备的UUID，iOS6之后可用
 *
 *  @return uuid字符串
 */
//+ (NSString *)getUUIDString;//NS_AVAILABLE_IOS(6_0)


//保存信息
+(BOOL)saveUserInfoToUserDefault:(UserInfoModel*)userInfo;
// 取出信息
+ (UserInfoModel*)GetUserInfo;
+ (BOOL)Logout;

@end
