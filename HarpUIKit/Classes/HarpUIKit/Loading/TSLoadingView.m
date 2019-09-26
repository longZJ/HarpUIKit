//
//  TSLoadingView.m
//  TSUIKit
//
//  Created by three stone 王 on 2018/7/10.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

#import "TSLoadingView.h"
#import <objc/runtime.h>

@interface LoadingImageBean: NSObject

@property (nonatomic ,copy) NSString *Loading_Image;

@end

@implementation LoadingImageBean

+ (LoadingImageBean *)instance {
    
    LoadingImageBean *image = [LoadingImageBean new];
    
    NSDictionary *json = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UMConfig" ofType:@"plist"]];
    
    image.Loading_Image = json[@"Loading_Image"];
    
    return image;
}

@end

@interface TSLoadingView()
{
    UIActivityIndicatorView *_activity;
    
    UIButton *_backgroundItem;
    
    UIImageView *_iconImageView;
    
    UILabel *_reloadLabel;
    
    NSString *_text;
    
    NSString *_logo;
}

@property (nonatomic ,strong) TSBaseViewController *contentViewController;

@property (nonatomic ,assign ,readwrite) BOOL isLoading;

@end
@implementation TSLoadingView

+ (instancetype)loadingWithContentViewController:(TSBaseViewController *)contentViewController {
    
    return [[TSLoadingView alloc] initWithContentViewController:contentViewController];
}

- (instancetype)initWithContentViewController:(TSBaseViewController *)contentViewController {
    
    if (self = [super init]) {
        
        self.contentViewController = contentViewController;
        
        self.backgroundColor = [UIColor colorWithRed: 240 / 255.0f green:240 / 255.0f blue:240 / 255.0f alpha:1];
        
        _reloadLabel = [[UILabel alloc] init];
        
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        
        LoadingImageBean *l = [LoadingImageBean instance];
        
        _iconImageView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:l.Loading_Image]];
        
        _backgroundItem = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backgroundItem addTarget:self action:@selector(onReloadItemClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setURLCannotOpenforText:(NSString *)text andLogo:(NSString *)logo {
    
    _reloadLabel.text = text;
    
    _iconImageView.image = [UIImage imageNamed:logo];
}

- (void)setDataEmptyforText:(NSString *)text andLogo:(NSString *)logo {
    
    _reloadLabel.text = text;
    
    _iconImageView.image = [UIImage imageNamed:logo];
}

- (void)setStatus:(LoadingStatus)status {
    _status = status;
    
    [self changeLoadingStatus:status];
}
- (void)changeLoadingStatus:(LoadingStatus)status {
    
    switch (status) {
        case LoadingStatusBegin:
            
        {
            [self prepareSubviews];
            
        }
            break;
        case LoadingStatusWebViewLoading:
        {
            CGRect frame = self.frame;
            
            self.frame = CGRectMake(0, 2, frame.size.width, frame.size.height);
        }
            break;
        case LoadingStatusSucc:
        {
            
            [self onSucc];
        }
            break;
        case LoadingStatusLoading:
        {
            
            [self onLoading];
        }
            break;
        case LoadingStatusFail:
        {
            
            [self onFail];
        }
            break;
        case LoadingStatusURLCannotOpen:
        {
            
            [self onURLNotOpen];
        }
            break;
        case LoadingStatusDataEmpty:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)prepareSubviews {
    
    CGFloat w = CGRectGetWidth(self.contentViewController.view.bounds);
    
    CGFloat h = CGRectGetHeight(self.contentViewController.view.bounds);
    
    CGRect frame = self.contentViewController.view.bounds;
    
    self.frame = frame;
    
    [self.contentViewController.view bringSubviewToFront:self];
    
    _backgroundItem.frame = self.bounds;
    
    _backgroundItem.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_backgroundItem];
    
    [self addSubview:_activity];
    
    _activity.center = CGPointMake(w / 2, (h - 64) / 2);
    
    [self addSubview:_iconImageView];
    
    _iconImageView.frame = CGRectMake(0, 0, 100, 100);
    
    _iconImageView.center = CGPointMake(w / 2, (h - 64) / 2 - 100);
    
    _reloadLabel.frame = CGRectMake(0, (h - 64) / 2, w, 40);
    
    _reloadLabel.text = @"点击屏幕 重新加载";
    
    _reloadLabel.textColor = [UIColor colorWithRed: 0x66 / 255.0f green:0x66 / 255.0f blue:0x66 / 255.0f alpha:1];
    
    _reloadLabel.font = [UIFont systemFontOfSize:20];
    
    _reloadLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_reloadLabel];
}
- (void)onReloadItemClick {
    
    [self onReload];
    
    if (_mDelegate && [_mDelegate respondsToSelector:@selector(onReloadItemClick)]) {
        
        [_mDelegate onReloadItemClick];
    }
}
- (void)onLoading {
    
    if (!_activity.isAnimating) {
        
        [_activity startAnimating];
    }
    
    _activity.hidden = false;
    
    _reloadLabel.hidden = true;
    
    _backgroundItem.hidden = true;
    
}
- (void)onSucc {
    
    if (!_activity.isAnimating) {
        
        [_activity stopAnimating];
    }
    
    [self removeFromSuperview];
}

- (void)onFail {
    
    if (!_activity.isAnimating) {
        
        [_activity stopAnimating];
    }
    
    _activity.hidden = true;
    
    _reloadLabel.hidden = false;
    
    _backgroundItem.hidden = false;
    
    _reloadLabel.text = @"点击屏幕 重新加载";
    
    _reloadLabel.textColor = [UIColor colorWithRed: 0x66 / 255.0f green:0x66 / 255.0f blue:0x66 / 255.0f alpha:1];
    
    _reloadLabel.font = [UIFont systemFontOfSize:20];
}

- (void)onURLNotOpen {
    
    if (!_activity.isAnimating) {
        
        [_activity stopAnimating];
    }
    
    _activity.hidden = true;
    
    _reloadLabel.hidden = false;
    
    _reloadLabel.text = _text;
    
    _reloadLabel.textColor = [UIColor colorWithRed: 0x66 / 255.0f green:0x66 / 255.0f blue:0x66 / 255.0f alpha:1];
    
    _reloadLabel.font = [UIFont systemFontOfSize:15];
}

- (void)onDataEmpty {
    
    if (!_activity.isAnimating) {
        
        [_activity stopAnimating];
    }
    
    _activity.hidden = true;
    
    _reloadLabel.hidden = false;
    
    _reloadLabel.text = _text;
    
    _reloadLabel.textColor = [UIColor colorWithRed: 0x66 / 255.0f green:0x66 / 255.0f blue:0x66 / 255.0f alpha:1];
    
    _reloadLabel.font = [UIFont systemFontOfSize:15];
}
- (void)onReload {
    
    [self onLoading];
}

@end
