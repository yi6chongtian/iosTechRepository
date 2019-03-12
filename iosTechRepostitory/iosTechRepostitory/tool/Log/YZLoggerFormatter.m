//
// Created by chengang on 2018/7/3.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import "YZLoggerFormatter.h"

static unsigned long long sLogIndex = 0;

@interface YZLoggerFormatter ()

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSMutableSet<NSNumber *> *whitelist;
@property(nonatomic, strong) NSMutableSet<NSNumber *> *blacklist;

@end

@implementation YZLoggerFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    if (self.blacklist.count) {
        if ([self.blacklist member:@(logMessage->_context)]) {
            return nil;
        }
    } else if (self.whitelist.count) {
        if (![self.whitelist member:@(logMessage->_context)]) {
            return nil;
        }
    }

    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"ERR"; break;
        case DDLogFlagWarning  : logLevel = @"WRN"; break;
        case DDLogFlagInfo     : logLevel = @"INF"; break;
        default                : logLevel = @"DBG"; break;
    }

    NSString *date = [self.dateFormatter stringFromDate:logMessage->_timestamp];
    return [NSString stringWithFormat:@"<#%lld><%@><%@>%@", sLogIndex++, logLevel, date, logMessage->_message];
}

#pragma mark - Getters & Setters

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss:SSS"];
    }
    return _dateFormatter;
}

- (NSMutableSet<NSNumber *> *)whitelist {
    if (!_whitelist) {
        _whitelist = [[NSMutableSet alloc] init];
    }
    return _whitelist;
}

- (NSMutableSet<NSNumber *> *)blacklist {
    if (!_blacklist) {
        _blacklist = [[NSMutableSet alloc] init];
    }
    return _blacklist;
}

- (void)addToWhitelist:(YZLOG_MODULE_TYPE)type {
    [self.whitelist addObject:@(type)];
}

- (void)addToBlacklist:(YZLOG_MODULE_TYPE)type {
    [self.blacklist addObject:@(type)];
}

@end
