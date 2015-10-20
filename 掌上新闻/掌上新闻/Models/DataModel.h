//
//  DataModel.h
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootModel.h"

@interface DataModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *smalltitle;
@property (nonatomic, copy) NSString *subhead;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *image_path;
@property (nonatomic, copy) NSString *z_image;
@property (nonatomic, copy) NSString *o_image;
@property (nonatomic, copy) NSString *s_image;
@property (nonatomic, copy) NSString *m_image;

@property (nonatomic, copy) NSString *cl_image;
@property (nonatomic, copy) NSString *l_image;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *published;
@property (nonatomic, copy) NSString *publishtime;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *headline;
@property (nonatomic, copy) NSString *quotation;
@property (nonatomic, copy) NSString *t_recommend;

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *collect;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *audit;
@property (nonatomic, copy) NSString *ding;
@property (nonatomic, copy) NSString *hit;
@property (nonatomic, copy) NSString *day_hit;
@property (nonatomic, copy) NSString *week_hit;
@property (nonatomic, copy) NSString *month_hit;

@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *survey_id;
@property (nonatomic, copy) NSString *i_show_tpl;
@property (nonatomic, copy) NSString *img;

@property (nonatomic) NSMutableArray *author_list;

+ (NSMutableArray *)parseWithModel:(RootModel *)model;

+ (NSMutableArray *)parseRespondData:(id)respondData;
@end
