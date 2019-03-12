//
// Created by chengang on 2018/5/31.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import "UIViewController+YZ.h"


@implementation UIViewController (YZ)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YZObjcExchangeMethodAToB(@selector(viewDidLoad), @selector(aop_viewDidLoad));
    });
}

- (void)aop_viewDidLoad {
    [self aop_viewDidLoad];

    // NavigationBar无论是否透明，view都从Bar下沿开始对齐
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self isKindOfClass:UITableViewController.class]) {
        if (@available(iOS 11.0, *)) {
            ((UITableViewController *)self).tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

#pragma mark - 释放Controller

- (void)dismissViewControllerAnyway {

    [self dismissViewControllerAnywayAnimated:YES];
}

- (void)dismissViewControllerAnywayAnimated:(BOOL)animated{

    /*
    presentingViewController: controller that presented this view controller.(present当前控制器的控制器, 即父控制器)
    If neither the current view controller or any of its ancestors were presented modally, the value in this property is nil

    presentedViewController: controller that is presented by this view controller.(被当前控制器present的控制器, 即子控制器)
    If the current view controller did not present another view controller modally, the value in this property is nil.
    */

    BOOL isPushed = self.presentingViewController.presentedViewController == self.navigationController;
    BOOL isNavimainViewController = self == self.navigationController.viewControllers.firstObject;

    if ((self.presentingViewController && !isPushed)
            || (self.presentingViewController && (isPushed && isNavimainViewController))
            || self.presentedViewController) {

        // The presenting view controller is responsible for dismissing the view controller it presented. If you call this method on the presented view controller itself, UIKit asks the presenting view controller to handle the dismissal.
        // 具体参照文档..Discuss中有例子

        [self dismissViewControllerAnimated:animated completion:nil];
    }
    else if (self.navigationController){
        [self.navigationController popViewControllerAnimated:animated];
    }
    else {
        NSLog(@"没有找到父视图控制器");
    }

}

- (void)dismissViewControllerWithCompletedBlock:(void (^)())completedBlock {

    [self dismissViewControllerAnyway];
    dispatch_async(dispatch_get_main_queue(), ^{
        completedBlock();
    });
}

- (void)dismissMultipleModalViewWithCompletedBlock:(void (^)())completedBlock {

    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:completedBlock];
}

@end
