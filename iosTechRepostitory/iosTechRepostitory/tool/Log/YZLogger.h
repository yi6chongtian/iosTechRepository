//
// Created by chengang on 2018/7/2.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack.h>
#import "YZLoggerModule.h"

extern NSMutableDictionary *gYZLoggerModuleDics;
extern NSMutableDictionary *gYZLoggerTagDics;

#define YZ_LOG_MODULE_DEFINE(m)     do{\
        if (!gYZLoggerModuleDics) {\
            gYZLoggerModuleDics = [@{} mutableCopy];\
        }\
        gYZLoggerModuleDics[YZStr2NSStr(__FILE__)] = @(m);\
    }while(0)
#define YZ_LOG_TAG_DEFINE(t)        do{\
        if (!gYZLoggerTagDics) {\
            gYZLoggerTagDics = [@{} mutableCopy];\
        }\
        gYZLoggerTagDics[YZStr2NSStr(__FILE__)] = t;\
    }while(0)

#define YZ_LOG_MODULE   \
    (gYZLoggerModuleDics[YZStr2NSStr(__FILE__)]? \
    [gYZLoggerModuleDics[YZStr2NSStr(__FILE__)] integerValue]: \
    YZLOG_MODULE_TYPE_NONE)
#define YZ_LOG_TAG      \
    (gYZLoggerTagDics[YZStr2NSStr(__FILE__)])

/// Debug模式日志，Release模式不会写入日志文件
#define YZLog(frmt, ...)                YZLogModule       (YZ_LOG_MODULE, YZ_LOG_TAG, frmt, ##__VA_ARGS__)
/// Debug模式日志，自动打印函数信息，Release模式不会写入日志文件
#define YZLogF(frmt, ...)               YZLogModuleF      (YZ_LOG_MODULE, YZ_LOG_TAG, frmt, ##__VA_ARGS__)
/// 信息日志，Debug & Release模式写入日志文件
#define YZLogInfo(frmt, ...)            YZLogModuleInfo   (YZ_LOG_MODULE, YZ_LOG_TAG, frmt, ##__VA_ARGS__)
/// 信息日志，自动打印函数信息，Debug & Release模式写入日志文件
#define YZLogInfoF(frmt, ...)           YZLogModuleInfoF  (YZ_LOG_MODULE, YZ_LOG_TAG, frmt, ##__VA_ARGS__)
/// 错误日志，Debug & Release模式写入日志文件
#define YZLogErr(frmt, ...)             YZLogModuleErr    (YZ_LOG_MODULE, YZ_LOG_TAG, frmt, ##__VA_ARGS__)
/// 错误日志，自动打印函数信息Debug & Release模式写入日志文件
#define YZLogErrF(frmt, ...)            YZLogModuleErrF   (YZ_LOG_MODULE, YZ_LOG_TAG, frmt, ##__VA_ARGS__)

@interface YZLogger : NSObject
YZSingletonH()

/**
 * 函数方式的日志接口，主要是为了给JSPatch调用
 * @param flag
 * @param func
 * @param mod
 * @param tag
 * @param content 
 */
+ (void)logWithFlag:(DDLogFlag)flag
               func:(const char *)func
             module:(YZLOG_MODULE_TYPE)mod
                tag:(NSString *)tag
            content:(NSString *)content;

- (void)setup;
- (NSString *)getLatestLoggerContent;

@end
