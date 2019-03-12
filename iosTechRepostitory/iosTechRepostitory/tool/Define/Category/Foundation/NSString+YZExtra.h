//
//  NSString+YZExtra.h
//  yingzi-ios-survey
//
//  Created by Kelvin on 2018/8/4.
//  Copyright © 2018年 YZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YZExtra)
+ (BOOL)ba_regularIsMobileNumber:(NSString *)mobileNum;
+ (NSString *)yz_decimal:(CGFloat)decimal;
+ (NSString*)formatJsonPrint:(NSDictionary*)d;
- (NSString *)stringToMD5;
- (NSString *)sha1;
- (NSString *)hexString;
@end
