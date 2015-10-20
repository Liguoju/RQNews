//
//  LimitDBManager.m
//  LimitFree
//
//  Created by lijinghua on 15/9/15.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "LimitDBManager.h"
#import "FMDatabase.h"

@interface LimitDBManager()
{
    FMDatabase *_db;   //数据库实例
}
@end

@implementation LimitDBManager


+ (instancetype)sharedInstance
{
    static LimitDBManager *s_dbManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_dbManager = [[LimitDBManager alloc]init];
    });
    return s_dbManager;
}

- (NSString*)dbPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/news.db"];
}

- (id)init{
    if (self = [super init]) {
        NSLog(@"dbPath = %@",[self dbPath]);
        _db  = [[FMDatabase alloc]initWithPath:[self dbPath]];
        if ([_db open]) {
            [self createTable];
        }
    }
    return self;
}

- (void)createTable
{
    NSString *sql = @"create table if not exists newsInfo(NId integer primary key autoincrement,newId text,newTitle text,newIconUrl text,newPublished text,viewTitle text,type text)";
    if (![_db executeUpdate:sql]) {
        NSLog(@"创建表失败");
    }
}

//type ：浏览，下载，收藏
//添加
- (void)addNewInfo:(DataModel*)model title:(NSString *)title type:(NSString *)type{
    NSString *sql = @"insert into newsInfo(newId,newTitle,newIconUrl,newPublished,viewTitle,type) values(?,?,?,?,?,?)";
    if (![_db executeUpdate:sql,model.id,model.title,model.z_image,model.published,title,type]) {
        NSLog(@"插入记录失败");
    }
}

//删除
- (void)deleteNewInfo:(DataModel*)model type:(NSString*)type
{
    NSString *sql = @"delete from newsInfo where newId = ? AND type = ?";
    if (![_db executeUpdate:sql,model.id,type]) {
        NSLog(@"删除数据失败");
    }
}

//根据type读取newsInfo的列表
- (NSArray*)readNewInfoList:(NSString*)type
{
    NSMutableArray *newArray = [NSMutableArray array];
    NSString *sql = @"select * from newsInfo where type = ?";
    FMResultSet *resultSet = [_db executeQuery:sql,type];
    while (resultSet.next) {
        DataModel *Model = [[DataModel alloc]init];
        Model.id = [resultSet stringForColumn:@"newId"];
        Model.title     = [resultSet stringForColumn:@"newTitle"];
        Model.z_image   = [resultSet stringForColumn:@"newIconUrl"];
        Model.published = [resultSet stringForColumn:@"newPublished"];
        NSString *title = [resultSet stringForColumn:@"viewTitle"];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:Model];
        [array addObject:title];
        [newArray addObject:array];
    }
    [resultSet close];
    return newArray;
}

//判断类型为type的app 是否存在表中
- (BOOL)isNewInfoExists:(DataModel*)model type:(NSString*)type{
    BOOL isExist = NO;
    NSString *sql = @"select * from newsInfo where newId = ? and type = ?";
    FMResultSet *resultSet = [_db executeQuery:sql,model.id,type];
    if (resultSet.next) {
        isExist = YES;
    }
    [resultSet close];
    return isExist;
}

@end
