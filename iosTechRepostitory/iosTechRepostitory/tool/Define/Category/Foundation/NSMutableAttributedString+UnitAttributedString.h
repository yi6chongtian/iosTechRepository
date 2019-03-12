//
//  NSMutableAttributedString+UnitAttributedString.h
//  YZFFServer
//
//  Created by Kelvin on 2018/10/4.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (UnitAttributedString)

+(NSMutableAttributedString *)head_attStringWithValue:(NSString *)value;

+(NSMutableAttributedString *)kg_attStringWithValue:(NSString *)value;

+(NSMutableAttributedString *)unitAttStringWithValue:(NSString *)value unit:(NSString *)unit;

+(NSMutableAttributedString *)attStringWithValue:(NSString *)value
                                      valueColor:(UIColor *)vColor
                                       valueFont:(UIFont *)vFont
                                            Unit:(NSString *)unit
                                       unitColor:(UIColor *)uColor
                                        unitFont:(UIFont *)uFont;


+ (NSMutableAttributedString *)yz_mutableAttributedStringWithAllString:(NSString *)allString
                                                      heighLightString:(NSString *)heighLightString
                                                       heighLightColor:(UIColor *)heighLightColor;

+ (NSMutableAttributedString *)yz_mutableAttributedStringWithAllString:(NSString *)allString
                                                      heighLightString:(NSString *)heighLightString
                                                       heighLightColor:(UIColor *)heighLightColor
                                                        heighLightFont:(UIFont *)heighLightFont;

//待完成，已完成的popview标题
+ (NSMutableAttributedString *)yz_popViewTitleWithString:(NSString *)realString
                                                 realNum:(NSString *)realNum
                                        needFinishString:(NSString *)needFinishString
                                           needFinishNum:(NSString *)needFinishNum
                                              unitString:(NSString *)unitString
                                          isNeedLineFeed:(BOOL)isNeedLineFeed;


/**
 设置扫一扫 左边的文字内容
 
 @param allString 所有字符
 @param heighLightString 高亮字符
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yz_getMutableAttributedStringWithAllString:(NSString *)allString
                                                         heighLightString:(NSString *)heighLightString;

@end

NS_ASSUME_NONNULL_END
