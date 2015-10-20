//
//  DetailViewController.h
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic) DataModel *dataModel;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *type;
@end
