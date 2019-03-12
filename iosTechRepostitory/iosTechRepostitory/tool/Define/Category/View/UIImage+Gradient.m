//
//  UIImage+Gradient.m
//  testLayer
//

#import "UIImage+Gradient.h"

@implementation UIImage (Gradient)

+ (UIImage *)gradientFillSize:(CGSize)imageSize withFirstColor:(UIColor *)firstColor andSecondColor:(UIColor *)secondColor gradientType:(GradientType)gradientType {
    return [[UIImage new] createImageWithSize:imageSize gradientColors:@[firstColor, secondColor] percentage:@[@(0.2), @(1)] gradientType:gradientType];
}

+ (UIImage *)gradientFillSize:(CGSize)imageSize withFirstColor:(UIColor *)firstColor andSecondColor:(UIColor *)secondColor {
    
    return [[UIImage new] createImageWithSize:imageSize gradientColors:@[firstColor, secondColor] percentage:@[@(0.4), @(1)] gradientType:(GradientFromTopToBottom)];
}

- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(GradientType)gradientType {
    
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
//    NSUInteger capacity = percents.count;
//    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientFromTopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case GradientFromBottomToTop:
            start = CGPointMake(imageSize.width/2, imageSize.height);
            end = CGPointMake(imageSize.width/2, 0);
            break;
        case GradientFromLeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case GradientFromRightToLeft:
            start = CGPointMake(imageSize.width, imageSize.height/2);
            end = CGPointMake(0, imageSize.height/2);
            break;
        case GradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case GradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
