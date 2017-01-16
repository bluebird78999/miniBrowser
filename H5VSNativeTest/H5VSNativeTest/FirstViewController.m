//
//  FirstViewController.m
//  H5VSNativeTest
//
//  Created by LiuHongfeng on 3/10/15.
//  Copyright (c) 2015 TaobaoCaipiao. All rights reserved.
//

#import "FirstViewController.h"
#import "UIColor+FromRGB.h"
#import "MiniBrowser.h"

#define kWidht_button 35
#define kHeight_button 75
#define kPadding_compete1 15
#define kHeight_BrowserView 200

@interface FirstViewController ()
{
    UIWebView *_webViewTest;//测试用，方便查看UIWebView。
    UIImageView *_competeInfoView1;
    UIImageView *_competeInfoView2;
    UIButton *_showWebButton;
    MiniBrowser *_miniBrowser;
    BOOL _isWebShow;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isWebShow = NO;
    self.view.backgroundColor = [UIColor colorFromRGB:0xf5f5f5];
    _competeInfoView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footballpk"]];
    _competeInfoView1.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 339/2);
    _competeInfoView1.userInteractionEnabled = YES;
    _showWebButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _showWebButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - kWidht_button - 5, 90, kWidht_button, kHeight_button);
    [_showWebButton setBackgroundColor:[UIColor clearColor]];
    [_showWebButton addTarget:self action:@selector(showWebView:) forControlEvents:UIControlEventTouchUpInside];
    [_competeInfoView1 addSubview:_showWebButton];
    [self.view addSubview:_competeInfoView1];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.mediaPlaybackAllowsAirPlay = YES;
    _miniBrowser = [[MiniBrowser alloc] initBrowserWithFrame: CGRectMake(0, CGRectGetMaxY(_competeInfoView1.frame) + kPadding_compete1, CGRectGetWidth(self.view.bounds), kHeight_BrowserView) configuration:configuration];
    [self.view addSubview:_miniBrowser.browserView];
    
    _competeInfoView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footballpk2"]];
    _competeInfoView2.frame = CGRectMake(0, CGRectGetMaxY(_competeInfoView1.frame) + kPadding_compete1, CGRectGetWidth(self.view.bounds), 738/2);
    _competeInfoView2.userInteractionEnabled = YES;
    [self.view addSubview:_competeInfoView2];
}

#pragma mark --Actions--

- (void)showWebView:(id)sender
{
    _isWebShow = !_isWebShow;
    //将compete2 移动
    float moveDistance = kHeight_BrowserView;
    if (!_isWebShow) {
        moveDistance = -kHeight_BrowserView;
    }
    [UIView animateWithDuration:0.5 animations:^{
        _competeInfoView2.frame = CGRectMake(0, _competeInfoView2.frame.origin.y + moveDistance, _competeInfoView2.frame.size.width, _competeInfoView2.frame.size.height);
    }];
}

- (void)addMiniBrowser
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
