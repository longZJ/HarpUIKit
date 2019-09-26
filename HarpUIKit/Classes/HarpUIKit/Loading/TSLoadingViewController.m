//
//  TSLoadingViewController.m
//  TSUIKit
//
//  Created by three stone 王 on 2018/7/10.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

#import "TSLoadingViewController.h"

@interface TSLoadingViewController () <TSLoadingViewDelegate >
{
    
    
}
@property (nonatomic ,strong ,readwrite) TSLoadingView *loadingView;
@end

@implementation TSLoadingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.loadingStatus = LoadingStatusBegin;

    self.loadingStatus = LoadingStatusLoading;
}

- (TSLoadingView *)loadingView {
    
    if (!_loadingView) {
        
        _loadingView = [TSLoadingView loadingWithContentViewController:self];
        
        _loadingView.mDelegate = self;
    }
    return _loadingView;
}

- (void)addOwnSubviews {
    
    [self.view addSubview:self.loadingView];
}

- (void)setLoadingStatus:(LoadingStatus)loadingStatus {
    _loadingStatus = loadingStatus;
    
    [self.loadingView changeLoadingStatus:loadingStatus];
    
}
- (void)onReloadItemClick {
    
    [self prepareData];
}

- (void)setURLCannotOpenforText:(NSString *)text andLogo:(NSString *)logo {
    
    [self.loadingView setURLCannotOpenforText:text andLogo:logo];
}

- (void)setDataEmptyforText:(NSString *)text andLogo:(NSString *)logo {
    
    [self.loadingView setDataEmptyforText:text andLogo:logo];
}
@end
