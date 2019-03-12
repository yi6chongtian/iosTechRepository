//
// Created by chengang on 2018/5/31.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YZ)

/**
 *  释放当前ViewController, 返回上一级Controller, 无论是persent出来的或是push出来的, 都能安全释放掉~~
 */
- (void)dismissViewControllerAnywayAnimated:(BOOL)animated;
- (void)dismissViewControllerAnyway;
- (void)dismissViewControllerWithCompletedBlock:(void (^)())completedBlock;
- (void)dismissMultipleModalViewWithCompletedBlock:(void (^)())completedBlock;

@end
