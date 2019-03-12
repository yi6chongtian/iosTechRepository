//
//  YZLoggerModule.h
//  yingzi_ios_farmmgr
//
//  Created by chengang on 2018/7/3.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#ifndef YZLoggerModule_h
#define YZLoggerModule_h

#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif


typedef NS_ENUM(NSUInteger, YZLOG_MODULE_TYPE) {
    YZLOG_MODULE_TYPE_NONE = 0,

    YZLOG_MODULE_TYPE_DEFAULT,
    YZLOG_MODULE_TYPE_NET,
    YZLOG_MODULE_TYPE_YX,
    YZLOG_MODULE_TYPE_IOT,
};

#define YZLogModuleTag(mod, flag, tag, frmt, ...) \
    LOG_MAYBE(YES, LOG_LEVEL_DEF, flag, mod?: YZLOG_MODULE_TYPE_DEFAULT, nil, __PRETTY_FUNCTION__, \
    tag? [[[@"[" stringByAppendingString:tag] stringByAppendingString:@"]"] stringByAppendingString:frmt]: frmt, ##__VA_ARGS__)
#define YZLogModule(mod, tag, frmt, ...)         YZLogModuleTag(mod, DDLogFlagDebug, tag, frmt, ##__VA_ARGS__)
#define YZLogModuleInfo(mod, tag, frmt, ...)     YZLogModuleTag(mod, DDLogFlagInfo, tag, frmt, ##__VA_ARGS__)
#define YZLogModuleErr(mod, tag, frmt, ...)      YZLogModuleTag(mod, DDLogFlagError, tag, frmt, ##__VA_ARGS__)
#define YZLogModuleF(mod, tag, frmt, ...)        \
    YZLogModule(mod, tag, @"<%s:%d>"#frmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define YZLogModuleInfoF(mod, tag, frmt, ...)    \
    YZLogModuleInfo(mod, tag, @"<%s:%d>"#frmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define YZLogModuleErrF(mod, tag, frmt, ...)     \
    YZLogModuleErr(mod, tag, @"<%s:%d>"#frmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#endif /* YZLoggerModule_h */
