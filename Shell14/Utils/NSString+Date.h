//
//  NSString+Date.h
//  zhukeyunfuManger
//
//  Created by chenjiajun on 2018/5/23.
//  Copyright © 2018年 zkyfios02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

//获取当前的时间
+(NSString*)getCurrentTimesWithFormatter:(NSString *)format;

//获取当前时间戳有两种方法(以秒为单位)
+(NSString *)getNowTimeTimestampWithFormatter:(NSString *)format;
+(NSString *)getNowTimeTimestamp2WithFormatter:(NSString *)format;

//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3WithFormatter:(NSString *)format;

//通过日期获取星期
+ (NSString*)getWeekdayStringFromDate:(NSDate*)inputDate;
+ (NSInteger)getWeekdayIndexStringFromDate:(NSDate*)inputDate;
+ (NSString*)getWeekdayStringFromDateString:(NSString*)inputDateString;
+ (NSInteger)getWeekdayIndexFromDateString:(NSString*)inputDateString;

+(NSString *)backMsgTime:(NSString *)timeString;

+(NSString *)backMessageTime:(NSString *)timeString;


@end
