//
//  MiniBrowserView.h
//  H5VSNativeTest
//
//  Created by LiuHongfeng on 3/11/15.
//  Copyright (c) 2015 TaobaoCaipiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MiniBrowser : NSObject <WKNavigationDelegate>

@property (nonatomic,strong) UIView *browserView;//浏览器view，放置网页view和toolBarView
@property (nonatomic,strong) WKWebView *wkWebView;//显示网页的webView
@property (nonatomic,strong) UIToolbar *toolBar;//放置浏览器基本控制按钮的bar。包含：前进、后退、刷新（停止加载） 三个按钮
@property (nonatomic, strong) UIBarButtonItem *backButton, *forwardButton, *refreshButton, *stopButton, *fixedSeparator, *flexibleSeparator;
@property (nonatomic, strong) UIProgressView *progressView;//进度条

- (id)initBrowserWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration;

@end
