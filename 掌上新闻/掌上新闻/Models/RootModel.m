//
//  RootModel.m
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "RootModel.h"

@implementation RootModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

+ (NSMutableArray *)parseRespondData:(id)respondData{
    
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *resultDic = respondData[@"result"];
    NSArray  *rstArr = resultDic[@"rst"];
    for (NSDictionary *dic in rstArr) {
        
        RootModel *model = [[RootModel alloc]init];
        model.name = dic[@"name"];
        model.data = dic[@"data"];
        model.channel_type = dic[@"channel_type"];
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:model.data];
        [array addObject:model.name];
        [array addObject:model.channel_type];
        [arr addObject:array];
    }
    return arr;
}

@end
