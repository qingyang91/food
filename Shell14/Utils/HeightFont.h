//
//  HeightFont.h
//  BeikoCube
//
//  Created by Qingyang Xu on 2018/8/15.
//  Copyright © 2018年 光磊信息. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeightFont : NSObject

//计算文本的宽度
+ (float)getStringWidth:(NSString *)text andFont:(float)font;
//计算文本的高度
+ (float)getStringHeight:(NSString *)text andFont:(float)font andWidth:(float)width;


@end
