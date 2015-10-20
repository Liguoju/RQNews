//
//  LimitHelper.h
//  LimitFree
//
//  Created by lijinghua on 15/9/14.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LimitHelper : NSObject

//输入一个日期的字符串，得到到目前为止剩余的时间,时 分 秒
+(NSString*)calculateLeftTimeFrom:(NSString*)dateString;

+(NSString*)calculateLeftTimeFromNow;
@end
