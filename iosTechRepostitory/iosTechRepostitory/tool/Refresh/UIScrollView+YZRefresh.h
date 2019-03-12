//
// Created by chengang on 2018/6/21.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh.h>

@interface UIScrollView (YZRefresh)

- (void)addHeaderRefresh:(MJRefreshComponentRefreshingBlock)cb;
- (void)addFooterRefresh:(MJRefreshComponentRefreshingBlock)cb;

- (void)removeHeaderRefresh;
- (void)removeFooterRefresh;

- (void)beginRefreshWithHeader;
- (void)beginRefreshWithFooter;

- (void)endRefresh;
- (void)endRefreshWithNoMoreData;
- (void)resetFooterRefreshState;

@end
