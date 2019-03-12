//
// Created by chengang on 2018/6/21.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import "UIScrollView+YZRefresh.h"

#import "MJRefreshLottieHeader.h"
#import "MJRefreshLottieFooter.h"


@implementation UIScrollView (YZRefresh)

- (void)addHeaderRefresh:(void (^)(void))cb {
    self.bounces = YES;
    if (!self.mj_header) {
        self.mj_header = [MJRefreshLottieHeader headerWithRefreshingBlock:cb];
//        ((MJRefreshNormalHeader*)(self.mj_header)).lastUpdatedTimeLabel.hidden = YES;
//        ((MJRefreshNormalHeader*)(self.mj_header)).stateLabel.hidden = YES;
    }
}

- (void)addFooterRefresh:(void (^)(void))cb {
    self.bounces = YES;
    if (!self.mj_footer) {
        self.mj_footer = [MJRefreshLottieFooter footerWithRefreshingBlock:cb];
//        ((MJRefreshBackNormalFooter*)(self.mj_footer)).stateLabel.hidden = YES;

        [((MJRefreshLottieFooter*)(self.mj_footer)) setTitle:@"" forState:MJRefreshStateIdle];
        [((MJRefreshLottieFooter*)(self.mj_footer)) setTitle:@"" forState:MJRefreshStatePulling];
        [((MJRefreshLottieFooter*)(self.mj_footer)) setTitle:@"" forState:MJRefreshStateRefreshing];
        [((MJRefreshLottieFooter*)(self.mj_footer)) setTitle:@"" forState:MJRefreshStateWillRefresh];
        [((MJRefreshLottieFooter*)(self.mj_footer)) setTitle:@"已加载全部" forState:MJRefreshStateNoMoreData];
    }
}

- (void)removeHeaderRefresh {
    [self.mj_header removeFromSuperview];
    self.mj_header = nil;
}

- (void)removeFooterRefresh {
    [self.mj_footer removeFromSuperview];
    self.mj_footer = nil;
}

- (void)beginRefreshWithHeader {
    if (!self.mj_header.isRefreshing) {
        [self.mj_header beginRefreshing];
    }
}

- (void)beginRefreshWithFooter {
    if (!self.mj_footer.isRefreshing) {
        [self.mj_footer beginRefreshing];
    }
}

- (void)endRefreshWithNoMoreData:(bool)noMoreData {
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
    if (noMoreData) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endRefresh {
    [self endRefreshWithNoMoreData:NO];
}

- (void)endRefreshWithNoMoreData {
    [self endRefreshWithNoMoreData:YES];
}

- (void)resetFooterRefreshState {
    [self.mj_footer endRefreshing];
}

@end
