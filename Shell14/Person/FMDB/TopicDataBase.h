//
//  TopicDataBase.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "MyTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopicDataBase : NSObject

+ (instancetype)shareManager;

- (void)openDB;

- (void)creatTableWithTableName:(NSString *)tableName;


- (void)insertDataWithTableName:(NSString *)tableName model:(MyTopicModel *)model;


// 删除数据
- (void)deleteDataWithTableName:(NSString *)tableName ID:(NSInteger)ID;
//
// 删除所有数据
- (void)deleteAllDataWithTableName:(NSString *)tableName;

- (MyTopicModel *)selectOneDataWithTableName:(NSString *)tableName ID:(NSInteger)ID;
// 查询全部数据
- (NSMutableArray *)selectAllDataWithTableName:(NSString *)tableName;


@end

NS_ASSUME_NONNULL_END
