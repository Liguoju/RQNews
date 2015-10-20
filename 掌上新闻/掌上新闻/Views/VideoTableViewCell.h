//
//  VideoTableViewCell.h
//  网易新闻
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *VideoImageView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLael;
@property (weak, nonatomic) IBOutlet UILabel *publishedTimeLael;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@property (nonatomic) DataModel *dataModel;
- (void)updateWithBaseModel:(DataModel *)model;
@end
