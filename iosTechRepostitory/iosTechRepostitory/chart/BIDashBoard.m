//
//  BIDashBoard.m
//  Chart
//
//  Created by tangzhibiao on 2018/10/17.
//  Copyright © 2018年 tangzhibiao. All rights reserved.
//

#import "BIDashBoard.h"

@interface BIDashBoard()

@property (nonatomic,strong) UIImageView *compassImageView;

@property (nonatomic,strong) CAShapeLayer *dashBgLayer;

@property (nonatomic,strong) CAShapeLayer *dashLayer;

@property (nonatomic,assign) CGFloat preAngle;

@end

@implementation BIDashBoard

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (instancetype)init{
    self = [super init];
    [self initUI];
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    [self addSubview:self.compassImageView];
}

- (void)drawRect:(CGRect)rect{
    NSLog(@"%s",__func__);
    
    [self.dashBgLayer removeFromSuperlayer];
    [self.dashLayer removeFromSuperlayer];
    
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height);
    CGFloat radius = rect.size.width * 0.5 - self.lineWidth * 0.5;

    _dashBgLayer = [CAShapeLayer layer];
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI endAngle:0 clockwise:YES];
    _dashBgLayer.path = bgPath.CGPath;
    _dashBgLayer.lineWidth = self.lineWidth;
    _dashBgLayer.strokeColor = self.dashBgColor.CGColor;
    _dashBgLayer.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:_dashBgLayer];

    _dashLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI endAngle:-M_PI + 0.2 clockwise:YES];
    _dashLayer.path  = path.CGPath;
    _dashLayer.lineWidth = self.lineWidth;
    _dashLayer.strokeColor = self.dashColor.CGColor;
    _dashLayer.fillColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:_dashLayer];
    
    _compassImageView.layer.position = CGPointMake(rect.size.width * 0.5, rect.size.height);
    _compassImageView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    [self bringSubviewToFront:_compassImageView];
    // 指针动画
    CABasicAnimation *animationRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animationRotation.fromValue = @(_preAngle);
    animationRotation.toValue = @(_angle);
    animationRotation.fillMode = kCAFillModeForwards;
    animationRotation.removedOnCompletion = NO;
    animationRotation.duration = 0.3;
    [_compassImageView.layer addAnimation:animationRotation forKey:nil];
}

- (void)setAngle:(CGFloat)angle{
    if(_angle != angle){
        _preAngle = _angle;
        _angle = angle;
        [self setNeedsDisplay];
    }
}




#pragma mark - Getter
- (UIImageView *)compassImageView{
    if(_compassImageView == nil){
        _compassImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass"]];
    }
    return _compassImageView;
}

@end
