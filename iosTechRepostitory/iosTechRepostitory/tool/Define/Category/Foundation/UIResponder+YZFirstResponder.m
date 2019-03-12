//
//  UIResponder+YZFirstResponder.m
//  YZFFServer
//
//  Created by tangzhibiao on 2018/11/22.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import "UIResponder+YZFirstResponder.h"

static __weak UIResponder * _firstResponder;

@implementation UIResponder (YZFirstResponder)

+ (UIResponder *)currentFirstResponder{
    BOOL hasResp = [[UIApplication sharedApplication] sendAction:@selector(findFirstResonder:) to:nil from:nil forEvent:nil];
    if(!hasResp){
        _firstResponder = nil;
    }
    return _firstResponder;
}

- (void)findFirstResonder:(id)sender {
    _firstResponder = self;
}

@end
