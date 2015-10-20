//
//  LimitHelper.m
//  LimitFree
//
//  Created by lijinghua on 15/9/14.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "LimitHelper.h"

@implementation LimitHelper

+(NSString*)calculateLeftTimeFrom:(NSString*)dateString
{
    //首先根据输入的字符串的日期格式得到输入的日期
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
//    format.dateFormat = @"yyyyMMddHHMMss";
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss.0"];
    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:[dateString intValue]];
    
    NSDate *nowDate = [NSDate date];
    
    //得到日历类，由它来帮我们计算两个日期之间的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *component = [calendar components:flag fromDate:toDate toDate:nowDate options:0];
    if (component.day > 0) {
        return [NSString stringWithFormat:@"%ld天",component.day];
    }else if (component.hour > 0) {
        return [NSString stringWithFormat:@"%ld小时",component.hour];
    }else if (component.minute >0){
        return [NSString stringWithFormat:@"%ld分钟",component.minute];
    }
    return nil;
}

+(NSString*)calculateLeftTimeFromNow{
    NSCalendar *calendar = [NSCalendar currentCalendar];
     //得到日历类，由它来帮我们计算两个日期之间的差距
    NSUInteger flag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *now = [NSDate date];
    NSDateComponents *comps = [calendar components:flag fromDate:now];
    
    NSArray *array = @[@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSInteger index = comps.weekday - 1;
    NSString *date = [NSString stringWithFormat:@"%ld-%ld-%ld  %@",comps.year,comps.month,comps.day,array[index]];
    return date;
}
@end
