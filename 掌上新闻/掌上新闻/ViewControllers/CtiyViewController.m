//
//  CtiyViewController.m
//  网易新闻
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "CtiyViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
@interface CtiyViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *currentCity;
@end

@implementation CtiyViewController

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) style:(UITableViewStylePlain)];
        self.tableView.dataSource = self;
        self.tableView.delegate   = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self locate];
    
    [self initDataSource];
    [self.view addSubview:self.tableView];
}

- (void)locate{
    self.currentCity = [[NSString alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        float version = [[UIDevice currentDevice].systemVersion floatValue];
        if(version >= 8.0){
            [_locationManager requestAlwaysAuthorization];
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locationManager.distanceFilter  = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"home_cannot_locate", comment:@"无法进行定位") message:NSLocalizedString(@"home_cannot_locate_message", comment:@"请检查您的设备是否开启定位功能") delegate:self cancelButtonTitle:NSLocalizedString(@"common_confirm",comment:@"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 初始化数据
- (void)initDataSource{
    self.dataSource = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *proDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    NSArray *provinceArray = proDic[@"城市代码"];
    NSMutableArray *locationSec = [NSMutableArray array];
    [locationSec addObject:@"定位到的城市"];
    [locationSec addObject:self.currentCity];
    [self.dataSource addObject:locationSec];

    for (NSDictionary *dic in provinceArray) {
        NSMutableArray *dataProvince = [NSMutableArray array];
        NSMutableArray *dataCity     = [NSMutableArray array];
        NSString *province = dic[@"省"];
        NSArray  *areaArr  = dic[@"市"];
        [dataProvince addObject:province];
        for (NSDictionary *cityDic in areaArr) {
            NSString *city = cityDic[@"市名"];
            [dataCity addObject:city];
        }
        [dataProvince addObject:dataCity];
        [self.dataSource addObject:dataProvince];
    }
}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            NSLog(@"%@",self.currentCity);
            if (!self.currentCity) {
                self.currentCity = NSLocalizedString(@"home_cannot_locate_city", comment:@"无法定位当前城市");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
//                NSString *title = @"定位到的城市";
//                NSArray  *array = [NSArray arrayWithObject:self.currentCity];
//                NSMutableArray *city = [NSMutableArray array];
//                [city addObject:title];
//                [city addObject:array];
//                [self.dataSource insertObject:city atIndex:0];
//                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            });
        }else if(error == nil && placemarks.count == 0){
            NSLog(@"No location and error returned");
        }else if(error){
            NSLog(@"Location error: %@", error);
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


#pragma mark -
#pragma mark - UITableViewDataSource

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return @[@"L", @"京", @"津", @"沪", @"冀", @"豫", @"皖", @"浙", @"渝", @"闽", @"甘", @"粤", @"桂", @"黔", @"滇", @"蒙", @"赣", @"鄂", @"蜀", @"宁", @"青", @"鲁", @"陕", @"晋", @"新", @"藏", @"台",@"琼",@"湘",@"苏",@"黑",@"吉",@"辽"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    NSArray *cityArr = [[self.dataSource objectAtIndex:section] objectAtIndex:1];
    return cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cellId"];
    }
    if (indexPath.section == 0) {
        if (self.currentCity.length == 0) {
            cell.textLabel.text = @"未定位到城市";
        }else{
            cell.textLabel.text = self.currentCity;
        }
        return cell;
    }else{
        NSArray *cityArr = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:1];
        cell.textLabel.text = [cityArr objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *province = [[self.dataSource objectAtIndex:section] objectAtIndex:0];
    return province;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cityName = nil;
    NSArray  *cityArr  = [[NSArray alloc] init];
    if (indexPath.section == 0) {
        NSMutableString *cityStr = [NSMutableString stringWithString:_currentCity];
        if (cityStr.length == 0) {
            return;
        }
        NSUInteger len = cityStr.length;
        [cityStr deleteCharactersInRange:NSMakeRange(len - 1, 1)];
        cityName = cityStr;
        NSLog(@"%@",cityName);
        
        if ([self.delegate respondsToSelector:@selector(returnCityName:and:)]) {
            [self.delegate returnCityName:cityName and:cityName];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        cityArr  = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:1];
        cityName = [cityArr objectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(returnCityName:and:)]) {
            [self.delegate returnCityName:cityName and:cityArr[0]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [_locationManager stopUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
