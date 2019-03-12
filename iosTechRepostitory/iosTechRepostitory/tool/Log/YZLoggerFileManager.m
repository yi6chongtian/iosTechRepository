//
// Created by chengang on 2018/7/2.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import "YZLoggerFileManager.h"
#import "YZLogger.h"
#import "YZFileUtil.h"
#import "YZTimeStamp.h"
#import "YZDevice.h"
#import "YZUserManager.h"

@interface YZLoggerFileManager ()

@property(nonatomic, strong) NSString *rootDir;
@property(nonatomic, strong) NSString *module;
@property(nonatomic, strong) NSString *deviceId;
@property(nonatomic, strong) NSString *userAccount;

@end

@implementation YZLoggerFileManager {

}

+ (void)load {
    YZ_LOG_TAG_DEFINE(@"Logger");
}

- (instancetype)init {
//    YZException(@"请使用+initWithLogsDirectory:方法创建实例");
    return nil;
}

- (instancetype)initWithModule:(NSString *)module {
    self.module = module;
    self.rootDir = [self.rootDir stringByAppendingPathComponent:module];
    self = [super initWithLogsDirectory:self.rootDir];
    if (!self) return nil;

    YZLogInfo(@"Create Logs Dir: %@", self.rootDir);

    return self;
}

- (NSString *)readLatestLogContentOfSize:(NSUInteger)bytes {

    NSString *logFilePath = [YZFileUtil findLastModifiedFileOfDir:self.rootDir];
    if (!logFilePath.length) {
        return nil;
    }

    NSData *data = [YZFileUtil readDataOfPath:logFilePath withLength:bytes fromEnd:YES];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

- (NSString *)newLogFileName {
    NSMutableString *name = [NSMutableString stringWithFormat:@"%@-%@-%@",
                                                              self.deviceId?:@"NoUuid",
                                                              self.userAccount?:@"NoAccount",
                                                              [YZTimeStamp currentDateString:@"YYYYMMddHHmmss"]];
    if (self.module.length) {
        [name appendFormat:@"--%@", self.module];
    }
    [name appendString:@".log"];

    return name;
}

- (BOOL)isLogFile:(NSString *)fileName {
    BOOL hasProperPrefix = [fileName hasPrefix:self.deviceId];
    BOOL hasProperSuffix = [fileName hasSuffix:@".log"];

    return (hasProperPrefix && hasProperSuffix);
}

#pragma mark - Getters

- (NSString *)rootDir {
    if (!_rootDir) {
        _rootDir = [YZFileUtil cachePathForFile:@"YZLogs"];
    }
    return _rootDir;
}

- (NSString *)deviceId {
    if (!_deviceId) {
        _deviceId = YZUUID;
    }
    return _deviceId;
}

- (NSString *)userAccount {
    return [YZUserManager shared].user.realName;
}

@end
