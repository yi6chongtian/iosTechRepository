//
// Created by chengang on 2018/6/29.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MarqueeLabel/MarqueeLabel.h>

/**
 *  Direction of the linear gradient
 */
typedef NS_ENUM(NSInteger, yzUIViewLinearGradientDirection)
{
    /**
     *  Linear gradient vertical
     */
    yzUIViewLinearGradientDirectionVertical = 0,
    /**
     *  Linear gradient horizontal
     */
    yzUIViewLinearGradientDirectionHorizontal,
    /**
     *  Linear gradient from left to right and top to down
     */
    yzUIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown,
    /**
     *  Linear gradient from left to right and down to top
     */
    yzUIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop,
    /**
     *  Linear gradient from right to left and top to down
     */
    yzUIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown,
    /**
     *  Linear gradient from right to left and down to top
     */
    yzUIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop
};

@interface UIView (YZ)
@property (nonatomic, copy) void (^layoutSubViewsCallBack)(UIView *view);

@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;
@property CGPoint startPoint;
@property CGPoint endPoint;

/**
 * 给View加阴影
 * @param color 阴影颜色
 * @param opacity 阴影透明度，默认0
 * @param offset 阴影偏移,x向右偏移，y向下偏移，默认(0, -3)
 * @param radius 阴影半径，默认3
 * @warning 请注意，如果设置masksToBounds=YES，会导致阴影无效
 *          如果要设置这个属性，请在view上另外加一个view来设置圆角效果
 */
- (void)addShadowWichColor:(UIColor *)color
                   opacity:(float)opacity
                    offset:(CGSize)offset
                    radius:(CGFloat)radius;

- (void)addDefaultShadow;

/**
 判断View是否显示在屏幕上
 @return bool value
 */
- (BOOL)isDisplayedInScreen;

- (void)yz_viewSetSystemBorderWithColor:(UIColor *)color
                           cornerRadius:(CGFloat)cornerRadius
                                  width:(CGFloat)width;


- (void)yz_animation_createGradientWithColorArray:(NSArray *)colorArray
                                            frame:(CGRect)frame
                                        direction:(yzUIViewLinearGradientDirection)direction;

+(UIView *)marqueeLabelViewWithTipsImgV:(UIImage *)tipsImgV
                                  title:(NSString *)title
                               maxWidth:(CGFloat)max_w
                              alignment:(NSTextAlignment)alignment;

/**
 view 出现动画
 
 @param duration duration
 @param finishBlock finishBlock
 */
- (void)yz_animation_showFromBottomWithDuration:(CGFloat)duration
                                    finishBlock:(void(^_Nullable)(void))finishBlock;

/**
 view 消失动画
 
 @param duration duration
 @param finishBlock finishBlock
 */
- (void)yz_animation_dismissFromBottomWithDuration:(CGFloat)duration
                                       finishBlock:(void(^)(void))finishBlock;


@end




// 渐变色

@interface UIView (YZGradient)

@property(nullable, copy) NSArray *yz_colors;

@property(nullable, copy) NSArray<NSNumber *> *yz_locations;

@property CGPoint yz_startPoint;
@property CGPoint yz_endPoint;

+ (UIView *_Nullable)yz_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)yz_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
