//
// Created by chengang on 2018/8/16.
// Copyright (c) 2018 laihj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  这是一个会覆盖其他HUD的HUD，且不会自动释放
 *  只有一些不希望被其他HUD干扰 且 必须显示的警告，才可以使用这个类
 *  请不要滥用，会干扰项目正常的HUD流程
 */
@interface YZOverlayHUD : UIView

- (void)showWithStatus:(nullable NSString*)status;
- (void)setStatus:(nullable NSString*)status; // change the HUD loading status while it's showing
// stops the activity indicator, shows a glyph + status, and dismisses the HUD a little bit later
- (void)showInfoWithStatus:(nullable NSString*)status;
- (void)showSuccessWithStatus:(nullable NSString*)status;
- (void)showErrorWithStatus:(nullable NSString*)status;

@end