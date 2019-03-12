//
//  UIColor.h
//  july
//
//  Created by laihj on 2018/7/24.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGB(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]

@interface UIColor(Hex)

+ (UIColor *) lighgGreen;
+ (UIColor *) darkGreen;
+ (UIColor *) darkGray;

+ (UIColor *) yzProHigh;
+ (UIColor *) yzProMidium;
+ (UIColor *) yzProLow;

+ (UIColor *)colorWithHex:(NSString *)hexstring andAlpha:(CGFloat)alpha;

@end
