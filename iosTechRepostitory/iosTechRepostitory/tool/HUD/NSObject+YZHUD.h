//
//  NSObject+YZHUD.h
//  yingzi_ios_farmmgr
//
//  Created by Kelvin on 2018/7/6.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YZHUD)


/**
 HUD，当前View显示在主屏幕上才会显示相关HUD
 */

- (void)hud_showLoadingView;
- (void)hud_showLoadingViewOnViewOnView:(UIView *)view;
- (void)hud_showLoadingViewWithStatus:(NSString *)status;
- (void)hud_showLoadingViewWithStatus:(NSString *)status onView:(UIView *)view;
- (void)hud_showImage:(nonnull UIImage*)image status:(nullable NSString*)status onView:(UIView *)view;
- (void) hud_showDeveloping;

/**
 成功 提示
 
 @param msg 提示的内容
 @return hud 持续的时间
 */
- (NSTimeInterval)hud_showSuccessMsg:(NSString *)msg;

/**
 错误 提示
 
 @param msg 提示的内容
 @return hud 持续的时间
 */
- (NSTimeInterval)hud_showErrorMsg:(NSString *)msg;

/**
 toast 提示

 @param status 提示的内容
 @return toast 持续的时间
 */
- (NSTimeInterval)hud_toastStatus:(NSString *)status;

- (NSTimeInterval)hud_toastStatus:(NSString *)status onView:(UIView *)view;

- (void)hud_dismiss;
- (void)hud_dismissDelayOneSecond;
- (void)hud_dismissDelay:(NSTimeInterval)timeInterval;
-(void)hud_dismissDelay:(NSTimeInterval)timeInterval completion:(void (^)(void))completion;
@end
