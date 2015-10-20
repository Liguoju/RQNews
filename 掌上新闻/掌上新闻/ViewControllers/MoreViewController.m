//
//  MoreViewController.m
//  网易新闻
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()
@property (nonatomic, strong) UIView  *bottomView;
@property (nonatomic, strong) UIView  *weatherView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *colorArray;


@property (nonatomic) NSMutableArray *WeatherArray;
@end

@implementation MoreViewController
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 0.62 *SCREEN_H)];
    }
    return _bottomView;
}

- (UIView *)weatherView{
    if (!_weatherView) {
        _weatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.38 * SCREEN_H)];
    }
    return _weatherView;
}
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [[NSArray alloc] init];
        _titleArray = @[@"首页",@"摇一摇",@"收藏",@"清除缓存",@"扫一扫",@"关于我们"];
    }
    return _titleArray;
}

- (NSArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [[NSArray alloc] init];
        _colorArray = @[[UIColor orangeColor],
                        [UIColor redColor],
                        [UIColor colorWithRed:213/255.0 green:22/255.0 blue:71/255.0 alpha:1],
                        [UIColor colorWithRed:58/255.0 green:153/255.0 blue:208/255.0 alpha:1],
                        [UIColor colorWithRed:70/255.0 green:95/255.0 blue:176/255.0 alpha:1],
                        [UIColor colorWithRed:80/255.0 green:192/255.0 blue:70/255.0 alpha:1]];
    }
    return _colorArray;
}
- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSArray alloc] init];
        _imageArray = @[[UIImage imageNamed:@"iconfont-shouye.png"],
                        [UIImage imageNamed:@"iconfont-2.png"],
                        [UIImage imageNamed:@"iconfont-iconfontshoucang.png"],
                        [UIImage imageNamed:@"iconfont-qingchu.png"],
                        [UIImage imageNamed:@"iconfont-saoyisao.png"],
                        [UIImage imageNamed:@"iconfont-guanyuwomen11"]
                        ];
    }
    return _imageArray;
}

- (UILabel *)currentTmpLabel{
    if (!_currentTmpLabel) {
         _currentTmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.05 * SCREEN_W, 0.10 * SCREEN_H, 0.32 * SCREEN_W, 0.15 * SCREEN_H)];
        _currentTmpLabel.font = [UIFont systemFontOfSize:_currentTmpLabel.width - 15];
        _currentTmpLabel.textColor = [UIColor redColor];
        _currentTmpLabel.textAlignment = NSTextAlignmentCenter;
        _currentTmpLabel.text = @"19";
    }
    return _currentTmpLabel;
}

- (UILabel *)tmpperatureLabel{
    if (!_tmpperatureLabel) {
        _tmpperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.37 * SCREEN_W, 0.20 * SCREEN_H, 0.4 * SCREEN_W, 21)];
        _currentTmpLabel.text = @"8℃/20℃";
    }
    return _tmpperatureLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.08 * SCREEN_W, 0.24 * SCREEN_H, 0.53 * SCREEN_W, 21)];
        _timeLabel.text = @"15-10-09  星期五";
    }
    return _timeLabel;
}

- (UILabel *)windLabel{
    if (!_windLabel) {
        _windLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.08 * SCREEN_W, 0.27 * SCREEN_H, 0.64 *SCREEN_W, 21)];
        _windLabel.text = @"北风  4-5级(17~25m/h)";
    }
    return _windLabel;
}

- (UIImageView *)weatherImageView{
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.75 * SCREEN_W                                                                                                            , 0.12 * SCREEN_H, 64, 64)];
        _weatherImageView.layer.cornerRadius  = 25;
        _weatherImageView.layer.masksToBounds = YES;
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-qing.png"];
    }
    return _weatherImageView;
}

- (UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.7 * SCREEN_W, 0.24 * SCREEN_H, 0.27 * SCREEN_W, 21)];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cityLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bottomView];
    [self createButtons];
    [self createWeatherView];
    [self fetchWeatherData];
    [self createCityBarItem];
}

- (void)fetchWeatherData{
    if (![self fetchWeatherDataFromLocal]) {
        [self fetchWeatherDataFromSever];
    }
}

- (NSString *)composeUrl{
    NSString *urlStr = nil;
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    NSLog(@"%@",self.cityName);
    if (cityName.length != 0) {
        self.cityName = cityName;
    }
    if (self.cityName.length != 0) {
        urlStr = [NSString stringWithFormat:kWeather,self.cityName];
    }else{
        urlStr = [NSString stringWithFormat:kWeather,@"北京"];
    }
    
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}
- (BOOL)fetchWeatherDataFromLocal{
    
    if ([LimitCachManager isCacheDataInvalid:@"weather"]) {
        id responsData = [LimitCachManager readDataAtUrl:@"weather"];
        [self parseRespondData:responsData];
        return YES;
    }
    return NO;
}

- (void)fetchWeatherDataFromSever{
    self.WeatherArray = [NSMutableArray array];
   
    NSString *url = [self composeUrl];
    NSLog(@"%@",url);
    [[NetDataEngine sharedInstance] requestWeatherFrom:url success:^(id responsData) {
        [self parseRespondData:responsData];
        [LimitCachManager saveData:responsData atUrl:@"weather"];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)parseRespondData:(id)responsData{
    if ([responsData[@"errMsg"] isEqualToString:@"success"]) {
        _WeatherArray = [WeatherModel parseRespondData:responsData];
        WeatherModel *model = [_WeatherArray lastObject];

        [self updateWeatherViewWithModel:model];
    }else{
        self.cityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"capital"];;
        [self fetchWeatherDataFromSever];
    }
}
#pragma mark -
- (void)createCityBarItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-dingwei.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightItemClick:)];
    rightItem.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClick:(UIBarButtonItem *)item{
    CtiyViewController *city = [[CtiyViewController alloc] init];
    city.delegate = self;
    [self.navigationController pushViewController:city animated:YES];
}

