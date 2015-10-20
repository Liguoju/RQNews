//
//  AuthorModel.m
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "AuthorModel.h"

@implementation AuthorModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

+ (NSMutableArray *)parseWithModel:(DataModel *)model{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in model.author_list) {
        
        AuthorModel *baseModel = [[AuthorModel alloc]init];
        [baseModel setValuesForKeysWithDictionary:dic];
        
        [array addObject:baseModel];
    }
    return array;
}


@end
