//
//  UIImage+Original.h
//  zhukeyunfuManger
//
//  Created by zkyfios02 on 2018/1/22.
//  Copyright © 2018年 zkyfios02. All rights reserved.
//使图片保持原始的，不渲染


#import <UIKit/UIKit.h>

@interface UIImage (Original)
/**
 使图片保持原始的，不渲染
 */
+(UIImage *)imageOriginalWithName:(NSString *)name;

//根据UIColor一个颜色生成一张图片
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

@end
