//
//  NSTimer+YZExtra.m
//  YZFFServer
//
//  Created by chengang on 2019/1/5.
//  Copyright © 2019年 Yingzi. All rights reserved.
//

#import "NSTimer+YZExtra.h"

@implementation NSTimer (YZExtra)

+ (void)load {
    YZObjcExchangeClassMethodAToB(@selector(scheduledTimerWithTimeInterval:repeats:block:),
            @selector(yz_scheduledTimerWithTimeInterval:repeats:block:));
    YZObjcExchangeClassMethodAToB(@selector(timerWithTimeInterval:repeats:block:),
            @selector(yz_timerWithTimeInterval:repeats:block:));
}

+ (void)_yz_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)yz_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(_yz_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)yz_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer timerWithTimeInterval:interval target:self selector:@selector(_yz_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end
