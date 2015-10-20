//
//  ViewController.h
//  掌上新闻
//
//  Created by qianfeng on 15/10/11.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic) CGPoint dragFromPoint;
@property (nonatomic) CGPoint dragToPoint;
@property (nonatomic) CGRect  dragToFrame;
@property (nonatomic) BOOL isContainItem;

@property (nonatomic) NSMutableArray *newsTitleArray;

@property (nonatomic) NSMutableArray *deleteTitleArray;

@property (nonatomic) NSInteger deleteIndex;

@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) BOOL isShake;

@property (nonatomic) BOOL isRespondLongPress;


@end

