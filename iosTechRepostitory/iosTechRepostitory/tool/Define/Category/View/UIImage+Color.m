//
//  UIImage+Color.m
//  YZFFServer
//
//  Created by chengang on 2018/9/19.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *) yz_transparentImage {
    return [self new];
}

+ (UIImage *) yz_imageWithColor:(UIColor *)color {
    return [self yz_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *) yz_imageWithColor:(UIColor *)color size:(CGSize) size {
    size.width = MAX(0.5, size.width);
    size.height = MAX(0.5, size.height);
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
