//
//  TopicModel.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopicModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *speciality;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *detailContent;
@property (nonatomic, copy) NSString *likeNumber;

@end

NS_ASSUME_NONNULL_END
