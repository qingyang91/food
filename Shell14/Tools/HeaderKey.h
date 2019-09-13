//
//  HeaderKey.h
//  ShellTwo
//
//  Created by Qingyang Xu on 2018/9/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#ifndef HeaderKey_h
#define HeaderKey_h

#import <UIKit/UIKit.h>

#ifdef DEBUG

#define NSLog(format,...) printf("\n[%s] %s [第%d行] %s\n",__TIME__,__FUNCTION__,__LINE__,[[NSString stringWithFormat:format,## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#define Base_URL                          @"https://www.jienihua100.com/api"

//获取验证码
#define GetCode                           @"/user/getcode"

//登录接口
#define LoginUrl                          @"/user/register"

#define AttentionDataBaseManager       [AttentionDataBase shareManager]
#define CollectionDataBaseManager      [CollectionDataBase shareManager]
#define LikeDataBaseManager            [LikeDataBase shareManager]
#define TopicDataBaseManager           [TopicDataBase shareManager]
#define CreationDataBaseManager        [CreationDataBase shareManager]

// IPhone屏幕类型定义
// iPhone4,4s
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480.0)
// iPhone5,5c,5s,SE
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568.0)
// iPhone6,6s,7
#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667.0)
// iPhone6 p,6s p,7 p
#define iPhone6p ([UIScreen mainScreen].bounds.size.height == 736.0)

#define kIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)  : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//系统版本
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**
 *  屏幕高度
 */
#define kScreenH ([UIScreen mainScreen].bounds.size.height)
/**
 *  屏幕宽度
 */
#define kScreenW ([UIScreen mainScreen].bounds.size.width)
/**
 *  弧度转角度
 */
#define kRADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

/**
 *  角度转弧度
 */
#define kDEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
/**
 *  沙盒Cache路径
 */
#define kCachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])

/**
 *  沙盒Document路径
 */
#define kDocumentPath ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])

//注册Cell
#define RegisterNibCell(nibName) [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName]

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)


// 状态栏和导航栏总高度
#define kNavBarHAbove7      ((kIs_iPhoneX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)

#define KHeight_TabBar ((kIs_iPhoneX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)

#define KHeight_StatusBar ((kIs_iPhoneX==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)


#ifdef DEBUG // 调试状态, 打开LOG功能
#define GCLLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define GCLLog(...)
#endif
// 弱引用
#define GCLWeakSelf __weak typeof(self) weakSelf = self


#define Weak(obj) autoreleasepool{} __weak typeof(obj) w##obj = obj;
#define Strong(obj) autoreleasepool{} __strong typeof(obj) obj = w##obj;//配套上面的方法使用
#define FontSystem(f)                               [UIFont systemFontOfSize:f]
#define Font_Text_Label                             FontSystem(16.0f)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color_SubTitle                              UIColorFromRGB(0x666666)
//UIFont
#define AutoWidth(w)  (w * kScreenW)/375
#define AutoHeight(h)  (h * kScreenH)/667
#define AutoWidth360(w)  (w * kScreenW)/360

//适配字

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
//注册Cell
#define RegisterNibCell(nibName) [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName]
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

#define AutoFont(h)  FontSize(h)
//#if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.2")
//#define kMainFont(f,w) [UIFont systemFontOfSize:AutoFont(f) weight:(w)]
//#define kSystemMainFont(f,w) [UIFont systemFontOfSize:AutoFont(f) weight:(w)]
//#endif
//#define kMainFont(f,w) [UIFont systemFontOfSize:AutoFont(f)]
//#define kSystemMainFont(f,w) [UIFont systemFontOfSize:AutoFont(f)]


#define kMainFont(f,w) SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.2") ? [UIFont systemFontOfSize:AutoFont(f) weight:(w)] : [UIFont systemFontOfSize:AutoFont(f)]
#define kSystemMainFont(f,w) SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.2") ? [UIFont systemFontOfSize:AutoFont(f) weight:(w)] : [UIFont systemFontOfSize:AutoFont(f)]

//APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//约束适配
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
#define kCommonBackgroundColor [UIColor colorWithHexString:@"#F5F5F5"]

#define UserDefaults                                [NSUserDefaults standardUserDefaults]

#define kImportQMUI <QMUIKit/QMUIKit.h>

static inline CGFloat FontSize(CGFloat fontSize){
    if (kScreenW < 375) {
        return fontSize * 0.944;
    }else if (kScreenW==375){
        return fontSize;
    }else{
        return fontSize* 1.056;
    }
}

#endif /* HeaderKey_h */