//添加天气数据
- (void)updateWeatherViewWithModel:(WeatherModel *)model{
    _currentTmpLabel.text = model.temp;
    _tmpperatureLabel.text = [NSString stringWithFormat:@"%@℃/%@℃",model.l_tmp,model.h_tmp];
    NSString *weekday = [LimitHelper calculateLeftTimeFromNow];
    _timeLabel.text = [NSString stringWithFormat:@"%@",weekday];
    _windLabel.text = [NSString stringWithFormat:@"%@  %@",model.WD,model.WS];
    if ([model.weather hasPrefix:@"晴"]) {
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-qing.png"];
    }else if ([model.weather hasSuffix:@"雨"]){
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-xiayu.png"];
    }else if ([model.weather hasSuffix:@"雪"]){
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-daxue.png"];
    }else{
        _weatherImageView.image = [UIImage imageNamed:@"iconfont-yin.png"];
    }
   
    _cityLabel.text = [NSString stringWithFormat:@"%@ %@",model.city,model.weather];
}
#pragma mark - 天气视图
- (void)createWeatherView{
   
    UILabel *Clabel = [[UILabel alloc] initWithFrame:CGRectMake(0.37 * SCREEN_W, 0.11 * SCREEN_H, 32, 32)];
    Clabel.font = [UIFont systemFontOfSize:25];
    Clabel.text = @"℃";
    
    [self.weatherView addSubview:self.currentTmpLabel];
    [self.weatherView addSubview:Clabel];
    [self.weatherView addSubview:self.tmpperatureLabel];
    [self.weatherView addSubview:self.timeLabel];
    [self.weatherView addSubview:self.windLabel];
    [self.weatherView addSubview:self.weatherImageView];
    [self.weatherView addSubview:self.cityLabel];
    
    [self.view addSubview:self.weatherView];
}

#pragma mark - 添加button
- (void)createButtons{
    for (int index = 0; index < 6; index++) {
        NSInteger col = index % 3;
        NSInteger row = index / 3;
        CGFloat  margin = 20;
        CGFloat ButtonW = (SCREEN_W - margin * 4) / 3.0;
        CGFloat ButtonH = ButtonW;
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 101 + index;
        btn.frame = CGRectMake(margin + col *(margin + ButtonW), margin + row * (margin * 3 + ButtonH), ButtonW, ButtonH);
        [btn setImage:self.imageArray[index] forState:(UIControlStateNormal)];
        btn.layer.cornerRadius = ButtonW / 2;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = self.colorArray[index];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 201 + index;
        label.frame = CGRectMake(margin + col *(margin + ButtonW), margin + row * (margin * 3 + ButtonH) + ButtonH, ButtonW, 40);
        label.text = self.titleArray[index];
        label.textAlignment = NSTextAlignmentCenter;
        [self.bottomView addSubview:label];
        [self.bottomView addSubview:btn];
    }
}

- (void)buttonClick:(UIButton *)button{
    NSInteger tag = button.tag;
    if (tag == 101){
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UINavigationController *rootVC = (UINavigationController *)window.rootViewController;
        UIViewController *rootVC1 = [rootVC.viewControllers firstObject];
        UIScrollView *contentScrollView = [rootVC1.view.subviews firstObject];
        UIScrollView *titleScrollView = [rootVC1.view.subviews objectAtIndex:1];
        CGPoint offset = CGPointMake(0, 0);
        [contentScrollView setContentOffset:offset animated:YES];
        [titleScrollView setContentOffset:offset animated:YES];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }else if (tag == 102){
        
        ShakeViewController *shakeVC = [[ShakeViewController alloc] init];
        [self.navigationController pushViewController:shakeVC animated:NO];
        
    }else if (tag == 103){
        
        CollectViewController *collect = [[CollectViewController alloc] init];
        [self.navigationController pushViewController:collect animated:YES];
        
    }else if (tag == 104){
        [LimitCachManager clearDisk];
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"清除缓存成功" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alterVC animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alterVC dismissViewControllerAnimated:YES completion:nil];
        });

    }else if (tag == 105){
        
        QRViewController *qr = [[QRViewController alloc] init];
        [self.navigationController pushViewController:qr animated:NO];
    }else{
        AboutUsViewController *about = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self fetchWeatherData];
}
- (void)viewDidAppear:(BOOL)animated{
//    [self fetchWeatherData];
//    [self fetchWeatherDataFromSever];
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:(UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.bottomView.y = 0.38 * SCREEN_H;
    } completion:^(BOOL finished) {
    }];
}

- (void)returnCityName:(NSString *)city and:(NSString *)capital{
    _cityName = city;
    _capital  = capital;
    [[NSUserDefaults standardUserDefaults] setObject:_cityName forKey:@"cityName"];
//    [[NSUserDefaults standardUserDefaults] setObject:_capital forKey:@"capital"];
    NSLog(@"%@",_cityName);
    [self fetchWeatherDataFromSever];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
