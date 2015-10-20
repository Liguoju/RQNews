//
//  RootModel.h
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSMutableArray  *data;

@property (nonatomic, copy) NSString *channel_type;

+ (NSMutableArray *)parseRespondData:(id)respondData;
@end
