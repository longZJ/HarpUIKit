//
//  TSBaseRefreshTableView.h
//  TSUIKit
//
//  Created by three stone 王 on 2018/7/23.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

#import "TSBaseTableView.h"
#import <MJRefresh/MJRefresh.h>
@protocol TSBaseRefreshTableViewDelegate <TSBaseTableViewDelegate>

- (void)onHeaderRefresh;

- (void)onFooterRefresh;
@end

@interface TSBaseRefreshTableView : TSBaseTableView

@end
