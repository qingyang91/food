//
//  Utils.m
//  BeikoCube
//
//  Created by Qingyang Xu on 2018/8/14.
//  Copyright © 2018年 光磊信息. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(BOOL)saveUserInfoToUserDefault:(UserInfoModel*)userInfo{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    NSData *data=  [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [defaults setObject:data forKey:@"Info"];
    if ([defaults synchronize]) {
        return  YES;
    }
    
    return NO;
};
+(UserInfoModel*)unarchiveUserInfo{
    NSData*userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"Info"];
    if (userData) {
        UserInfoModel *info=[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return info;
    }else{
        return nil;
    }
};
//得到用户信息.
+ (UserInfoModel*)GetUserInfo{
    return [self unarchiveUserInfo];
}
//推出系统
+ (BOOL)Logout{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Info"];
    if ([[NSUserDefaults standardUserDefaults]synchronize]) {
        return YES;
    }
    return NO;
}
+ (NSString *)generateRandomStringWithLength:(NSInteger)iLength{
    char data[iLength];
    for (int x = 0; x < iLength; x++) {
        int j = '0' + (arc4random_uniform(75));
        if((j >= 58 && j <= 64) || (j >= 91 && j <= 96)){
            --x;
        }else{
            data[x] = (char)j;
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data length:iLength encoding:NSUTF8StringEncoding];
    return text;
}

//验证手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum{
    if (mobileNum.length != 11){
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[0-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[0-9]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        return YES;
    }
    else{
        return NO;
    }
    
}

// //        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"密码输入格式错误" message:@"请输入6-16位只包括数字和英文字母的密码" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [alertView show];
//请输入6-16位只包括数字和英文字母的密码
+ (BOOL)validatePassWord:(NSString  *)pwd{
    NSString *Regex = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    BOOL result=[Test evaluateWithObject:pwd];
    if (!result) {
        return NO;
    }
    return YES ;
}

//验证邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



+ (BOOL)isBankCardNumber:(NSString *)strCardNo{
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *bankCardNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    if (![bankCardNumberPredicate evaluateWithObject:strCardNo]) {
        return NO;
    }
    
    NSInteger sum = 0;
    NSInteger len = [strCardNo length];
    NSInteger i = 0;
    while (i < len) {
        NSString *tmpString = [strCardNo substringWithRange:NSMakeRange(len - 1 - i, 1)];
        int tmpVal = [tmpString intValue];
        if (i % 2 != 0) {
            tmpVal *= 2;
            if(tmpVal>=10) {
                tmpVal -= 9;
            }
        }
        sum += tmpVal;
        i++;
    }
    
    if((sum % 10) == 0)
        return YES;
    else
        return NO;
}

//+ (NSString*)getUUIDString{
    //    NSString *strUUID = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    //    return strUUID;
//    NSString * currentDeviceUUIDStr = [YBBKeychain passwordForService:@"com.kz.pw"account:@"uuid"];
//    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
//    {
//        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
//        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
//        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
//        [YBBKeychain setPassword: currentDeviceUUIDStr forService:@"com.kz.pw"account:@"uuid"];
//    }
//    return currentDeviceUUIDStr;
//}

+ (UIViewController *)obtainTopViewController{
    return [Utils obtainTopViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)obtainTopViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [Utils obtainTopViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [Utils obtainTopViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [Utils obtainTopViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
