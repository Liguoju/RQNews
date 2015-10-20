//
//  NoPicTableViewCell.h
//  网易新闻
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLael;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

- (void)updateWithBaseModel:(DataModel *)model;
@end
