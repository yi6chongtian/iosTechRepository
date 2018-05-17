//
//  NSObject+YZDBModel.m
//  OC_Test
//
//  Created by tang on 2018/4/28.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "NSObject+YZDBModel.h"
#import <objc/runtime.h>
#import "YZFMDB.h"



#define AUTOINCREMENT @"AUTOINCREMENT"


@implementation NSObject (YZDBModel)

# pragma mark - 分类实现属性

#pragma mark - YZDBModelProtocol

+ (NSString *)tableName{
    return NSStringFromClass(self);
}

+ (NSArray *)excludeProList{
    return nil;
}

+ (NSDictionary *)primaryKeys {
//    return @{@"pkid":@"integer PRIMARY KEY AUTOINCREMENT"};
    return nil;
}
@end
