//
//  ViewController.m
//  掌上新闻
//
//  Created by qianfeng on 15/10/11.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "ViewController.h"

#define kSortItemBaseTag 101
//#define kSortItemBAseTag 11
#define kDeleItemBaseTag 1001
#define kMoreItem 100
#define kSortMoreItemBaseTag 51
#define angle2Radian(angle) ((angle) / 180.0 * M_PI)
@interface ViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;

@property (nonatomic, strong) TitleLabel *oldTitleLabel;
@property (nonatomic, assign) CGFloat     beginOffsetX;

@property (nonatomic, assign, getter=isWeatherShow) BOOL wwatherShow;
@property (nonatomic, strong) UIImageView *tran;

//@property (nonatomic, strong) UIButton *rightItem;

@property (nonatomic, strong) UIView *sortItemView;
//@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UIView   *titleView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel  *tipsLabel;

@end

@implementation ViewController

#pragma mark -
#pragma mark - *******************懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"掌上新闻";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    self.navigationController.navigationBar.translucent = NO;
    [self initNewsData];
    [self addController];
    [self addLabel];
    [self customUI];
    [self createSortButton];
    [self createTitleView];
    [self createSortItmView];
    [self customNavigationBarItem];
}

- (void)initNewsData{
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"News_like.plist" ofType:nil];
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"DislikeNews.plist" ofType:nil];
    NSArray *array  = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *array1 = [NSArray arrayWithContentsOfFile:filePath1];
    
    NSArray *NewsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"newsTitleArray"];
    NSArray *deleArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"deleteTitleArray"];
    NSLog(@"%ld",NewsArray.count);
    NSLog(@"%ld",deleArray.count);
    if ((NewsArray.count + deleArray.count) == 30) {
        _newsTitleArray   = [NSMutableArray arrayWithArray:NewsArray];
        _deleteTitleArray = [NSMutableArray arrayWithArray:deleArray];
    }else{
        _newsTitleArray   = [NSMutableArray arrayWithArray:array];
        _deleteTitleArray = [NSMutableArray arrayWithArray:array1];
    }
}

- (void)customUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.showsVerticalScrollIndicator   = NO;
    self.titleScrollView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
    self.contentScrollView.delegate = self;
    
    
    self.contentScrollView.pagingEnabled = YES;
    
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
    
    TitleLabel *label = [self.titleScrollView.subviews firstObject];
    label.scale = 1.0;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
}
#pragma mark -
#pragma mark - 创建排序按钮
///////////////////////////////////////////////
- (void)createTitleView{
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W - 45, 45)];
    _titleView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
    
    [_titleView addSubview:self.sortItemView];
    [_titleView addSubview:self.confirmButton];
    [_titleView addSubview:self.tipsLabel];
}
- (void)createSortButton{
    _sortButton.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
    _sortButton.adjustsImageWhenDisabled = NO;
    [_sortButton addTarget:self action:@selector(sortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.sortButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
}
#pragma mark - 栏目切换
- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(-180, 0, 90, 45)];
        _tipsLabel.text = @"栏目切换";
        _tipsLabel.textColor = [UIColor blackColor];
        _tipsLabel.font = [UIFont systemFontOfSize:22];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _tipsLabel;
}

