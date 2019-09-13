//
//  UIImage+Original.m
//  zhukeyunfuManger
//
//  Created by zkyfios02 on 2018/1/22.
//  Copyright © 2018年 zkyfios02. All rights reserved.
//

#import "UIImage+Original.h"

@implementation UIImage (Original)
+(UIImage *)imageOriginalWithName:(NSString *)name
{//使图片保持原始的，不渲染
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
//把一个纯颜色转换成一张图片..
+ (UIImage *)imageWithColor:(UIColor *)color {
    ////根据UIColor一个颜色生成一张图片
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


@end
