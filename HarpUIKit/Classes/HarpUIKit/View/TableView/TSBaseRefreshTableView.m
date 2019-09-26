//
//  TSBaseRefreshTableView.m
//  TSUIKit
//
//  Created by three stone 王 on 2018/7/23.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

#import "TSBaseRefreshTableView.h"

@implementation TSBaseRefreshTableView

- (void)commitInit {
    [super commitInit];
    
    self.bounces = true;
    
    //下拉刷新
    
    MJRefreshNormalHeader *head = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onHeaderRefresh)];
    
    self.mj_header = head;
    
    //自动更改透明度
    self.mj_header.automaticallyChangeAlpha = YES;
    
    head.lastUpdatedTimeLabel.hidden = true;
    
//    [self.mj_header setValue:@(true) forKey:@"lastUpdatedTimeLabel.hidden"];
    
    //进入刷新状态
//    [head beginRefreshing];
    
    //上拉刷新
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRefresh)];
    
}
- (void)onHeaderRefresh {
    
    id<TSBaseRefreshTableViewDelegate> mDelegate = (id<TSBaseRefreshTableViewDelegate>)self.mDelegate;
    
    if (mDelegate && [mDelegate respondsToSelector:@selector(onHeaderRefresh)]) {
        
        [mDelegate onHeaderRefresh];
    }
}
- (void)onFooterRefresh {
    
    id<TSBaseRefreshTableViewDelegate> mDelegate = (id<TSBaseRefreshTableViewDelegate>)self.mDelegate;
    
    if (mDelegate && [mDelegate respondsToSelector:@selector(onFooterRefresh)]) {
        
        [mDelegate onFooterRefresh];
    }
}
@end
