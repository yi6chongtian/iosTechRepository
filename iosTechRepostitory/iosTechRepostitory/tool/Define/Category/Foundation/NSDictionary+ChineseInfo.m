//
//  NSDictionary+ChineseInfo.m
//  PigFaceRecognize
//
//  Created by tang on 2018/5/7.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "NSDictionary+ChineseInfo.h"

@implementation NSDictionary (ChineseInfo)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *string=[[NSMutableString alloc]init ];
    [string appendString:@"{"];
    NSString* value=[NSString string];
    for (id obj in self.allKeys){
        value=[self objectForKey:obj];
        [string appendFormat:@"\n\t%@ = %@",obj,value];
    }
    [string appendString:@"\n}"];
    
    return string;
}

@end
