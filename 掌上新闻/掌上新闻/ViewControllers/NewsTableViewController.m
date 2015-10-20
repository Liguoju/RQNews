//
//  NewsTableViewController.m
//  网易新闻
//
//  Created by qianfeng on 15/9/25.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "NewsTableViewController.h"

@interface NewsTableViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayLists;
@property (nonatomic, strong) NSMutableArray *arrayList;
@property (nonatomic, strong) NSMutableArray *scrollewArrays;
@property (nonatomic) UIScrollView *firstPageScrollView;
@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic) NSInteger page;
@end

@implementation NewsTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrayLists = [NSMutableArray array];
        _arrayList  = [NSMutableArray array];
        _scrollewArrays = [NSMutableArray array];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self initData];
    [self fetchNewsData];
    [self loadData];
    [self loadMoreData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"VideoCellId"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoPicCellId"];
}

- (void)createTableHeaderView{
    if ([self.title isEqualToString:@"首页"]) {
        _firstPageScrollView = [[FirstPageScrollew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.56 * SCREEN_W) andImageArray:_scrollewArrays];
        _pageControl = [self createPageControlWithArray:_scrollewArrays];
        _firstPageScrollView.delegate = self;
         self.tableView.tableHeaderView = _firstPageScrollView;
        [self.view addSubview:_pageControl];
    }
}
- (void)initData{
    _page = 1;
    _isRefreshing = YES;
}

- (void)setUrlType:(NSString *)urlType{
    _urlType = urlType;
}
#pragma mark - 数据下载
- (void)fetchNewsData{
    if (![self fetchDataFromLocal]) {
        [self fetchDataFromServer];
    }
}

- (BOOL)fetchDataFromLocal{
    NSString *url = [self composeRequestUrlWithTitle:_urlType];
    if ([LimitCachManager isCacheDataInvalid:url]) {
        id respondData = [LimitCachManager readDataAtUrl:url];
        [self fetchDataWithUrl:url andData:respondData];
        [self.tableView reloadData];
        return YES;
    }
    return NO;
}

- (void)fetchDataFromServer{
    
    NSString *url = [self composeRequestUrlWithTitle:_urlType];
    [[NetDataEngine sharedInstance] requestNewsFrom:url success:^(id responsData) {
        [LimitCachManager saveData:responsData atUrl:url];
        [self fetchDataWithUrl:url andData:responsData];

        if (self.tableView.separatorStyle == UITableViewCellSeparatorStyleNone ) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        [self.tableView reloadData];
        [self endRefrehing];
    } failed:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

- (void)fetchDataWithUrl:(NSString *)url andData:(id)responsData{
    if ([url isEqualToString:[NSString stringWithFormat:kFirstPage_url,_page]]) {

        _arrayLists = [RootModel parseRespondData:responsData];
        NSArray *rootArr1 = [_arrayLists firstObject];
        NSArray *dataArray1 = rootArr1[0];
        for (NSDictionary *tmpDic in dataArray1) {
            DataModel *datamodel = [[DataModel alloc]init];
            [datamodel setValuesForKeysWithDictionary:tmpDic];
            if (datamodel.id.length > 3) {
                [_scrollewArrays addObject:datamodel];
            }
        }
        if (_isRefreshing) {
            [self createTableHeaderView];
        }
        
        NSArray *rootArr = [_arrayLists lastObject];
        NSArray *dataArray = rootArr[0];
        for (NSDictionary *tmpDic in dataArray) {
            DataModel *datamodel = [[DataModel alloc]init];
            [datamodel setValuesForKeysWithDictionary:tmpDic];
            if (datamodel.id.length > 3) {
                [_arrayList addObject:datamodel];
            }
        }
    }else {
        if (_isLoadingMore) {
            NSArray *arr = [DataModel parseRespondData:responsData];
            [_arrayList addObjectsFromArray:arr];
            return;
        }
        self.arrayList = [DataModel parseRespondData:responsData];
    }
}

- (NSString *)composeRequestUrlWithTitle:(NSString *)type{
    if ([self.title isEqualToString:@"首页"]){
        return [NSString stringWithFormat:kFirstPage_url,_page];
    }else if ([self.title isEqualToString:@"视频"]){
        return [NSString stringWithFormat:kVideo_url,_page];
    }else{
        return [NSString stringWithFormat:kcommon_url,type,_page];
    }
}
#pragma mark - 下拉刷新
- (void)loadData{
    
    __weak typeof(self)weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        [weakSelf initData];
        [weakSelf.scrollewArrays removeAllObjects];
        weakSelf.isRefreshing = YES;
        [weakSelf fetchDataFromServer];
    }];
}

