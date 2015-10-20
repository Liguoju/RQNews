//
//  LimitDBManager.h
//  LimitFree
//
//  Created by lijinghua on 15/9/15.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface LimitDBManager : NSObject

+ (instancetype)sharedInstance;

//type ：浏览，下载，收藏
//添加
- (void)addNewInfo:(DataModel*)model title:(NSString *)title type:(NSString*)type;

//删除
- (void)deleteNewInfo:(DataModel*)model type:(NSString*)type;

//根据type读取newsInfo的列表
- (NSArray*)readNewInfoList:(NSString*)type;

//判断类型为type的app 是否存在表中
- (BOOL)isNewInfoExists:(DataModel*)model type:(NSString*)type;

@end
