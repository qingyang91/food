//
//  UIView+MyFrame.m
//  UILeassonFour
//
//  Created by Lei on 16/5/26.
//  Copyright © 2016年 NanLei. All rights reserved.
//

#import "UIView+MyFrame.h"

@implementation UIView (MyFrame)

- (void)setX:(CGFloat)X
{
//    self.frame = CGRectMake(X, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    CGRect newRect = self.frame;
    newRect.origin.x = X;
    self.frame = newRect;
}

- (CGFloat)X
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)Y
{
    CGRect newRect = self.frame;
    newRect.origin.y = Y;
    self.frame = newRect;
}

- (CGFloat)Y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect newRect = self.frame;
    newRect.size.width = width;
    self.frame = newRect;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect newRect = self.frame;
    newRect.size.height = height;
    self.frame = newRect;

}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setEndX:(CGFloat)newEndX
{
    CGRect newFrame = self.frame;
    
    newFrame.origin.x = newEndX - self.frame.size.width;
    self.frame = newFrame;
}


- (CGFloat)endX
{
    return (self.frame.origin.x + self.frame.size.width);
}

- (void)setEndY:(CGFloat)newEndY
{
    CGRect newFrame = self.frame;
    
    newFrame.origin.y = newEndY - self.frame.size.height;
    self.frame = newFrame;
}


- (CGFloat)endY
{
    return (self.frame.origin.y + self.frame.size.height);
}

#pragma mark  ------------ 中心点x坐标 ------------

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)newCenterX
{
    CGPoint newCenter = self.center;
    
    newCenter.x = newCenterX;
    self.center = newCenter;
}


#pragma mark  ------------ 中心点y坐标 ------------

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)newCenterY
{
    CGPoint newCenter = self.center;
    
    newCenter.y = newCenterY;
    self.center = newCenter;
}


#pragma mark  ------------ 是否圆形 ------------

@dynamic isCircle;
static const void *isCircleKey = &isCircleKey;



#pragma mark  ------------ 父视图 ------------


#pragma mark  ------------ 父视图宽度 ------------

- (CGFloat)supWidth
{
    return self.superview.width;
}


#pragma mark  ------------ 父视图高度 ------------

- (CGFloat)supHeight
{
    return self.superview.height;
}


#pragma mark  ------------ 父视图x坐标 ------------

- (CGFloat)supX
{
    return self.superview.X;
}


#pragma mark  ------------ 父视图y坐标 ------------

- (CGFloat)supY
{
    return self.superview.Y;
}


#pragma mark  ------------ 父视图结束x坐标 ------------

- (CGFloat)supEndX
{
    return self.superview.X + self.superview.width;
}


#pragma mark  ------------ 父视图结束y坐标 ------------

- (CGFloat)supEndY
{
    return self.superview.Y + self.superview.height;
}


#pragma mark  ------------ 父视图中心点 ------------

- (CGPoint)supCenter
{
    return self.superview.center;
}


- (void)addShadow
{
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.cornerRadius = 5;
    
}



@end













