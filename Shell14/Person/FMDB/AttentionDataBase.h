//
//  AttentionDataBase.h
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/19.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "MyAttentionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttentionDataBase : NSObject

+ (instancetype)shareManager;

- (void)openDB;

- (void)creatTableWithTableName:(NSString *)tableName;


- (void)insertDataWithTableName:(NSString *)tableName model:(MyAttentionModel *)model;


// 删除数据
- (void)deleteDataWithTableName:(NSString *)tableName ID:(NSInteger)ID;
//
// 删除所有数据
- (void)deleteAllDataWithTableName:(NSString *)tableName;
//

- (MyAttentionModel *)selectOneDataWithTableName:(NSString *)tableName ID:(NSInteger)ID;
// 查询全部数据
- (NSMutableArray *)selectAllDataWithTableName:(NSString *)tableName;

- (void)updataWithTableName:(NSString *)tableName model:(MyAttentionModel *)model forID:(NSInteger)ID;

@end

NS_ASSUME_NONNULL_END
