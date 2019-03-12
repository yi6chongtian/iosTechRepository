//
//  SVProgressHUD+YZExtra.h
//  yingzi_ios_farmmgr
//
//  Created by Kelvin on 2018/7/9.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import <SVProgressHUD.h>

@interface SVProgressHUD (YZExtra)
+ (NSTimeInterval)minimumDismissTimeInterval;
+ (NSTimeInterval)maximumDismissTimeInterval;

+ (void)yz_showLoadingView;
+ (void)yz_showLoadingViewWithStatus:(NSString *)status;
+ (void)yz_showLoadingViewWithContainerView:(UIView *)containerView status:(NSString *)status;
+ (void)yz_showSuccessMsg:(NSString *)msg;
+ (void)yz_showErrorMsg:(NSString *)msg;
+ (void)yz_toastStatus:(NSString *)status;
+ (void)yz_toastStatus:(NSString *)status onView:(UIView *)view;

+ (void)yz_dismiss;
+ (void)yz_dismissDelayOneSecond;
+ (void)yz_dismissDelay:(NSTimeInterval)delay;
+ (void)yz_dismissDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion;

+ (void)yz_showLoadingViewOnView:(UIView *)view;

+ (void)yz_showImage:(nonnull UIImage*)image status:(nullable NSString*)status onView:(UIView *)view;

@end