- (void)createSortItmView{
    
    _sortItemView = [[UIView
                      alloc]initWithFrame:CGRectMake(-SCREEN_W, 45, SCREEN_W, SCREEN_H-64-45)];
    _sortItemView.userInteractionEnabled = YES;
    _sortItemView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [self addSortItem];
}
#pragma mark - 添加排序item
- (void)addSortItem{
    
    for (NSInteger index = 0; index < _newsTitleArray.count; index++) {
        NSInteger itemSpace = 20;
        NSInteger lineSpace = 15;
        NSInteger cols = 4;
        NSInteger row  = index / cols;
        NSInteger col  = index % cols;
        CGFloat sortItem_W = (SCREEN_W - (cols + 1) * itemSpace) / cols;
        CGFloat sortItem_H = 35;
        
        UIButton *sortItem = [UIButton buttonWithType:UIButtonTypeCustom];
        UIView  *view = [[UIView alloc] init];
        view.tag = kSortItemBaseTag + index;
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(itemSpace + col * (itemSpace + sortItem_W) - 15, itemSpace + row * (sortItem_H + lineSpace) - 15, sortItem_W + 15, sortItem_H + 15);
        
//        sortItem.tag = kSortItemBAseTag + index;
        sortItem.frame = CGRectMake(15, 15, sortItem_W, sortItem_H);
//        sortItem.backgroundColor = [UIColor colorWithRed:102/255.0 green:1.0 blue:102/255.0 alpha:1.0];
        sortItem.layer.borderWidth = 2;
        sortItem.layer.borderColor = [UIColor greenColor].CGColor;
        sortItem.layer.cornerRadius  = 8;
        NSString *title = [[_newsTitleArray objectAtIndex:index] objectForKey:@"title"];
        [sortItem setTitle:title forState:(UIControlStateNormal)];
        [sortItem setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [sortItem addTarget:self action:@selector(handleSortItem:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sortItem];
        
        [_sortItemView addSubview:view];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.cancelsTouchesInView = NO;
        [view addGestureRecognizer:longPress];
        
        UIButton *deleItem = [self addDeleItemOnSortItem];
        
        deleItem.tag = kDeleItemBaseTag + index;
        [view addSubview:deleItem];
    };
    UILabel *label = [[UILabel alloc] init];
    label.tag = kMoreItem;
    NSInteger maxIndex = _newsTitleArray.count - 1;
    UIButton *button = (UIButton *)[_sortItemView viewWithTag:maxIndex + kSortItemBaseTag];
    label.frame = CGRectMake(20, button.y + button.height + 5, 200, 45);
    label.font = [UIFont systemFontOfSize:22];
    label.text = @"点击添加更多栏目";
    [self.sortItemView addSubview:label];
    
    for (NSInteger index = 0; index < _deleteTitleArray.count; index++) {
        NSInteger itemSpace = 20;
        NSInteger lineSpace = 15;
        NSInteger cols = 4;
        NSInteger row  = index / cols;
        NSInteger col  = index % cols;
        CGFloat sortItem_W = (SCREEN_W - (cols + 1) * itemSpace) / cols;
        CGFloat sortItem_H = 35;
        UIButton *sortItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        sortItem.frame = CGRectMake(itemSpace + col * (itemSpace + sortItem_W), itemSpace + row * (sortItem_H + lineSpace) + label.y + 30, sortItem_W, sortItem_H);
//        sortItem.backgroundColor = [UIColor colorWithRed:1.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        sortItem.layer.borderWidth = 2;
        sortItem.layer.borderColor = [UIColor yellowColor].CGColor;

        sortItem.layer.cornerRadius  = 8;
        NSString *title = [[_deleteTitleArray objectAtIndex:index] objectForKey:@"title"];
        [sortItem setTitle:title forState:(UIControlStateNormal)];
        [sortItem setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        sortItem.tag = kSortMoreItemBaseTag + index;
        [sortItem addTarget:self action:@selector(MoreItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_sortItemView addSubview:sortItem];
    }
}
- (void)handleSortItem:(UIButton *)button{
    if (_confirmButton.selected == NO && _isRespondLongPress == NO) {
        NSLog(@"点击事件出发成功");
        NSInteger index = button.superview.tag - kSortItemBaseTag;
        NSLog(@"++++%ld++++%ld",index,button.tag);
        CGFloat offsetX = index * SCREEN_W;
        CGFloat offsetY = self.contentScrollView.contentOffset.y;
        CGPoint offset  = CGPointMake(offsetX, offsetY);
        [self sortButtonClick];
        [self.contentScrollView setContentOffset:offset animated:YES];
        [self setTitleScrollViewContentSizeWithIndex:index];
    }
    _isRespondLongPress = NO;
}
- (UIButton *)addDeleItemOnSortItem{
    
    UIButton *deleteItem = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteItem.frame = CGRectMake( 0, 0, 30, 30);
    deleteItem.layer.cornerRadius = 15;
    deleteItem.layer.masksToBounds = YES;
//        deleteItem.backgroundColor = [UIColor greenColor];
    [deleteItem setImage:[UIImage imageNamed:@"iconfont-shanchu.png"] forState:(UIControlStateNormal)];
    [deleteItem addTarget:self action:@selector(deleteItem:) forControlEvents:(UIControlEventTouchUpInside)];
    
    if (_isShake) {
        deleteItem.hidden = NO;
    }else{
        deleteItem.hidden = YES;
    }
    return deleteItem;
}

#pragma mark - 删除事件
- (void)deleteItem:(UIButton *)button{
    
    _deleteIndex = button.superview.tag - kSortItemBaseTag;
    _dragToPoint = button.superview.center;
    [button.superview removeFromSuperview];
    
    __block NSMutableArray *SortItemlist = _newsTitleArray;
    __block NSMutableArray *DeleItemlist = _deleteTitleArray;
    __block UIView *SortItemView = _sortItemView;
    //    NSLog(@"%ld %ld",_deleteIndex,SortItemlist.count);
    [UIView animateWithDuration:0.3 animations:^{
        //        NSLog(@"%ld %ld",_deleteIndex,SortItemlist.count);
        for (NSInteger index = _deleteIndex +1; index < SortItemlist.count; index++) {
            UIButton *item = (UIButton *)[SortItemView viewWithTag:index + kSortItemBaseTag];
            _dragFromPoint = item.center;
            item.center    = _dragToPoint;
            _dragToPoint   = _dragFromPoint;
            item.tag--;
        }
        
        UILabel *moreItemLabel = (UILabel *)[SortItemView viewWithTag:kMoreItem];
        NSInteger maxIndex = SortItemlist.count - 2;
        UIButton *button = (UIButton *)[SortItemView viewWithTag:maxIndex + kSortItemBaseTag];
        
        [UIView animateWithDuration:0.3 animations:^{
            moreItemLabel.y = button.y + button.height + 10;
            
            [DeleItemlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                UIButton *item = (UIButton *)[SortItemView viewWithTag:idx + kSortMoreItemBaseTag];
                UIButton *formerItem = (UIButton *)[SortItemView viewWithTag:idx + kSortMoreItemBaseTag -1];
                NSInteger row = idx / 4;
                item.y = 20 + row * (formerItem.height + 15) + moreItemLabel.y + 30;
            }];
        }];
        [DeleItemlist addObject:[SortItemlist objectAtIndex:_deleteIndex]];
        [self addDeleItemWith:DeleItemlist andMoreItemLabelHeight:moreItemLabel.y];
    } completion:^(BOOL finished) {
        [SortItemlist removeObjectAtIndex:_deleteIndex];
        UIViewController *viewController = [self.childViewControllers objectAtIndex:_deleteIndex];
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
        [[NSUserDefaults standardUserDefaults] setObject:SortItemlist forKey:@"newsTitleArray"];
        [[NSUserDefaults standardUserDefaults] setObject:DeleItemlist forKey:@"deleteTitleArray"];
    }];
}

- (void)addDeleItemWith:(NSMutableArray *)array andMoreItemLabelHeight:(CGFloat)height{
    if (array.count != 0) {
        
        NSInteger index = array.count - 1;
        NSInteger itemSpace = 20;
        NSInteger lineSpace = 15;
        NSInteger cols = 4;
        NSInteger row  = index / cols;
        NSInteger col  = index % cols;
        CGFloat sortItem_W = (SCREEN_W - (cols + 1) * itemSpace) / cols;
        CGFloat sortItem_H = 35;
        UIButton *sortItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        sortItem.frame = CGRectMake(itemSpace + col * (itemSpace + sortItem_W), itemSpace + row * (sortItem_H + lineSpace) + height + 30, sortItem_W, sortItem_H);
//        sortItem.backgroundColor = [UIColor colorWithRed:1.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        sortItem.layer.borderWidth = 2;
        sortItem.layer.borderColor = [UIColor yellowColor].CGColor;

        sortItem.layer.cornerRadius  = 8;
        NSString *title = [[array objectAtIndex:index] objectForKey:@"title"];
        [sortItem setTitle:title forState:(UIControlStateNormal)];
        [sortItem setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        sortItem.tag = kSortMoreItemBaseTag + array.count -1;
        [sortItem addTarget:self action:@selector(MoreItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_sortItemView addSubview:sortItem];
    }
}

#pragma mark - 点击添加事件
- (void)MoreItemClick:(UIButton *)button{
    
    NSInteger currentIndex = button.tag - kSortMoreItemBaseTag;
    __block CGPoint currentPoint = button.center;
    [button removeFromSuperview];
    
    __block NSMutableArray *SortItemlist = _newsTitleArray;
    __block NSMutableArray *DeleItemlist = _deleteTitleArray;
    __block UIView *SortItemView = _sortItemView;
    
    UIButton *LastButton = (UIButton *)[SortItemView viewWithTag:SortItemlist.count - 1 + kSortItemBaseTag];
    CGFloat height = LastButton.y;
    [SortItemlist addObject:[DeleItemlist objectAtIndex:currentIndex]];
    [self addItemWithArray:SortItemlist andHeight:height];
    
    
    UILabel *moreItemLabel = (UILabel *)[SortItemView viewWithTag:kMoreItem];
    NSInteger maxIndex = SortItemlist.count - 1;
    UIButton *buttonUp = (UIButton *)[SortItemView viewWithTag:maxIndex + kSortItemBaseTag];
    
    [UIView animateWithDuration:0.3 animations:^{
        moreItemLabel.y = buttonUp.y + buttonUp.height + 10;
        [UIView animateWithDuration:0.3 animations:^{
            
            for (NSInteger index = currentIndex + 1; index < DeleItemlist.count; index++) {
                UIButton *item = (UIButton *)[SortItemView viewWithTag:index + kSortMoreItemBaseTag];
                CGPoint moveToPoint = item.center;
                item.center = currentPoint;
                currentPoint = moveToPoint;
                item.tag--;
            }
        } completion:^(BOOL finished) {
            
            [DeleItemlist removeObjectAtIndex:currentIndex];
            [[NSUserDefaults standardUserDefaults] setObject:SortItemlist forKey:@"newsTitleArray"];
            [[NSUserDefaults standardUserDefaults] setObject:DeleItemlist forKey:@"deleteTitleArray"];
        }];
        
        [DeleItemlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *item = (UIButton *)[SortItemView viewWithTag:idx + kSortMoreItemBaseTag];
            UIButton *formerItem = (UIButton *)[SortItemView viewWithTag:idx + kSortMoreItemBaseTag -1];
            NSInteger row = idx / 4;
            item.y = 20 + row * (formerItem.height + 15) + moreItemLabel.y + 30;
        }];
    }];
    [self updateTitleLabelWith:_newsTitleArray];
    NewsTableViewController *viewController = [[NewsTableViewController alloc] init];
    [self addChildViewController:viewController];
}

- (void)addItemWithArray:(NSArray *)array andHeight:(CGFloat)height{
    
    NSInteger index = array.count - 1;
    NSInteger itemSpace = 20;
    NSInteger lineSpace = 15;
    NSInteger cols = 4;
    NSInteger row  = index / cols;
    NSInteger col  = index % cols;
    CGFloat sortItem_W = (SCREEN_W - (cols + 1) * itemSpace) / cols;
    CGFloat sortItem_H = 35;
    
    UIButton *sortItem = [UIButton buttonWithType:UIButtonTypeCustom];
    UIView  *view = [[UIView alloc] init];
    view.frame = CGRectMake(itemSpace + col * (itemSpace + sortItem_W) - 15, itemSpace + row * (sortItem_H + lineSpace) - 15, sortItem_W + 15, sortItem_H +15);
    view.tag = kSortItemBaseTag + index;
    
    sortItem.frame = CGRectMake(15, 15, sortItem_W, sortItem_H);
//    sortItem.tag = kSortItemBAseTag + index;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    [view addGestureRecognizer:longPress];
    
//    sortItem.backgroundColor = [UIColor colorWithRed:102/255.0 green:1.0 blue:102/255.0 alpha:1.0];
    sortItem.layer.borderWidth = 2;
    sortItem.layer.borderColor = [UIColor greenColor].CGColor;

    sortItem.layer.cornerRadius  = 8;
    NSString *title = [[array objectAtIndex:index] objectForKey:@"title"];
    [sortItem setTitle:title forState:(UIControlStateNormal)];
    [sortItem setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    [sortItem addTarget:self action:@selector(handleSortItem:) forControlEvents:UIControlEventTouchUpInside];
    
//    sortItem.tag = kSortItemBaseTag + index;
    UIButton *deleItem = [self addDeleItemOnSortItem];
    deleItem.tag = kDeleItemBaseTag + index;
    
    if (_isShake) {
        [self ShakeWithItem:view];
    }else{
        [self ShakeStop:view];
    }
    //    NSLog(@"%ld %ld",sortItem.tag,deleItem.tag);
    
    [view addSubview:sortItem];
    [view addSubview:deleItem];
    [_sortItemView addSubview:view];
}
#pragma mark - 删除按钮的显现于隐藏
- (void)ShowDeleItem{
    [_newsTitleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *item = (UIButton *)[_sortItemView viewWithTag:idx + kSortItemBaseTag];
        UIButton *deleItem = [item.subviews lastObject];
        deleItem.hidden = NO;
    }];
}

- (void)HiddenDeleItem{
    [_newsTitleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *item = (UIButton *)[_sortItemView viewWithTag:idx + kSortItemBaseTag];
        UIButton *deleItem = [item.subviews lastObject];
        deleItem.hidden = YES;
    }];
    
}
#pragma mark - 长按事件
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [self dragItemBegin:recognizer];
        [self ShakeWithItem:recognizer.view];
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        
        [self dragItemMoved:recognizer];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        
        [self dragItemEnded:recognizer];
        _isRespondLongPress = YES;
        if (_confirmButton.selected) {
            
        }else{
            [self ShakeStop:recognizer.view];
        }
        [self updateTitleLabelWith:_newsTitleArray];
        
        [[NSUserDefaults standardUserDefaults] setObject:_newsTitleArray forKey:@"newsTitleArray"];
        [[NSUserDefaults standardUserDefaults] setObject:_deleteTitleArray forKey:@"deleteTitleArray"];
        NSLog(@"%ld  %ld",_newsTitleArray.count,_deleteTitleArray.count);
    }
}

#pragma mark - recognizer状态变化
- (void)dragItemBegin:(UILongPressGestureRecognizer *)recognizer{
    [_sortItemView bringSubviewToFront:recognizer.view];
    _dragFromPoint = recognizer.view.center;
}

- (void)dragItemMoved:(UILongPressGestureRecognizer *)recognizer{
    CGPoint locationPoint = [recognizer locationInView:_sortItemView];
    recognizer.view.center = locationPoint;
    [self MoveToLocationIfHasSortItem:recognizer.view];
}

- (void)dragItemEnded:(UILongPressGestureRecognizer *)recognizer{
    [UIView animateWithDuration:0.2f animations:^{
        if (_isContainItem) {
            recognizer.view.center = _dragToPoint;
        }else{
            recognizer.view.center = _dragFromPoint;
        }
    }];
    _isContainItem = NO;
}

- (void)MoveToLocationIfHasSortItem:(UIView *)sortItem{
    for (UIButton *item in _sortItemView.subviews) {
        BOOL isContainItem = CGRectContainsPoint(item.frame, sortItem.center);
        if (isContainItem && item != sortItem) {
            NSInteger fromIndex = sortItem.tag - kSortItemBaseTag;
            NSInteger toIndex   = (item.tag - kSortItemBaseTag)>0?(item.tag - kSortItemBaseTag):0;
            NSLog(@"从%ld 移到%ld",fromIndex,toIndex);
            [self dragMoveFromIndex:fromIndex toIndex:toIndex withItem:sortItem];
        }
    }
}
#pragma mark - 移动item
- (void)dragMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withItem:(UIView *)sortItem{
    __block NSMutableArray *sortItemArray = _newsTitleArray;
    __block UIView *sortItemView = _sortItemView;
    NSDictionary *moveDic = [sortItemArray objectAtIndex:fromIndex];
    [sortItemArray removeObjectAtIndex:fromIndex];
    [sortItemArray insertObject:moveDic atIndex:toIndex];
    
    if (fromIndex > toIndex) {
        [UIView animateWithDuration:0.3f animations:^{
            for (NSInteger index = fromIndex - 1; index >= toIndex; index--) {
                UIButton *dragItem = (UIButton *)[sortItemView viewWithTag:index + kSortItemBaseTag];
                _dragToPoint = dragItem.center;
                dragItem.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragItem.tag++;
            }
            
            sortItem.tag = kSortItemBaseTag + toIndex;
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            for (NSInteger index = fromIndex + 1; index <= toIndex; index++) {
                UIButton *dragItem = (UIButton *)[sortItemView viewWithTag:index + kSortItemBaseTag];
                _dragToPoint = dragItem.center;
                dragItem.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragItem.tag--;
            }
            sortItem.tag = kSortItemBaseTag + toIndex;
        }];
    }
}
#pragma mark - item动画
- (void)ShakeWithItem:(UIView *)item{
    _isShake = YES;
    // 1.创建核心动画
    CAKeyframeAnimation  *keyAnima = [CAKeyframeAnimation animation];
    keyAnima.keyPath = @"transform.rotation";
    // 度数 / 180 * M_PI
    keyAnima.values = @[@(-angle2Radian(5)), @(angle2Radian(5)), @(-angle2Radian(5))];
    
    keyAnima.removedOnCompletion = NO;
    keyAnima.fillMode = kCAFillModeForwards;
    keyAnima.duration = 0.15;
    
    // 设置动画重复的次数
    keyAnima.repeatCount = MAXFLOAT;
    // 2.添加核心动画
    [item.layer addAnimation:keyAnima forKey:nil];
}

- (void)ShakeStop:(UIView *)item{
    
    _isShake = NO;
    CAKeyframeAnimation  *keyAnima = [CAKeyframeAnimation animation];
    keyAnima.keyPath = @"transform.rotation";
    // 度数 / 180 * M_PI
    keyAnima.values = @[@(-angle2Radian(5)), @(angle2Radian(5)), @(-angle2Radian(5)),@(angle2Radian(0))];
    keyAnima.removedOnCompletion = NO;
    keyAnima.fillMode = kCAFillModeForwards;
    keyAnima.duration = 0.1;
    // 设置动画重复的次数
    keyAnima.repeatCount = 4;
    
    // 2.添加核心动画
    [item.layer addAnimation:keyAnima forKey:nil];
}

- (void)itemsShake{
    [_newsTitleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *item = (UIView *)[_sortItemView viewWithTag:idx + kSortItemBaseTag];
        [self ShakeWithItem:item];
    }];
}

