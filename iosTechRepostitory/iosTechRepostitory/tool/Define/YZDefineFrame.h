//
//  YZDefineFrame.h
//  july
//
//  Created by 孙博岩 on 2018/8/8.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#ifndef YZDefineFrame_h
#define YZDefineFrame_h

/*!
 *  获取屏幕宽度和高度
 */
#define YZScreenWidth ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [UIApplication sharedApplication].keyWindow.bounds.size.width : [UIApplication sharedApplication].keyWindow.bounds.size.height)

#define YZScreenHeight ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [UIApplication sharedApplication].keyWindow.bounds.size.height : [UIApplication sharedApplication].keyWindow.bounds.size.width)

#define YZScreenMax MAX(YZScreenWidth, YZScreenHeight)
#define YZScreenMin MIN(YZScreenWidth, YZScreenHeight)

/**
 *  iPhone4 or iPhone4s
 */
#define  YZiPhone4_4s     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320.f, 480.f), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  iPhone5 or iPhone5s
 */
#define  YZiPhone5_5s     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320.f, 568.f), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  iPhone6 or iPhone6s
 */
#define  YZiPhone6_6s    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.f, 1334.f), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  iPhone6Plus or iPhone6sPlus
 */
#define  YZiPhone6_6sPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.f, 2208.f), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断是否是iPhone X
#define  YZiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define  YZiPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define  YZiPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define  YZiPhoneXS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define IsStraightBangs (YZiPhoneX || YZiPhoneXR || YZiPhoneXS || YZiPhoneXS_MAX)

#define YZIsiPhone ([(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPhone"])

#define kScaleFit (YZIsiPhone ? ((YZScreenWidth < YZScreenHeight) ? YZScreenWidth / 375.0f : YZScreenWidth / 667.0f) : 1.1f)

/**
 *  Tabbar height.
 */
#define YZTabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 83 : 49)

/**
 *  Status bar height.
 */
#define YZStatusBarHeight                   [[UIApplication sharedApplication] statusBarFrame].size.height

/**
 *  Navigation bar height.
 */
#define YZNavigationBarHeight               (IsStraightBangs? 88: 44)

/**
 *  Status bar & navigation bar height.
 */
#define  YZStatusBarAndNavigationBarHeight  (BAKit_StatusBarHeight + BAKit_NavigationBarHeight)
/**
 *  Wide screen iPhone. 6(s)+,7(s)+,8(s)+,xr,xsmax
 */
#define  YZIsWideScreenIphone         ([[UIScreen mainScreen] bounds].size.height == 414)

#endif /* YZDefineFrame_h */
