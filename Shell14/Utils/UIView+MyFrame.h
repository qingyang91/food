//
//  UIView+MyFrame.h
//  UILeassonFour
//
//  Created by Lei on 16/5/26.
//  Copyright © 2016年 NanLei. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark  ------------ 屏幕 ------------
//  屏幕尺寸(宽 + 高)
#define kScreenBounds	[UIScreen mainScreen].bounds
//  屏幕宽
#define kScreenWidth	[UIScreen mainScreen].bounds.size.width
//  屏幕高
#define kScreenHeight	[UIScreen mainScreen].bounds.size.height
// 屏幕中心点
#define kScreenCenter   CGPointMake(kScreenWidth / 2, kScreenHeight / 2)
// 随机颜色
#define randomColor [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]

@interface UIView (MyFrame)

// 视图原点X轴坐标
@property (nonatomic) CGFloat X;

// 视图原点Y轴坐标
@property (nonatomic) CGFloat Y;

// 视图宽
@property (nonatomic) CGFloat width;

// 视图高
@property (nonatomic) CGFloat height;

// 终点X
@property (nonatomic) CGFloat endX;

// 终点Y
@property (nonatomic) CGFloat endY;

//  自身中心点x坐标
@property (nonatomic, assign) CGFloat centerX;
//  自身中心点y坐标
@property (nonatomic, assign) CGFloat centerY;

//  是否圆形
@property (nonatomic, assign) BOOL isCircle;

#pragma mark  ------------ 父视图 ------------

//  父视图宽度
@property (nonatomic, assign, readonly) CGFloat supWidth;
//  父视图高度
@property (nonatomic, assign, readonly) CGFloat supHeight;

//  父视图x坐标
@property (nonatomic, assign, readonly) CGFloat supX;
//  父视图y坐标
@property (nonatomic, assign, readonly) CGFloat supY;

//  父视图结束x坐标
@property (nonatomic, assign, readonly) CGFloat supEndX;
//  父视图结束y坐标
@property (nonatomic, assign, readonly) CGFloat supEndY;

//  父视图中心点
@property (nonatomic, assign, readonly) CGPoint supCenter;

- (void)addShadow;



@end













