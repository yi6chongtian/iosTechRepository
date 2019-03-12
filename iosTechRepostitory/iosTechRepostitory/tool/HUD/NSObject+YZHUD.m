//
//  NSObject+YZHUD.m
//  yingzi_ios_farmmgr
//
//  Created by Kelvin on 2018/7/6.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import "NSObject+YZHUD.h"
#import "UIView+YZ.h"
#import "SVProgressHUD+YZExtra.h"

@implementation NSObject (YZHUD)

-(void)hud_showLoadingView
{
    [SVProgressHUD yz_showLoadingView];
}

- (void)hud_showLoadingViewOnViewOnView:(UIView *)view
{
    [SVProgressHUD yz_showLoadingViewOnView:view];
}

-(void)hud_showLoadingViewWithStatus:(NSString *)status
{
    [SVProgressHUD yz_showLoadingViewWithStatus:status];
}

- (void)hud_showLoadingViewWithStatus:(NSString *)status onView:(UIView *)view
{
    [SVProgressHUD yz_showLoadingViewWithContainerView:view status:status];
}

- (void)hud_showImage:(nonnull UIImage*)image status:(nullable NSString*)status onView:(UIView *)view
{
    [SVProgressHUD yz_showImage:image status:status onView:view];
}

- (void) hud_showDeveloping {
    [SVProgressHUD yz_showImage:[YZServerBundle imageNamed:@"developing"] status:YZToastDeveloping   onView:nil];
}

-(NSTimeInterval)hud_showSuccessMsg:(NSString *)msg
{
    [self situationToPerform:^{
        [SVProgressHUD yz_showSuccessMsg:msg];
    }];
    
    return [[self class] dismissTimeIntervalFor:msg];
}

-(NSTimeInterval)hud_showErrorMsg:(NSString *)msg
{
    if (!msg || !msg.length ||
        [msg isEqualToString:@"success"] ||
        [msg isEqualToString:@"SUCCESS"]) {
        return 0;
    }
    [self situationToPerform:^{
        [SVProgressHUD yz_showErrorMsg:msg];
    }];
    
    return [[self class] dismissTimeIntervalFor:msg];
}

-(NSTimeInterval)hud_toastStatus:(NSString *)status
{
    return [self hud_toastStatus:status onView:nil];
}

- (NSTimeInterval)hud_toastStatus:(NSString *)status onView:(UIView *)view
{
    [self situationToPerform:^{
        [SVProgressHUD yz_toastStatus:status onView:view];
    }];
    
    return [[self class] dismissTimeIntervalFor:status];
}

-(void)hud_dismiss
{
    [SVProgressHUD yz_dismiss];
}

-(void)hud_dismissDelayOneSecond
{
    [SVProgressHUD yz_dismissDelayOneSecond];
}

-(void)hud_dismissDelay:(NSTimeInterval)timeInterval
{
    [SVProgressHUD yz_dismissDelay:timeInterval];
}

-(void)hud_dismissDelay:(NSTimeInterval)timeInterval completion:(void (^)(void))completion
{
    [SVProgressHUD yz_dismissDelay:timeInterval completion:completion];
}

#pragma mark - Private
-(void)situationToPerform:(dispatch_block_t) block
{
//    if ([self.class isKindOfClass:UIViewController.class] || [self.class isSubclassOfClass:UIViewController.class]) {
//        if ([[(UIViewController *)self view] isDisplayedInScreen]) {
//            block();
//        }
//    }
//    else if ([self.class isKindOfClass:UIView.class] || [self.class isSubclassOfClass:UIView.class]) {
//        if ([(UIView *)self isDisplayedInScreen]) {
//            block();
//        }
//    }else{
        block();
//    }
}

+(NSTimeInterval)dismissTimeIntervalFor:(NSString *)msg
{
    NSTimeInterval time = [SVProgressHUD displayDurationForString:msg];
    if (time < [SVProgressHUD minimumDismissTimeInterval]) {
        return [SVProgressHUD minimumDismissTimeInterval];
    }else if(time > [SVProgressHUD maximumDismissTimeInterval]){
        return [SVProgressHUD maximumDismissTimeInterval];
    }else{
        return time;
    }
}
@end
