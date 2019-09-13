//
//  LikeDataBase.m
//  Shell14
//
//  Created by Qingyang Xu on 2018/10/25.
//  Copyright © 2018年 puxu. All rights reserved.
//

#import "LikeDataBase.h"

@implementation LikeDataBase

static LikeDataBase *_manager = nil;
static FMDatabase *db = nil;

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _manager = [[LikeDataBase alloc]init];
    });
    return _manager;
}
// 设置数据库的路径
- (NSString *)creatSqliteWithName:(NSString *)name{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
}
// 创建数据库
- (void)openDB{
    // 1、判断数据库是否存在,如果存在 直接返回
    if (db != nil) {
        return;
    }
    // 2、创建路径
    NSString *filePath = [self creatSqliteWithName:@"LikeDataBase"];
    db = [FMDatabase databaseWithPath:filePath];
    NSLog(@"%@", filePath);
    
    if ([db open]) {
        NSLog(@"创建数据库成功");
    } else {
        NSLog(@"创建数据库失败");
    }
}
// 创建表
- (void)creatTableWithTableName:(NSString *)tableName{
    // 1、打开数据库
    [db open];
    // 2、创建sql语句
    NSString *string = [NSString stringWithFormat:@"create table if not exists %@ (ID integer primary key autoincrement, content text)", tableName];
    // 3、执行
    // flag为1时代表正确 为0时代表错误
    BOOL flag = [db executeUpdate:string];
    NSLog(@"建表--%d", flag);
    // 4、关闭数据库
    [db close];
}
// 添加数据
- (void)insertDataWithTableName:(NSString *)tableName model:(MyLikeModel *)model
{
    // 1、打开数据库
    [db open];
    // 2、创建数据库语句
    NSString *string = [NSString stringWithFormat:@"insert into %@ (content) values (?)", tableName];
    // 存储 这一步和我们之前的绑定非常的相似
    // 执行指令
    // 参数第一个要写sql语句 后面再写要插入的字段信息
    
    
    BOOL flag = [db executeUpdate:string, model.content];
    NSLog(@"%d", flag);
    // 关闭数据库
    [db close];
}
// 删除数据
- (void)deleteDataWithTableName:(NSString *)tableName ID:(NSInteger)ID
{
    // 1、打开数据库
    [db open];
    // 2、创建sql语句
    NSString *string = [NSString stringWithFormat:@"delete from %@ where ID = ?", tableName];
    // 3、执行指令
    BOOL flag = [db executeUpdate:string values:@[@(ID)] error:nil];
    NSLog(@"%d", flag);
    // 4、关闭数据库
    [db close];
}
- (NSMutableArray *)selectAllDataWithTableName:(NSString *)tableName
{
    [db open];
    NSString *string = [NSString stringWithFormat:@"select * from %@", tableName];
    
    FMResultSet *result = [db executeQuery:string];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([result next]) {
        MyLikeModel *model = [[MyLikeModel alloc] init];
        model.content = [result stringForColumn:@"content"];
        model.ID = [result intForColumn:@"ID"];
        [array addObject:model];
    }
    [db close];
    return array;
}
@end
