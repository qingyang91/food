//
//  MyCollectionModel.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/19.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *detailContent;
@property (nonatomic, copy) NSString *ingredients;
@property (nonatomic, copy) NSString *step;
@property (nonatomic, copy) NSString *stepImaNumber;
@property (nonatomic, copy) NSString *speciality;
@property (nonatomic, copy) NSString *skill;
@property (nonatomic, copy) NSString *scrollImaNumber;
@property (nonatomic, copy) NSString *loveNumber;
@property (nonatomic, assign) NSInteger ID;

@end

NS_ASSUME_NONNULL_END
