//
//  CtiyViewController.h
//  网易新闻
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol returnCityName <NSObject>

- (void)returnCityName:(NSString *)city and:(NSString *)capital;
@end
@interface CtiyViewController : UIViewController

@property (nonatomic, assign) id <returnCityName> delegate;
@end
