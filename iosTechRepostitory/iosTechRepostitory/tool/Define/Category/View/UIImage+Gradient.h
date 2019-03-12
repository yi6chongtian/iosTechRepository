//
//  UIImage+Gradient.h
//  testLayer
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,            //从上到下
    GradientFromBottomToTop,                //从下到上
    GradientFromLeftToRight,                //从左到右
    GradientFromRightToLeft,                //从右到左
    GradientFromLeftTopToRightBottom,       //从上到下
    GradientFromLeftBottomToRightTop        //从上到下
};

@interface UIImage (Gradient)


+ (UIImage *)gradientFillSize:(CGSize)imageSize withFirstColor:(UIColor *)firstColor andSecondColor:(UIColor *)secondColor gradientType:(GradientType)gradientType;

/**
 两个渐变色 从上到下 各占一半

 @param imageSize 图片大小
 @param firstColor 上色
 @param secondColor 下色
 */

+ (UIImage *)gradientFillSize:(CGSize)imageSize withFirstColor:(UIColor *)firstColor andSecondColor:(UIColor *)secondColor;

/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param percents          渐变颜色的占比数组
 *  @param gradientType     渐变色的类型
 */
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr percentage:(NSArray *)percents gradientType:(GradientType)gradientType;

@end
