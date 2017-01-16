
//  Created by LiuHongfeng on 3/11/15.
//  Copyright (c) 2015 TaobaoCaipiao. All rights reserved.

#import "MiniBrowser.h"

@implementation MiniBrowser

#define kHeight_toolBar 40
static void *KINContext = &KINContext;

- (id)initBrowserWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    if([super init])
    {
        _browserView  = [[UIView alloc] initWithFrame:frame];
        _browserView.backgroundColor = [UIColor lightGrayColor];
        [self loadWebViewWithFrame:frame configuration:configuration];
        [self loadToolBarWithBrowserFrame:frame];
        [self loadProgressView:frame];
    }
    return self;
}

- (void)loadWebViewWithFrame:(CGRect)frame  configuration:(WKWebViewConfiguration *)configuration
{
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height - kHeight_toolBar) configuration:configuration];
    [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.wkWebView setNavigationDelegate:self];
    [self.wkWebView setMultipleTouchEnabled:YES];
    [self.wkWebView setAutoresizesSubviews:NO];
    [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
    [self.wkWebView.scrollView setAlwaysBounceHorizontal:NO];
    self.wkWebView.scrollView.backgroundColor = [UIColor redColor];
    [_browserView addSubview:self.wkWebView];
    [self loadURLString:@"http://www.baidu.com/"];
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:KINContext];
}

- (void)loadToolBarWithBrowserFrame:(CGRect)frame
{
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_wkWebView.frame), frame.size.width, kHeight_toolBar)];
    _toolBar.tintColor = [UIColor blackColor];
    _toolBar.backgroundColor = [UIColor grayColor];
    [_browserView addSubview:_toolBar];
    //添加前进、后退、刷新按钮
    [self setupToolbarItems];
}

/** 设置工具栏的按钮
 * 设置工具按钮，刷新和停止在一个位置，默认设为刷新
 */
- (void)setupToolbarItems {
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopButtonPressed:)];
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forwardbutton"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardButtonPressed:)];
    self.fixedSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.fixedSeparator.width = 50.0f;
    self.flexibleSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (void)loadProgressView:(CGRect)frame
{
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor blueColor]];
    [self.progressView setFrame:CGRectMake(0, 0, frame.size.width, 2)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.browserView addSubview:self.progressView];
}

#pragma mark - public interface-
- (void)loadURL:(NSURL *)URL {
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        [self updateToolbarState];
    }
}

#pragma mark - Toolbar State
- (void)updateToolbarState {
    BOOL canGoBack = self.wkWebView.canGoBack;
    BOOL canGoForward = self.wkWebView.canGoForward;
    [self.backButton setEnabled:canGoBack];
    [self.forwardButton setEnabled:canGoForward];
    if(!self.backButton) {
        [self setupToolbarItems];
    }
    NSArray *barButtonItems;
    if(self.wkWebView.loading) {
        barButtonItems = @[self.backButton, self.fixedSeparator, self.forwardButton, self.fixedSeparator, self.stopButton, self.flexibleSeparator];
    }
    else {
        barButtonItems = @[self.backButton, self.fixedSeparator, self.forwardButton, self.fixedSeparator, self.refreshButton, self.flexibleSeparator];
    }
    [_toolBar setItems:barButtonItems animated:YES];
}


#pragma mark - UIBarButtonItem Target Action Methods

- (void)backButtonPressed:(id)sender {
        [self.wkWebView goBack];
    [self updateToolbarState];
}

- (void)forwardButtonPressed:(id)sender {
        [self.wkWebView goForward];
    [self updateToolbarState];
}

- (void)refreshButtonPressed:(id)sender {
        [self.wkWebView stopLoading];
        [self.wkWebView reload];
}

- (void)stopButtonPressed:(id)sender {
        [self.wkWebView stopLoading];
}

#pragma mark - Estimated Progress KVO (WKWebView)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
