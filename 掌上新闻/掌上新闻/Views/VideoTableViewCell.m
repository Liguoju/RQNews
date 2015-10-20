//
//  VideoTableViewCell.m
//  网易新闻
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.VideoImageView.layer.masksToBounds = YES;
    self.VideoImageView.layer.cornerRadius  = 8;
}

- (void)updateWithBaseModel:(DataModel *)model{
    _dataModel = model;
    _TitleLael.text = model.title;
    if (![model.comment isEqualToString:@"0"]) {
        _contentLabel.text = model.comment;
        _contentLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
    }
    _scanLabel.text   = model.month_hit;
    _scanLabel.textColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
    
    NSString *time = [LimitHelper calculateLeftTimeFrom:model.published];
    NSArray *authorArr = [AuthorModel parseWithModel:model];
    AuthorModel *authorModel = [authorArr lastObject];
    NSString *name = authorModel.name;
    if (name.length != 0) {
        _publishedTimeLael.text = [NSString stringWithFormat:@"%@  %@前",name,time];
    }else{
        _publishedTimeLael.text = [NSString stringWithFormat:@"%@前",time];
    }
    
    [_VideoImageView sd_setImageWithURL:[NSURL URLWithString:model.z_image]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
