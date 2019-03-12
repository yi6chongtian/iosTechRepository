//
//  UIFont+KWSFontKit.h
//  Laika
//
//  Created by Kelvin Tong on 16/8/24.
//  Copyright © 2016年 sponialtd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KWSFontWeight) {
    KWSFontWeightThin = 0,
    KWSFontWeightRegular = 1,
    KWSFontWeightLight = 2,
    KWSFontWeightMedium = 3,
    KWSFontWeightSemibold = 4
};
@interface UIFont (KWSFontKit)
+(UIFont *)themeCNFontWithSize:(CGFloat)size bold:(BOOL)bold;
+(UIFont *)themeCNFontWithSize:(CGFloat)size;
//+(UIFont *)themeENFontWithSize:(CGFloat)size bold:(BOOL)bold;
//+(UIFont *)themeENFontWithSize:(CGFloat)size;
+(UIFont *)PingFangSCWithWeight:(KWSFontWeight)weight size:(CGFloat)size;
+(UIFont *)PingFangSC_ThinWithSize:(CGFloat)size;
+(UIFont *)PingFangSC_RegularWithSize:(CGFloat)size;
+(UIFont *)PingFangSC_LightWithSize:(CGFloat)size;
+(UIFont *)PingFangSC_MediumWithSize:(CGFloat)size;
+(UIFont *)PingFangSC_SemiboldWithSize:(CGFloat)size;

+(UIFont *)AppleSDGothicNeo_Regular:(CGFloat)size;
//#pragma mark - titilliumWeb font
////+(UIFont *)titilliumWeb_BlackWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_BoldWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_BoldItalicWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_ItalicWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_LightWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_LightItalicWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_RegularWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_SemiBoldWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_SemiBoldItalicWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_ThinWithSize:(CGFloat)size;
////+(UIFont *)titilliumWeb_ThinItalicWithSize:(CGFloat)size;

//+(CGFloat) smallFontSize;
//+(CGFloat) normalFontSize;
//+(CGFloat) largeFontSize;
//+(CGFloat) extraLaregeFontSize;
//+(CGFloat) ultraLargeFontSize;
@end
