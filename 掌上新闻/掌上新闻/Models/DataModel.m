//
//  DataModel.m
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

+ (NSMutableArray *)parseWithModel:(RootModel *)model{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in model.data) {
        DataModel *baseModel = [[DataModel alloc]init];
        [baseModel setValuesForKeysWithDictionary:dic];
        
        [array addObject:baseModel];
    }
    return array;
}

+ (NSMutableArray *)parseRespondData:(id)respondData{
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *resultDic = respondData[@"result"];
    NSArray  *rstArr = resultDic[@"rst"];
    for (NSDictionary *dic in rstArr) {
        DataModel *model = [[DataModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        if (model.id.length > 3) {
            [array addObject:model];
        }
    }
    return array;
}

@end
