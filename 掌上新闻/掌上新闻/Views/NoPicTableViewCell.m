//
//  NoPicTableViewCell.m
//  网易新闻
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "NoPicTableViewCell.h"

@implementation NoPicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateWithBaseModel:(DataModel *)model{
    _TitleLabel.text = model.title;
    NSString *time = [LimitHelper calculateLeftTimeFrom:model.published];
    NSArray *authorArr = [AuthorModel parseWithModel:model];
    AuthorModel *authorModel = [authorArr lastObject];
    NSString *name = authorModel.name;
    _publishedTimeLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
    if (name.length != 0) {
        _publishedTimeLabel.text = [NSString stringWithFormat:@"%@  %@前",name,time];
    }else{
        _publishedTimeLabel.text = [NSString stringWithFormat:@"%@前",time];
    }
    if (![model.comment isEqualToString:@"0"]) {
        _contentLael.text = model.comment;
        _contentLael.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
    }
    _scanLabel.text   = model.month_hit;
    _scanLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
