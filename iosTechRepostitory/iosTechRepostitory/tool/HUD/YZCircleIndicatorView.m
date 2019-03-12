//
//  YZCircleIndicatorView.m
//  YZFFServer
//
//  Created by Kelvin on 2018/12/10.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import "YZCircleIndicatorView.h"

@interface YZCircleIndicatorView()
@property (nonatomic, strong) CAShapeLayer *circle;
@end
@implementation YZCircleIndicatorView

- (void)willMoveToSuperview:(UIView*)newSuperview {
    if (newSuperview) {
    } else {
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)startAnimating {
    [self starAnimation];
}

- (void)stopAnimating {
    [self stopAnimation];
}

#pragma mark - Public
-(void)starAnimation
{
    [self setUpAnimationInLayer:self.layer size:self.bounds.size color:[UIColor colorWithHex:@"#05DB5B" andAlpha:1.0]];
}

-(void)stopAnimation
{
    [self.layer removeAllAnimations];
}

-(void)setUpAnimationInLayer:(CALayer *)layer size:(CGSize)size color:(UIColor*)color {
    
    CGFloat beginTime = 0.5;
    CGFloat strokeStartDuration = 1.2;
    CGFloat strokeEndDuration = 0.9;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.byValue = @(M_PI * 2);
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = strokeEndDuration;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1);
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.duration = strokeStartDuration;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0];
    strokeStartAnimation.fromValue = @(0);
    strokeStartAnimation.toValue = @(1);
    strokeStartAnimation.beginTime = beginTime;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[rotationAnimation, strokeEndAnimation, strokeStartAnimation];
    groupAnimation.duration = strokeStartDuration + beginTime;
    groupAnimation.repeatCount = INFINITY;
    [groupAnimation setRemovedOnCompletion:NO];
    groupAnimation.fillMode = kCAFillModeForwards;
    
    if (self.circle) {
        [self.circle removeAllAnimations];
        [self.circle removeFromSuperlayer];
        self.circle = nil;
    }
    
    self.circle = [self layerWith:size color:color];
    CGRect frame = CGRectMake((layer.bounds.size.width - size.width) / 2,
                              (layer.bounds.size.height - size.height) / 2,
                              size.width,
                              size.height);
    
    _circle.frame = frame;
    [_circle addAnimation:groupAnimation forKey:@"animation"];
    [layer addSublayer:_circle];
}

-(CAShapeLayer *)layerWith:(CGSize)size color:(UIColor *)color
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = 3.5;
    [path addArcWithCenter:CGPointMake(size.width / 2, size.height / 2)
                    radius:/*size.width / 2*/12.0
                startAngle:-(M_PI / 2)
                  endAngle:M_PI + M_PI / 2 clockwise:YES];
    
    layer.fillColor = nil;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    layer.lineCap = kCALineCapRound;
    
    layer.backgroundColor = nil;
    layer.path = path.CGPath;
    layer.frame = CGRectMake(0,0,size.width,size.height);
    
    return layer;
}
@end
