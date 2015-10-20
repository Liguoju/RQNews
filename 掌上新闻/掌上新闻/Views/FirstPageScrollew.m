//
//  FirstPageScrollew.m
//  网易新闻
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "FirstPageScrollew.h"

@interface FirstPageScrollew ()
@end
@implementation FirstPageScrollew

- (instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        [self createImageViewsWithImageArray:array];
    }
    return self;
}
- (void)createImageViewsWithImageArray:(NSArray *)array{
    for (int index = 0; index < array.count; index++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.frame = CGRectMake(index*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        UILabel  *titleLabel = [[UILabel alloc]init];
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.3;
        view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [titleLabel sizeToFit];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40) ;
        
        DataModel *model = array[index];
        titleLabel.text = model.title;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.o_image] placeholderImage:nil];
        
        [imageView addSubview:view];
        [imageView addSubview:titleLabel];
        [self addSubview:imageView];
    }
    self.contentSize = CGSizeMake(array.count*self.bounds.size.width, self.bounds.size.height);
}

@end
