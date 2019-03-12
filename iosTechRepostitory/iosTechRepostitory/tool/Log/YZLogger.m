//
// Created by chengang on 2018/7/2.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import "YZLogger.h"
#import "YZLoggerFormatter.h"
#import "YZLoggerFileManager.h"

NSMutableDictionary *gYZLoggerModuleDics;
NSMutableDictionary *gYZLoggerTagDics;

@interface YZLogger ()

@property(nonatomic, strong) YZLoggerFileManager *defaultLoggerFileManager;
@property(nonatomic, strong) YZLoggerFileManager *netLoggerFileManager;
@property(nonatomic, strong) YZLoggerFileManager *yxLoggerFileManager;
@property(nonatomic, strong) YZLoggerFileManager *iotLoggerFileManager;

@end

@implementation YZLogger {

}
YZSingletonM()

+ (void)load {
    [[YZLogger shared] setup];
}

+ (void)logWithFlag:(DDLogFlag)flag
               func:(const char *)func
             module:(YZLOG_MODULE_TYPE)mod
                tag:(NSString *)tag
            content:(NSString *)content {
    YZLogModuleTag(mod, flag, tag, @"<%s:%d>%@", func, 0, content);
}

- (void)setup {
    /// Global Console Logger
    YZLoggerFormatter *loggerFormatter = [YZLoggerFormatter new];

#ifndef DEBUG
    [loggerFormatter addToBlacklist:YZLOG_MODULE_TYPE_NET];
    [loggerFormatter addToBlacklist:YZLOG_MODULE_TYPE_YX];
#endif
    [loggerFormatter addToBlacklist:YZLOG_MODULE_TYPE_IOT];
    [DDTTYLogger sharedInstance].logFormatter = loggerFormatter;
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    [self setupFileLoggers];
}

- (void)setupFileLoggers {
    self.defaultLoggerFileManager = [self creatFileLoggerOfModule:nil withType:YZLOG_MODULE_TYPE_DEFAULT];
    self.netLoggerFileManager = [self creatFileLoggerOfModule:@"NET" withType:YZLOG_MODULE_TYPE_NET];
    self.yxLoggerFileManager = [self creatFileLoggerOfModule:@"YX" withType:YZLOG_MODULE_TYPE_YX];
    self.iotLoggerFileManager = [self creatFileLoggerOfModule:@"IOT" withType:YZLOG_MODULE_TYPE_IOT];
}

- (YZLoggerFileManager *)creatFileLoggerOfModule:(NSString *)module withType:(YZLOG_MODULE_TYPE)type {
    YZLoggerFormatter *loggerFormatter = [YZLoggerFormatter new];
    loggerFormatter.module = module;
    [loggerFormatter addToWhitelist:type];

    YZLoggerFileManager *logFileManager = [[YZLoggerFileManager alloc] initWithModule:module];
    logFileManager.maximumNumberOfLogFiles = 1;
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.maximumFileSize = 10*1024*1024; // Byte
    fileLogger.rollingFrequency = 0;
    fileLogger.logFormatter = loggerFormatter;

    [DDLog addLogger:fileLogger];

    YZLogInfoF(@"[module: %@][type: %d]", module, type);
    return logFileManager;
}

- (NSString *)getLatestLoggerContent {
    NSUInteger length = 1*1024*1024; // MBytes
    return [self.defaultLoggerFileManager readLatestLogContentOfSize:length];
}

@end
