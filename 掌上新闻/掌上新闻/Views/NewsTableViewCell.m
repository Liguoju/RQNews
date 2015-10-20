//
//  NewsTableViewCell.m
//  HACursor
//
//  Created by qianfeng on 15/9/22.
//  Copyright © 2015年 haha. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    self.newsImageView.layer.masksToBounds = YES;
    self.newsImageView.layer.cornerRadius  = 8;
}

- (void)updateWithBaseModel:(DataModel *)model{
    
    self.titleLabel.text  = model.title;
    NSArray *authorArr = [AuthorModel parseWithModel:model];
    AuthorModel *authorModel = [authorArr lastObject];
    NSString *time = [LimitHelper calculateLeftTimeFrom:model.published];
    self.authorLabel.text = [NSString stringWithFormat:@"%@  %@前",authorModel.name,time];
    
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:model.o_image] placeholderImage:nil];
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
