//
// Created by chengang on 2018/6/12.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import "NSMutableDictionary+YZ.h"


@implementation NSMutableDictionary (YZ)

- (void)renameKey:(NSString *)oldKey forKey:(NSString *)newKey {
    [self setObject:[self objectForKey:oldKey] forKey:newKey];
    [self removeObjectForKey:oldKey];
}

@end