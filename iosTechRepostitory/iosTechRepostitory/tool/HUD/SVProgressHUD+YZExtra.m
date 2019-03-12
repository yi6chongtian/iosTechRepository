//
//  SVProgressHUD+YZExtra.m
//  yingzi_ios_farmmgr
//
//  Created by Kelvin on 2018/7/9.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import "SVProgressHUD+YZExtra.h"
#import "NSObject+YZHUD.h"
#import "UIFont+KWSFontKit.h"
#import "UIColor+Hex.h"

#import "SVLottieView.h"
#import "YZCircleIndicatorView.h"

#define YZHUD_Delay 1.5F
#define cornerRadius 3.0

@interface SVProgressHUD ()

@property (nonatomic, strong) SVLottieView *lotView;

@end

static SVProgressHUDShowCompletion _c;
static CGFloat kMinimumDismissTimeInterval = 1.5;
static CGFloat kMaximumDismissTimeInterval = 3.0;

static const void * lot_name = @"lotView";

@implementation SVProgressHUD (YZExtra)

+(void)load{
    YZObjcExchangeMethodAToB(NSSelectorFromString(@"b_dismiss"), NSSelectorFromString(@"dismiss"));
    YZObjcExchangeMethodAToB(NSSelectorFromString(@"b_indefiniteAnimatedView"), NSSelectorFromString(@"indefiniteAnimatedView"));
}

#pragma mark - New Methods
+(NSTimeInterval)minimumDismissTimeInterval
{
    return kMinimumDismissTimeInterval;
}

+(NSTimeInterval)maximumDismissTimeInterval
{
    return kMaximumDismissTimeInterval;
}

+(void)hudAppearance
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wnonnull"
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setMinimumSize:CGSizeMake(40, 40)];
    [SVProgressHUD setCornerRadius:cornerRadius];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:@"000000" andAlpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithHex:@"FFFFFF" andAlpha:1.0]];
    [SVProgressHUD setFont:[UIFont PingFangSC_RegularWithSize:14.0]];
    [SVProgressHUD setMinimumDismissTimeInterval:kMinimumDismissTimeInterval];
    [SVProgressHUD setMaximumDismissTimeInterval:kMaximumDismissTimeInterval];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, 0)];
#pragma clang diagnostic pop
}

+(void)yz_showLoadingView
{
    [[self class] yz_showLoadingViewWithContainerView:nil];
}

+(void)yz_showLoadingViewOnView:(UIView *)view
{
    [self yz_showLoadingViewWithContainerView:view];
}

+(void)yz_showLoadingViewWithContainerView:(UIView *)containerView
{
    [[self class] hudAppearance];
    [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD setRingRadius:10.0];
    [SVProgressHUD setRingNoTextRadius:10.0];
    [SVProgressHUD show];
}

+(void)yz_showLoadingViewWithStatus:(NSString *)status
{
    [[self class] yz_showLoadingViewWithContainerView:nil status:status];
}

+(void)yz_showLoadingViewWithContainerView:(UIView *)containerView status:(NSString *)status
{
    if (!status || !status.length) {
        return;
    }
    [[self class] hudAppearance];
    [SVProgressHUD setContainerView:containerView];
    [SVProgressHUD setRingRadius:10.0];
    [SVProgressHUD setRingNoTextRadius:10.0];
    [SVProgressHUD showWithStatus:status];
}

+(void)yz_showErrorMsg:(NSString *)msg
{
    [[self class] yz_showErrorMsg:msg withContainerView:nil completion:nil];
}

+(void)yz_showErrorMsg:(NSString *)msg completion:(SVProgressHUDShowCompletion)completion
{
    [[self class] yz_showErrorMsg:msg withContainerView:nil completion:nil];
}

+(void)yz_showErrorMsg:(NSString *)msg withContainerView:(UIView *)cView completion:(SVProgressHUDShowCompletion)completion
{
    if (!msg || !msg.length) {
        return;
    }
    [[self class] hudAppearance];
    [SVProgressHUD setContainerView:cView];
    [SVProgressHUD showErrorWithStatus:msg];
    if (completion) {
        _c = completion;
    }else{
        _c = nil;
    }
}

+(void)yz_showSuccessMsg:(NSString *)msg
{
    [[self class] yz_showSuccessMsg:msg withContainerView:nil completion:nil];
}

+(void)yz_showSuccessMsg:(NSString *)msg completion:(SVProgressHUDShowCompletion)completion
{
    [[self class] yz_showSuccessMsg:msg withContainerView:nil completion:completion];
}

+ (void)yz_showImage:(nonnull UIImage*)image status:(nullable NSString*)status onView:(UIView *)view
{
    if (!image || !status || !status.length) {
        return;
    }

    [[self class] hudAppearance];
    [SVProgressHUD setContainerView:view];
    [SVProgressHUD setRingRadius:10.0];
    [SVProgressHUD setRingNoTextRadius:10.0];
    [SVProgressHUD showImage:image status:status];
}

+(void)yz_showSuccessMsg:(NSString *)msg withContainerView:(UIView *)cView completion:(SVProgressHUDShowCompletion)completion
{
    if (!msg || !msg.length) {
        return;
    }
    [[self class] hudAppearance];
    [SVProgressHUD setContainerView:cView];
    [SVProgressHUD showSuccessWithStatus:msg];
    if (completion) {
        _c = completion;
    }else{
        _c = nil;
    }
}

#pragma mark - toast
+(void)yz_toastStatus:(NSString *)status
{
    [[self class] yz_toastStatus:status withContainerView:nil completion:nil];
}

+ (void)yz_toastStatus:(NSString *)status onView:(UIView *)view
{
    [[self class] yz_toastStatus:status withContainerView:view completion:nil];
}

+(void)yz_toastStatus:(NSString *)status completion:(SVProgressHUDShowCompletion)completion
{
    [[self class] yz_toastStatus:status withContainerView:nil completion:completion];
}

+(void)yz_toastStatus:(NSString *)status withContainerView:(UIView *)cView completion:(SVProgressHUDShowCompletion)completion
{
    if (!status || !status.length) {
        return;
    }
    [[self class] hudAppearance];
    [SVProgressHUD setContainerView:cView];
    [SVProgressHUD showInfoWithStatus:status];
    if (completion) {
        _c = completion;
    }else{
        _c = nil;
    }
}

#pragma mark - dismiss
+ (void)yz_dismiss{
    [[self class] yz_dismissDelay:0];
}

+(void)yz_dismissDelayOneSecond
{
    [[self class] yz_dismissDelay:1.0];
}

+ (void)yz_dismissDelay:(NSTimeInterval)delay
{
    [[self class] yz_dismissDelay:delay completion:nil];
}

+ (void)yz_dismissDelay:(NSTimeInterval)delay completion:(SVProgressHUDDismissCompletion)completion
{
    [SVProgressHUD setContainerView:nil];
    [SVProgressHUD dismissWithDelay:delay completion:completion];
}

#pragma mark - Private Method
- (void)b_dismiss{
    [[self class] dismissWithDelay:0.0 completion:_c];
}

- (UIView*)b_indefiniteAnimatedView {

    if (!self.lotView) {
        self.lotView = [[SVLottieView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    }
    return self.lotView;
}

#pragma mark - getter / setter

- (void)setLotView:(SVLottieView *)lotView {
    
    objc_setAssociatedObject(self, lot_name, lotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SVLottieView *)lotView {
    
    return objc_getAssociatedObject(self, lot_name);
}

@end