- (void)itemsStopShake{
    
    [_newsTitleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *item = (UIButton *)[_sortItemView viewWithTag:idx + kSortItemBaseTag];
        [self ShakeStop:item];
    }];
}
#pragma mark - 排序删除
- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 10, 80, 25)];
        _confirmButton.layer.cornerRadius = 8;
        _confirmButton.alpha = 0;
        _confirmButton.adjustsImageWhenDisabled = NO;
        _confirmButton.layer.borderWidth = 1.0;
        _confirmButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _confirmButton.backgroundColor = [UIColor grayColor];
        [_confirmButton setTitle:@"排序删除" forState:UIControlStateNormal];
        [_confirmButton setTitle:@"完成" forState:UIControlStateSelected];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (void)confirmButtonClick{
   
    if (!self.confirmButton.isSelected) {
        
        [self ShowDeleItem];
        [self itemsShake];
    }else{
        
        [self HiddenDeleItem];
        [self itemsStopShake];
        [self updateTitleLabelWith:_newsTitleArray];
    }
    [self.confirmButton setSelected:!self.confirmButton.isSelected];
}

- (void)sortButtonClick{
    CGFloat duration = 0.8;
    CGFloat damp = 0.3;
    CGFloat velocity = 0.5;
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;

    //显示排序菜单
    if (!self.sortButton.isSelected) {
        item.enabled = NO;
        [self.view addSubview:self.sortItemView];
        [self.view bringSubviewToFront:_sortItemView];
        [self.view addSubview:self.titleView];
        [self.view bringSubviewToFront:_titleView];
        self.titleScrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damp initialSpringVelocity:velocity options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.sortItemView.x = 0;
            self.sortButton.imageView.transform = CGAffineTransformIdentity;
            self.tipsLabel.x = 20;
            self.confirmButton.alpha = 1;
            self.confirmButton.x = 0.65 * SCREEN_W;
        } completion:^(BOOL finished) {
            self.sortButton.enabled = YES;
        }];
    }else{
        item.enabled = YES;
        [_titleView removeFromSuperview];
        [_sortItemView removeFromSuperview];
        
        //隐藏排序菜单
        [UIView animateWithDuration:0.2 animations:^{
            self.confirmButton.alpha = 0;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.tipsLabel.x = - 2 * self.tipsLabel.width;
                self.confirmButton.x = 50;
                self.sortButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                self.sortItemView.x = -SCREEN_W;
            } completion:^(BOOL finished) {
            }];
        }];
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damp initialSpringVelocity:velocity options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
        } completion:^(BOOL finished) {
            
            self.titleScrollView.userInteractionEnabled = YES;
        }];
    }
    self.sortButton.selected = !self.sortButton.isSelected;
}
#pragma mark -
#pragma mark - 自定义rightItem
- (void)customNavigationBarItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-icon28.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightItemClick:)];
    rightItem.tintColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick:(UIBarButtonItem *)item{
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:NO];
}


