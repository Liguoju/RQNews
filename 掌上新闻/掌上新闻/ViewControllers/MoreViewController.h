//
//  MoreViewController.h
//  网易新闻
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CtiyViewController.h"

@interface MoreViewController : UIViewController<returnCityName>

@property (nonatomic, strong) UILabel *currentTmpLabel;
@property (nonatomic, strong) UILabel *tmpperatureLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *windLabel;
@property (nonatomic, strong) UIImageView *weatherImageView;
@property (nonatomic, strong) UILabel *cityLabel;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *capital;
@end
