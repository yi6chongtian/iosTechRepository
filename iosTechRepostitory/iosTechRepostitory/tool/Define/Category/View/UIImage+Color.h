//
//  UIImage+Color.h
//  YZFFServer
//
//  Created by chengang on 2018/9/19.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

+ (UIImage *) yz_transparentImage;

+ (UIImage *) yz_imageWithColor:(UIColor *)color;
+ (UIImage *) yz_imageWithColor:(UIColor *)color size:(CGSize) size;

@end

NS_ASSUME_NONNULL_END
