//
//  NSString+Date.m
//  zhukeyunfuManger
//
//  Created by chenjiajun on 2018/5/23.
//  Copyright © 2018年 zkyfios02. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

//获取当前的时间
//format : @"YYYY-MM-dd HH:mm:ss"
+(NSString*)getCurrentTimesWithFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
     [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    
    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat:format];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当前时间戳有两种方法(以秒为单位)
+(NSString *)getNowTimeTimestampWithFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}



+(NSString *)getNowTimeTimestamp2WithFormatter:(NSString *)format{
    
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    
    return timeString;
    
}

//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3WithFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}

//通过日期获取星期
+ (NSString*)getWeekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays =
    [NSArray arrayWithObjects:
     [NSNull null], @"Sunday", @"周一", @"周二", @"周三",@"周四", @"周五", @"周六", nil];
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
     
     NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
     
     [calendar setTimeZone: timeZone];
     
     NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
     
     NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
     
     return [weekdays objectAtIndex:theComponents.weekday];
     
}

+ (NSInteger)getWeekdayIndexStringFromDate:(NSDate*)inputDate {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return theComponents.weekday - 1;//下标
    
}

+ (NSString*)getWeekdayStringFromDateString:(NSString*)inputDateString {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *inputDate = [dateFormatter dateFromString:inputDateString];
    NSLog(@"%@--%@", inputDateString, inputDate);
    return [self getWeekdayStringFromDate:inputDate];
}

+ (NSInteger)getWeekdayIndexFromDateString:(NSString*)inputDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *inputDate = [dateFormatter dateFromString:inputDateString];
    NSLog(@"%@--%@", inputDateString, inputDate);
    return [self getWeekdayIndexStringFromDate:inputDate];
}

+(NSString *)backMsgTime:(NSString *)timeString

{
    
    // 格式化时间
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    
    NSString* dateString = [formatter stringFromDate:date];
    
    NSString *dateStr = [[dateString substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *yearStr = [dateStr substringToIndex:4];
    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(4, 2)];
    NSString *dayStr = [dateStr substringFromIndex:6];
    
    NSString *str = [NSString stringWithFormat:@"%@年%@月%@日", yearStr, monthStr, dayStr];
    
    return str;
    
}

+(NSString *)backMessageTime:(NSString *)timeString

{
    
    // 格式化时间
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    
    NSString* dateString = [formatter stringFromDate:date];
    
//    NSString *dateStr = [[dateString substringToIndex:10] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *yearStr = [dateStr substringToIndex:4];
//    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(4, 2)];
//    NSString *dayStr = [dateStr substringFromIndex:6];
//
//    NSString *str = [NSString stringWithFormat:@"%@年%@月%@日", yearStr, monthStr, dayStr];
    
    return dateString;
    
}


@end
