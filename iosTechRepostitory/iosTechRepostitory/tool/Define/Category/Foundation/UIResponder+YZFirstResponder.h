//
//  UIResponder+YZFirstResponder.h
//  YZFFServer
//
//  Created by tangzhibiao on 2018/11/22.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (YZFirstResponder)

+ (UIResponder *)currentFirstResponder;

@end

NS_ASSUME_NONNULL_END
