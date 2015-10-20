//
//  CollectTableViewCell.m
//  网易新闻
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "CollectTableViewCell.h"

@implementation CollectTableViewCell

- (void)awakeFromNib {
    _headImageView.layer.cornerRadius = 8;
    _headImageView.layer.masksToBounds = YES;
}

- (void)updateWithModel:(DataModel *)model{
    _titleLabel.text = model.title;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.z_image]];
    
    NSString *time = [LimitHelper calculateLeftTimeFrom:model.published];
    _timeLabel.text = [NSString stringWithFormat:@"%@前",time];
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
