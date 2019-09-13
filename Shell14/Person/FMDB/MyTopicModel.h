//
//  MyTopicModel.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTopicModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSData *imageData;
@property (nonatomic, assign) NSInteger ID;

@end

NS_ASSUME_NONNULL_END