#pragma mark - 刷新标题栏
- (void)updateTitleLabelWith:(NSMutableArray *)SortItemlist{
    
    NSLog(@"%ld",self.childViewControllers.count);
    [self.titleScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addLabel];
    NSLog(@"%ld",self.childViewControllers.count);
}
#pragma mark - 添加控制器
- (void)addController{
    
    for (int i = 0; i < self.newsTitleArray.count; i++) {
        NewsTableViewController *vc1 = [[NewsTableViewController alloc]init];
        [self addChildViewController:vc1];
    }
    NewsTableViewController *vc = [self.childViewControllers objectAtIndex:0];
    vc.title   = self.newsTitleArray[0][@"title"];
    vc.urlType = self.newsTitleArray[0][@"urlType"];
}

#pragma mark - 添加标题栏
- (void)addLabel{
    for (int i = 0; i < self.newsTitleArray.count; i++) {
        CGFloat laelW  = 70;
        CGFloat labelH = 45;
        CGFloat labelY = 0;
        CGFloat labelX = i * laelW;
        TitleLabel *label = [[TitleLabel alloc]init];
        
        label.text = self.newsTitleArray[i][@"title"];
        label.frame = CGRectMake(labelX, labelY, laelW, labelH);
        label.font = [UIFont systemFontOfSize:20];
        [self.titleScrollView addSubview:label];
        label.tag = i;
        label.userInteractionEnabled = YES;
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    self.titleScrollView.contentSize = CGSizeMake(70 * self.newsTitleArray.count, 0);
    CGFloat contentX = self.newsTitleArray.count * SCREEN_W;
    self.contentScrollView.contentSize   = CGSizeMake(contentX, 0);
    [self scrollViewDidScroll:self.contentScrollView];
}

- (void)labelClick:(UITapGestureRecognizer *)gesture{
    TitleLabel *titleLabel = (TitleLabel *)gesture.view;
    
    CGFloat offsetX = titleLabel.tag * SCREEN_W;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset  = CGPointMake(offsetX, offsetY);
    
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark -
#pragma mark - scrollView代理方法

- (void)setTitleScrollViewContentSizeWithIndex:(NSInteger)index{
    TitleLabel *titleLabel = (TitleLabel *)self.titleScrollView.subviews[index];
    CGFloat offsetX = titleLabel.center.x - self.titleScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
    if (offsetX < 0) {
        offsetX = 0;
    }else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    
    CGPoint  offset = CGPointMake(offsetX, 0);
    [self.titleScrollView setContentOffset:offset animated:YES];
}
/** 滚动动画结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    NSLog(@"+++++%ld++++",index);
    [self setTitleScrollViewContentSizeWithIndex:index];
    NewsTableViewController *newVC = self.childViewControllers[index];
    newVC.index = index;
    newVC.title   = self.newsTitleArray[index][@"title"];
    newVC.urlType = self.newsTitleArray[index][@"urlType"];
    
    [self.titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            TitleLabel *tmpLabel = self.titleScrollView.subviews[idx];
            tmpLabel.scale = 0.0;
        }
    }];
    if (newVC.view.superview) return;
    newVC.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:newVC.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //    [NSUserDefaults standardUserDefaults] obj
}

/** 滚动结束 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSInteger leftIndex = (int)value;
    NSInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    TitleLabel *labelLeft = self.titleScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    
    if (rightIndex < self.titleScrollView.subviews.count) {
        TitleLabel *label = self.titleScrollView.subviews[rightIndex];
        label.scale = scaleRight;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
