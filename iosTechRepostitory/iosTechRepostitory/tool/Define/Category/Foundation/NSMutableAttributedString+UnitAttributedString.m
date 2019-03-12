//
//  NSMutableAttributedString+UnitAttributedString.m
//  YZFFServer
//
//  Created by Kelvin on 2018/10/4.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import "NSMutableAttributedString+UnitAttributedString.h"
#import "UIFont+KWSFontKit.h"
#import "NSMutableAttributedString+BAKit.h"

@implementation NSMutableAttributedString (UnitAttributedString)

+(NSMutableAttributedString *)kg_attStringWithValue:(NSString *)value
{
    return [self.class unitAttStringWithValue:value unit:@" kg"];
}

+(NSMutableAttributedString *)head_attStringWithValue:(NSString *)value
{
    return [self.class unitAttStringWithValue:value unit:@" 头"];
}

+(NSMutableAttributedString *)unitAttStringWithValue:(NSString *)value unit:(NSString *)unit
{
    return [self.class attStringWithValue:value
                               valueColor:[UIColor whiteColor]
                                valueFont:[UIFont PingFangSC_SemiboldWithSize:24]
                                     Unit:[@" " stringByAppendingString:unit]
                                unitColor:BAKit_Color_RGB_pod(4, 219, 91)
                                 unitFont:[UIFont PingFangSC_MediumWithSize:12]];
}

+(NSMutableAttributedString *)attStringWithValue:(NSString *)value
                                      valueColor:(UIColor *)vColor
                                       valueFont:(UIFont *)vFont
                                            Unit:(NSString *)unit
                                       unitColor:(UIColor *)uColor
                                        unitFont:(UIFont *)uFont
{
    NSString *unionString = [value stringByAppendingString:unit];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:unionString];
    
    [aString addAttribute:NSKernAttributeName value:@(1.5) range:NSMakeRange(0, unionString.length)];
    [aString addAttributes:@{NSForegroundColorAttributeName:vColor,
                             NSFontAttributeName:vFont}
                     range:[unionString rangeOfString:value]];
    [aString addAttributes:@{NSForegroundColorAttributeName:uColor,
                             NSFontAttributeName:uFont,
                             NSBaselineOffsetAttributeName:@(5)
                             }
                     range:[unionString rangeOfString:unit]];
    return aString;
}

+ (NSMutableAttributedString *)yz_mutableAttributedStringWithAllString:(NSString *)allString
                                                      heighLightString:(NSString *)heighLightString
                                                       heighLightColor:(UIColor *)heighLightColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allString];

    [attributedString addAttributes:@{NSForegroundColorAttributeName:heighLightColor}
                     range:[allString rangeOfString:heighLightString]];
    
    return attributedString;
}

+ (NSMutableAttributedString *)yz_mutableAttributedStringWithAllString:(NSString *)allString
                                                      heighLightString:(NSString *)heighLightString
                                                       heighLightColor:(UIColor *)heighLightColor
                                                        heighLightFont:(UIFont *)heighLightFont
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allString];
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:heighLightColor, NSFontAttributeName:heighLightFont}
                              range:[allString rangeOfString:heighLightString]];

    return attributedString;
}

//待完成，已完成的popview标题
+ (NSMutableAttributedString *)yz_popViewTitleWithString:(NSString *)realString
                                                 realNum:(NSString *)realNum
                                        needFinishString:(NSString *)needFinishString
                                           needFinishNum:(NSString *)needFinishNum
                                              unitString:(NSString *)unitString
                                          isNeedLineFeed:(BOOL)isNeedLineFeed{
    
    NSString *titleOne = [NSString stringWithFormat:@"%@%@ %@",realString,realNum,unitString];
    NSString *titleTwo = YZIsEmpty(needFinishString) ? @"":[NSString stringWithFormat:@"%@%@ %@",needFinishString,needFinishNum,unitString];
    
    NSString *title = YZIsEmpty(needFinishString) ? titleOne:[NSString stringWithFormat:@"%@\n%@",titleOne,titleTwo];
    
    if (!isNeedLineFeed) {
        title = YZIsEmpty(needFinishString) ? titleOne:[NSString stringWithFormat:@"%@%@",titleOne,titleTwo];
    }
    
    NSRange rangeOne = [title rangeOfString:realNum];
    NSRange rangeTwo = [title rangeOfString:needFinishString];
    NSRange range = NSMakeRange(rangeTwo.location + needFinishString.length, needFinishNum.length);
    NSDictionary* attrDics =@{
                              NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold],//文本的颜色 字体 大小
                              NSForegroundColorAttributeName:[UIColor colorWithHex:@"00CE52" andAlpha:1.0],//文字颜色
                              };
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title];
    [attString addAttributes:attrDics range:rangeOne];
    [attString addAttributes:attrDics range:range];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];

    return attString;
}

/**
 设置扫一扫 左边的文字内容

 @param allString 所有字符
 @param heighLightString 高亮字符
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yz_getMutableAttributedStringWithAllString:(NSString *)allString
                                                         heighLightString:(NSString *)heighLightString
{
    NSMutableAttributedString *attributedStringTitle = [NSMutableAttributedString ba_mutableAttributedStringWithAllString:allString heighLightString:heighLightString heighLightColor:BAKit_Color_RGB_pod(23, 254, 126)];
    NSRange range = [allString rangeOfString:heighLightString];
    [attributedStringTitle ba_changeSystemFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] range:range];
    return attributedStringTitle;
}

@end
