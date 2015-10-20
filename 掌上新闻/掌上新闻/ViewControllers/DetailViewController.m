//
//  DetailViewController.m
//  网易新闻
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 XieRenQiang. All rights reserved.
//

#import "DetailViewController.h"
#import "UMSocial.h"

@interface DetailViewController ()<UIWebViewDelegate, UMSocialUIDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic) BOOL isCollect;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationBarItem];
    [self fetchData];
    
    [self createindicatorView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)fetchData{
    NSString *url = nil;
    if ([self.title isEqualToString:@"视频"]) {
        url = [NSString stringWithFormat:kvideo,self.dataModel.id];
    }else{
        url = [NSString stringWithFormat:kdetailUrl,self.dataModel.id];
    }
    
    [[NetDataEngine sharedInstance] requestNewsFrom:url success:^(id responsData) {
        NSDictionary *resultDic = responsData[@"result"];
        if ([self.type isEqualToString:@"视频"]) {
            self.webUrl = resultDic[@"v_url"];
        }else{
            self.webUrl = resultDic[@"art_url"];
        }
        [self createWebView];
    } failed:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
}
//懒加载
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        self.webView.scalesPageToFit   = YES;
        self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.webView.delegate = self;
    }
    return _webView;
}

- (void)createindicatorView{
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    _indicatorView.color = [UIColor blackColor];
    _indicatorView.center = CGPointMake(0.5 * SCREEN_W, 0.42 * SCREEN_H);
    [_indicatorView startAnimating];
   
    [self.view addSubview:self.indicatorView];
}

- (void)customNavigationBarItem{
    _isCollect = [[LimitDBManager sharedInstance] isNewInfoExists:self.dataModel type:COLLECT];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:nil] style:(UIBarButtonItemStylePlain) target:self action:@selector(collect:)];
    if (_isCollect) {
        collectItem.image = [UIImage imageNamed:@"iconfont-shoucang1.png"];
        collectItem.tintColor = [UIColor redColor];
    }else{
        collectItem.image = [UIImage imageNamed:@"iconfont-shoucang.png"];
        collectItem.tintColor = [UIColor grayColor];
    }
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconfont-fenxiang.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(share:)];
    shareItem.tintColor = [UIColor grayColor];
    
    self.navigationItem.rightBarButtonItems = @[collectItem,shareItem];
}

- (void)collect:(UIBarButtonItem *)item{
    _isCollect = !_isCollect;
    if (_isCollect) {
        [[LimitDBManager sharedInstance] addNewInfo:self.dataModel title:self.type type:COLLECT];
        item.image = [UIImage imageNamed:@"iconfont-shoucang1.png"];
        item.tintColor = [UIColor redColor];
    }else{
        [[LimitDBManager sharedInstance] deleteNewInfo:self.dataModel type:COLLECT];
        item.image = [UIImage imageNamed:@"iconfont-shoucang.png"];
        item.tintColor = [UIColor grayColor];
    }
}

- (void)share:(UIBarButtonItem *)item{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55f7c11be0f55a04cc0031e3"
                                      shareText:[NSString stringWithFormat:@"值得一看%@",self.webUrl]
                                     shareImage:[UIImage imageNamed:@"iconfont-shoucang1.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
}

- (void)createWebView{
    
    NSURL *url = [NSURL URLWithString:_webUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark -
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //删除头部广告
    NSMutableString *js = [NSMutableString string];
    [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
    [js appendString:@"header.parentNode.removeChild(header);"];
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    //删除中间广告
    NSMutableString *js1 = [NSMutableString string];
    [js1 appendString:@"var ad = document.getElementsByClassName('article-ad')[0];"];
    [js1 appendString:@"ad.parentNode.removeChild(ad);"];
    [webView stringByEvaluatingJavaScriptFromString:js1];
   
    NSMutableString *js0 = [NSMutableString string];
    [js0 appendString:@"var xm = document.getElementsByClassName('img-focus')[0];"];
    [js0 appendString:@"xm.parentNode.removeChild(xm);"];
    [webView stringByEvaluatingJavaScriptFromString:js0];
    
    //删除作者
     NSMutableString *js2 = [NSMutableString string];
    [js2 appendString:@"var user = document.getElementsByClassName('content-news-user-view')[0];"];
    [js2 appendString:@"user.parentNode.removeChild(user);"];
    [webView stringByEvaluatingJavaScriptFromString:js2];
    //删除分享评论
    NSMutableString *js3 = [NSMutableString string];
    [js3 appendString:@"var share = document.getElementsByClassName('news-share')[0];"];
    [js3 appendString:@"share.parentNode.removeChild(share);"];
    [webView stringByEvaluatingJavaScriptFromString:js3];
    
    //删除底部连接
    NSMutableString *js4 = [NSMutableString string];
    [js4 appendString:@"var footer = document.getElementsByTagName('footer')[0];"];
    [js4 appendString:@"footer.parentNode.removeChild(footer);"];
    [webView stringByEvaluatingJavaScriptFromString:js4];
    //删除底部浮动广告
    NSMutableString *js5 = [NSMutableString string];
    [js5 appendString:@"var js = document.getElementsByClassName('b-ad')[0];"];
    [js5 appendString:@"js.parentNode.removeChild(js);"];
    [webView stringByEvaluatingJavaScriptFromString:js5];
    [self.view addSubview:self.webView];
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";
    [self.view.layer addAnimation:transition forKey:nil];
    [self.indicatorView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*about:cehome
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
