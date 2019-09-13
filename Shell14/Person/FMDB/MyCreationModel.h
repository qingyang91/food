//
//  MyCreationModel.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/30.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCreationModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *material;
@property (nonatomic, copy) NSString *step;
@property (nonatomic, copy) NSString *skill;
@property (nonatomic, copy) NSString *stepNumber;
@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, assign) NSInteger ID;

@end

NS_ASSUME_NONNULL_END
