//
//  AuthorModel.h
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface AuthorModel : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *user_other;
@property (nonatomic, copy) NSString *is_v;
@property (nonatomic, copy) NSString *ppt_uid;
@property (nonatomic, copy) NSString *is_show_v;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *url;

+ (NSMutableArray *)parseWithModel:(DataModel *)model;
@end
