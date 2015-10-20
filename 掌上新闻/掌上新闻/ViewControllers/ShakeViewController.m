//
//  ShakeViewController.m
//  掌上新闻
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "ShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ShakeViewController ()

@property (nonatomic) UIImageView *upView;
@property (nonatomic) UIImageView *downView;
@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摇一摇看新闻";
    self.view.backgroundColor = [UIColor whiteColor];
    [self customUI];
}

- (void)customUI{
    _upView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, (SCREEN_H - 64) / 2)];
    _upView.image = [UIImage imageNamed:@"shake_up.png"];
    
    _downView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SCREEN_H - 64) / 2, SCREEN_W, (SCREEN_H - 64) / 2)];
    _downView.image = [UIImage imageNamed:@"shake_down.png"];
    [self.view addSubview:_upView];
    [self.view addSubview:_downView];
}

- (void)doAnimation
{
    [UIView animateWithDuration:1 animations:^{
        _upView.transform = CGAffineTransformMakeTranslation(0, -100);
        _downView.transform = CGAffineTransformMakeTranslation(0, 100);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _upView.transform = CGAffineTransformIdentity;
            _downView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (BOOL)becomeFirstResponder{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"开始晃动");
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [self doAnimation];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"结束晃动");
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *rootVC = (UINavigationController *)window.rootViewController;
    UIViewController *rootVC1 = [rootVC.viewControllers firstObject];
    
    NSInteger number = rootVC1.childViewControllers.count;
    NSLog(@"%ld",number);
    NSInteger index = arc4random() % (number +1);
    UIScrollView *contentScrollView = [rootVC1.view.subviews firstObject];
    
    CGPoint offset = CGPointMake(index * SCREEN_W, 0);
    [contentScrollView setContentOffset:offset animated:YES];
//    [titleScrollView setContentOffset:offset animated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