#pragma mark - 上拉加载
- (void)loadMoreData{
    __weak typeof(self)weakSelf = self;
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if ([weakSelf.title isEqualToString:@"首页"] && weakSelf.page > 2) {
            [weakSelf.tableView footerEndRefreshing];
            return;
        }
        weakSelf.page++;
        weakSelf.isLoadingMore = YES;
        [weakSelf fetchDataFromServer];
    }];
}

- (void)endRefrehing{
    if (_isRefreshing) {
        _isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (_isLoadingMore) {
        _isLoadingMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
#pragma mark - Table view data source

- (BOOL)isEqualToTitle{
    if ([self.title isEqualToString:@"视频"] || [self.title isEqualToString:@"热评"] || [self.title isEqualToString:@"金融"] || [self.title isEqualToString:@"消费"] || [self.title isEqualToString:@"全部"] || [self.title isEqualToString:@"热读"] || [self.title isEqualToString:@"营销"] || [self.title isEqualToString:@"职场"] || [self.title isEqualToString:@"能源"] ||
        [self.title isEqualToString:@"快讯"] || [self.title isEqualToString:@"投资"] || [self.title isEqualToString:@"市值"] ||
        [self.title isEqualToString:@"Media"]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isEqualToTitle]) {
        
        DataModel *baseModel = [_arrayList objectAtIndex:indexPath.row];
        if (baseModel.z_image.length == 0) {
            NoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoPicCellId" forIndexPath:indexPath];
            [cell updateWithBaseModel:baseModel];
            return cell;
        }
        
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCellId" forIndexPath:indexPath];
        [cell updateWithBaseModel:baseModel];
        return cell;
    }else{
        DataModel *baseModel = [_arrayList objectAtIndex:indexPath.row];
        if (baseModel.z_image.length == 0) {
            NoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoPicCellId" forIndexPath:indexPath];
            [cell updateWithBaseModel:baseModel];
            return cell;
        }
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCellId" forIndexPath:indexPath];
        [cell updateWithBaseModel:baseModel];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataModel *model = [_arrayList objectAtIndex:indexPath.row];
    if ([self isEqualToTitle]) {
        if (model.z_image.length == 0) {
            return 80;
        }
        return 93;
    }else{
        if (model.z_image.length == 0) {
            return 80;
        }
        return 210;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*动画类型:
     animation.type = kCATransitionFade;
     animation.type = kCATransitionPush;
     animation.type = kCATransitionReveal;
     animation.type = kCATransitionMoveIn;
     animation.type = @"cube";
     animation.type = @"suckEffect";
     // 页面旋转
     animation.type = @"oglFlip";
     //水波纹
     animation.type = @"rippleEffect";
     animation.type = @"pageCurl";
     animation.type = @"pageUnCurl";
     animation.type = @"cameraIrisHollowOpen";
     animation.type = @"cameraIrisHollowClose";
     
     */
    DataModel *model = [_arrayList objectAtIndex:indexPath.row];
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.dataModel = model;
    detail.type = self.title;
    
    [self.navigationController pushViewController:detail animated:NO];
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}
#pragma mark -
#pragma mark - UIPageControl + UIScrollViewDelegate
- (UIPageControl *)createPageControlWithArray:(NSArray *)array{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 10*array.count, 20)];
    _pageControl.center = CGPointMake(SCREEN_W - _pageControl.bounds.size.width, 0.54 * SCREEN_W);
    _pageControl.numberOfPages = array.count;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    return _pageControl;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_firstPageScrollView]) {
        CGPoint offset = scrollView.contentOffset;
        NSInteger pageNumber = offset.x / scrollView.bounds.size.width;
        _pageControl.currentPage = pageNumber;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
