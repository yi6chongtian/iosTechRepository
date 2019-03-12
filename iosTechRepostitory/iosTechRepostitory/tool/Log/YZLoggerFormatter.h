//
// Created by chengang on 2018/7/3.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDLog.h>
#import "YZLoggerModule.h"

@interface YZLoggerFormatter : NSObject <DDLogFormatter>

@property(nonatomic, strong) NSString *module;

- (void)addToWhitelist:(YZLOG_MODULE_TYPE)type;
- (void)addToBlacklist:(YZLOG_MODULE_TYPE)type;

@end
