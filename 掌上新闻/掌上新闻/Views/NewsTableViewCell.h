//
//  NewsTableViewCell.h
//  HACursor
//
//  Created by qianfeng on 15/9/22.
//  Copyright © 2015年 haha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootModel.h"
#import "DataModel.h"
#import "AuthorModel.h"

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLael;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

- (void)updateWithBaseModel:(DataModel *)model;
@end
