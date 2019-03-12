//
// Created by chengang on 2018/7/2.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDFileLogger.h>


@interface YZLoggerFileManager : DDLogFileManagerDefault

- (instancetype)initWithModule:(NSString *)module;
- (NSString *)readLatestLogContentOfSize:(NSUInteger)bytes;

@end
