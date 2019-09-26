//
//  TSInnerViewController.m
//  TSUIKit
//
//  Created by three stone 王 on 2018/7/10.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

#import "TSInnerViewController.h"
#import "TSColorCommon.h"
@interface TSInnerViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic ,strong ,readwrite) WKWebView *webView;

@property (nonatomic ,strong) UIProgressView *progressView;

@property (nonatomic ,strong) WKWebViewConfiguration *webConfig;

@end

@implementation TSInnerViewController

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *webConfig = [WKWebViewConfiguration new];
        
        NSString *js = @" $('meta[name=description]').remove(); $('head').append( '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1,user-scalable=no\">' );";
        
        WKUserContentController *userController = [WKUserContentController new];
        
        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [userController addUserScript:script];
        [userController addScriptMessageHandler:self name:@"openInfo"];
        webConfig.userContentController = userController;
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:webConfig];
    }
    return _webView;
}
- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc]init];
        
        _progressView.trackTintColor = SEPERATOR_COLOR;
        
        _progressView.progressTintColor = TAB_SELECT_COLOR;
        
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loadingStatus = LoadingStatusWebViewLoading;
}
- (void)addOwnSubviews {
    [super addOwnSubviews];
    
    [self.view addSubview:self.webView];
    
    [self.view addSubview:self.progressView];
}
- (void)configOwnSubviews {
    
    self.webView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64);
    
    self.webView.navigationDelegate = self;
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:(NSKeyValueObservingOptionNew) context:nil];
    
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    
    self.progressView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 2);
}
- (void)loadReq:(NSString *)url {
    
    NSURL *reqUrl = [NSURL URLWithString:url];
    
    if ([[UIApplication sharedApplication] canOpenURL:reqUrl]) {
        
        NSURLRequest *req = [NSURLRequest requestWithURL:reqUrl];
        
        [self.webView loadRequest:req];
    } else {
        
        
        
    }
}
- (void)loadHtml:(NSString *)html {
    
    [self.webView loadHTMLString:html baseURL:nil];
}
- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    self.progressView.hidden = false;
    
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    
    [self.view bringSubviewToFront:self.progressView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    self.progressView.hidden = true;
    
    self.loadingStatus = LoadingStatusSucc;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    self.progressView.hidden = true;
    
    self.loadingStatus = LoadingStatusFail;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
        
        if (self.progressView.progress == 1) {
            
            __weak typeof(self) weakSelf = self;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
                
            } completion:^(BOOL finished) {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                strongSelf.progressView.hidden = true;
            }];
        }
    } else if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
        
        if (![self.webView isLoading]) {
            
            self.webView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64);
            
            [self.webView sizeToFit];
        }
    }
}

// 本来可以不实现 可是在验证podspec的时候报警告
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}


@end
