//
//  UIFont+KWSFontKit.m
//  Laika
//
//  Created by Kelvin Tong on 16/8/24.
//  Copyright © 2016年 sponialtd. All rights reserved.
//

#import "UIFont+KWSFontKit.h"

@implementation UIFont (KWSFontKit)
+(UIFont *)themeCNFontWithSize:(CGFloat)size
{
    return [self themeCNFontWithSize:size bold:NO];
}

+(UIFont *)themeCNFontWithSize:(CGFloat)size bold:(BOOL)bold
{
    UIFont *retFont = nil;
    if (bold)
    {
        retFont = [self PingFangSC_SemiboldWithSize:size];
    }
    else
    {
        retFont = [UIFont PingFangSC_RegularWithSize:size];
    }
    if (retFont == nil) {
        retFont = bold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size];
    }
    return retFont;
}

//+(UIFont *)themeENFontWithSize:(CGFloat)size
//{
//    return [self themeENFontWithSize:size bold:NO];
//}

//+(UIFont *)themeENFontWithSize:(CGFloat)size bold:(BOOL)bold
//{
//    if (bold)
//    {
//        return [self titilliumWeb_BoldWithSize:size];
//    }
//    else
//    {
//        return [UIFont titilliumWeb_RegularWithSize:size];
//    }
//}

+(UIFont *)PingFangSCWithWeight:(KWSFontWeight)weight size:(CGFloat)size {
    UIFont *retFont = nil;
    switch (weight) {
        case KWSFontWeightThin:
            retFont = [self PingFangSC_ThinWithSize:size];
            break;
        case KWSFontWeightRegular:
            retFont = [self PingFangSC_RegularWithSize:size];
            break;
        case KWSFontWeightLight:
            retFont = [self PingFangSC_LightWithSize:size];
            break;
        case KWSFontWeightMedium:
            retFont = [self PingFangSC_MediumWithSize:size];
            break;
        case KWSFontWeightSemibold:
            retFont = [self PingFangSC_SemiboldWithSize:size];
            break;
    }
    if (retFont == nil) {
        retFont = [UIFont systemFontOfSize:size];
    }
    return retFont;
}

+(UIFont *)PingFangSC_ThinWithSize:(CGFloat)size
{
    UIFont *retFont = [UIFont fontWithName:@"PingFangSC-Thin" size:size];
    if (!retFont) {
        return [UIFont systemFontOfSize:size];
    }else{
        return retFont;
    }
}

+(UIFont *)PingFangSC_LightWithSize:(CGFloat)size
{
    UIFont *retFont = [UIFont fontWithName:@"PingFangSC-Light" size:size];
    if (!retFont) {
        return [UIFont systemFontOfSize:size];
    }else{
        return retFont;
    }
}

+(UIFont *)PingFangSC_RegularWithSize:(CGFloat)size
{
    UIFont *retFont = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    if (!retFont) {
        return [UIFont systemFontOfSize:size];
    }else{
        return retFont;
    }
}

+(UIFont *)PingFangSC_MediumWithSize:(CGFloat)size
{
    UIFont *retFont = [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    if (!retFont) {
        return [UIFont systemFontOfSize:size];
    }else{
        return retFont;
    }
}

+(UIFont *)PingFangSC_SemiboldWithSize:(CGFloat)size
{
    UIFont *retFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    if (!retFont) {
        return [UIFont systemFontOfSize:size];
    }else{
        return retFont;
    }
}

+(UIFont *)AppleSDGothicNeo_Regular:(CGFloat)size
{
    UIFont *retFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:size];
    if (!retFont) {
        return [UIFont systemFontOfSize:size];
    }else{
        return retFont;
    }
}

@end
