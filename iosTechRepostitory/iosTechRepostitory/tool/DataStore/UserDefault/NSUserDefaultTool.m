//
//  NSUserDefaultTool.m
//  iosTechRepostitory
//
//  Created by tang on 2018/4/12.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "NSUserDefaultTool.h"

@implementation NSUserDefaultTool

static NSUserDefaults *userDefault;

+ (void)load{
    userDefault = [NSUserDefaults standardUserDefaults];
}

+ (id)getObjectForkey:(NSString *)key{
    if(!key){
        return nil;
    }
    return [userDefault objectForKey:key];
}

+ (BOOL)setObject:(id)object forkey:(NSString *)key{
    if(!key){
        return NO;
    }
    [userDefault setObject:object forKey:key];
    return [userDefault synchronize];
}

+ (BOOL)deleteObjectWithKey:(NSString *)key{
    if(!key){
        return NO;
    }
    [userDefault removeObjectForKey:key];
    return [userDefault synchronize];
}

@end
