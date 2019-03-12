//
//  NSArray+ChineseInfo.m
//  PigFaceRecognize
//
//  Created by tang on 2018/5/7.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "NSArray+ChineseInfo.h"

@implementation NSArray (ChineseInfo)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    for (id obj in self) {
        [strM appendFormat:@"\t\t%@,\n", obj];
    }
    [strM appendString:@")"];
    return strM;
}

@end
