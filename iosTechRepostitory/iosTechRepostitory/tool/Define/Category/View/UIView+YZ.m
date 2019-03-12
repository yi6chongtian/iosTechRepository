//
// Created by chengang on 2018/6/29.
// Copyright (c) 2018 Yingzi. All rights reserved.
//

#import "UIView+YZ.h"


@implementation UIView (YZ)

- (void)addShadowWichColor:(UIColor *)color
                   opacity:(float)opacity
                    offset:(CGSize)offset
                    radius:(CGFloat)radius {
    UIView *bg = [UIView new];
    bg.userInteractionEnabled = NO;
    bg.backgroundColor = self.backgroundColor;
    [self addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];

    bg.layer.masksToBounds = NO;
    bg.layer.shadowColor = color.CGColor;
    bg.layer.shadowOpacity = opacity;
    bg.layer.shadowOffset = offset;
    bg.layer.shadowRadius = radius;
    bg.layer.cornerRadius = self.layer.cornerRadius;

    @weakify(bg);
    [RACObserve(self, backgroundColor) subscribeNext:^(id x) {
        @strongify(bg);
        bg.backgroundColor = x;
    }];
    [RACObserve(self.layer, cornerRadius) subscribeNext:^(NSNumber *x) {
        @strongify(bg);
        bg.layer.cornerRadius = x.floatValue;
    }];
}

- (void)addDefaultShadow {
    self.layer.cornerRadius = 4.0;
    [self addShadowWichColor:[UIColor colorWithHex:@"0xDDDDDD" andAlpha:0.05]
                     opacity:0.05
                      offset:CGSizeMake(1, 2)
                      radius:3];
}

- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }

    if (self.window == nil) {
        return FALSE;
    }

//    // 转换view对应window的Rect
//    CGRect rect = [self convertRect:self.frame fromView:nil];
//    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
//        return FALSE;
//    }
//
//    // 若size为CGrectZero
//    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
//        return  FALSE;
//    }

//    CGRect screenRect = [UIScreen mainScreen].bounds;
//    // 获取 该view与window 交叉的 Rect
//    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
//    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
//        return FALSE;
//    }
    
    return TRUE;
}

- (void)yz_viewSetSystemBorderWithColor:(UIColor *)color
                           cornerRadius:(CGFloat)cornerRadius
                                  width:(CGFloat)width
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)yz_animation_createGradientWithColorArray:(NSArray *)colorArray
                                            frame:(CGRect)frame
                                        direction:(yzUIViewLinearGradientDirection)direction
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    
    NSMutableArray *mutableColors = colorArray.mutableCopy;
    if (colorArray.count < 2)
    {
        NSLog(@"%s，渐变颜色必须要有两个及两个以上颜色，否则设置无效！", __func__);
        return;
    }
    for(int i = 0; i < colorArray.count; i++)
    {
        UIColor *currentColor = colorArray[i];
        [mutableColors replaceObjectAtIndex:i withObject:(id)currentColor.CGColor];
    }
    gradient.colors = mutableColors;
    
    switch (direction)
    {
        case yzUIViewLinearGradientDirectionVertical:
        {
            gradient.startPoint = CGPointMake(0.5f, 0.0f);
            gradient.endPoint = CGPointMake(0.5f, 1.0f);
            break;
        }
        case yzUIViewLinearGradientDirectionHorizontal:
        {
            gradient.startPoint = CGPointMake(0.0f, 0.5f);
            gradient.endPoint = CGPointMake(1.0f, 0.5f);
            break;
        }
        case yzUIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown:
        {
            gradient.startPoint = CGPointMake(0.0f, 0.0f);
            gradient.endPoint = CGPointMake(1.0f, 1.0f);
            break;
        }
        case yzUIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop:
        {
            gradient.startPoint = CGPointMake(0.0f, 1.0f);
            gradient.endPoint = CGPointMake(1.0f, 0.0f);
            break;
        }
        case yzUIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown:
        {
            gradient.startPoint = CGPointMake(1.0f, 0.0f);
            gradient.endPoint = CGPointMake(0.0f, 1.0f);
            break;
        }
        case yzUIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop:
        {
            gradient.startPoint = CGPointMake(1.0f, 1.0f);
            gradient.endPoint = CGPointMake(0.0f, 0.0f);
            break;
        }
        default:
        {
            break;
        }
    }
    [self.layer insertSublayer:gradient atIndex:0];
}

-(void)setLayoutSubViewsCallBack:(void (^)(UIView *))layoutSubViewsCallBack
{
    objc_setAssociatedObject(self, @"layoutSubViewsCallBack", layoutSubViewsCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(UIView *))layoutSubViewsCallBack
{
    return objc_getAssociatedObject(self, @"layoutSubViewsCallBack");
}

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method newMethod = class_getInstanceMethod(self, @selector(yz_layoutSubviews));
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)yz_layoutSubviews {
    [self yz_layoutSubviews];
    !self.layoutSubViewsCallBack ?: self.layoutSubViewsCallBack(self);
}

+(UIView *)marqueeLabelViewWithTipsImgV:(UIImage *)tipsImgV title:(NSString *)title maxWidth:(CGFloat)max_w alignment:(NSTextAlignment)alignment
{
    UIView *_rightCornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, max_w, 36)];
    UIImageView *_rightCornerImgV = [[UIImageView alloc] initWithImage:tipsImgV];
    [_rightCornerView addSubview:_rightCornerImgV];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:12]} context:nil].size;
    
    CGFloat _lblW = 0.0;
    BOOL labelize = NO;
    if (size.width > (max_w - _rightCornerImgV.width)) {
        _lblW = max_w - _rightCornerImgV.width;
        labelize = NO;
    }else{
        _lblW = size.width;
        labelize = YES;
    }
    
    MarqueeLabel *_rightCornerLbl = nil;
    if (alignment == NSTextAlignmentLeft) {
        [_rightCornerImgV setCenterY:_rightCornerView.centerY];
        [_rightCornerImgV setX:0];
        _rightCornerLbl = [[MarqueeLabel alloc] initWithFrame:CGRectMake(max_w - _lblW, _rightCornerView.height/2 - 18, _lblW, 36)];
    }else
    {
        _rightCornerLbl = [[MarqueeLabel alloc] initWithFrame:CGRectMake(max_w - _lblW, _rightCornerView.height/2 - 18, _lblW, 36)];
        
        [_rightCornerImgV setCenterY:_rightCornerView.centerY];
        [_rightCornerImgV setX:_rightCornerLbl.left - _rightCornerImgV.width];
    }
    
    _rightCornerLbl.labelize = labelize;
    [_rightCornerLbl setCenterY:_rightCornerView.height/2];
    _rightCornerLbl.marqueeType = MLContinuous;
    _rightCornerLbl.scrollDuration = 10.0f;
    _rightCornerLbl.fadeLength = 10.0f;
    _rightCornerLbl.trailingBuffer = 30.0f;
    _rightCornerLbl.text = title;
    _rightCornerLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    _rightCornerLbl.textColor = kColorWithHexAlpha(0xB7FFD5, 0.6);
    
    [_rightCornerView addSubview:_rightCornerLbl];
    return _rightCornerView;
}

/**
 view 出现动画
 
 @param duration duration
 @param finishBlock finishBlock
 */
- (void)yz_animation_showFromBottomWithDuration:(CGFloat)duration
                                    finishBlock:(void(^)(void))finishBlock
{
    CGPoint min_center = self.center;
    CGPoint min_center2 = self.center;
    CGRect  min_frame  = self.frame;
    CGSize  min_screen_size = [UIScreen mainScreen].bounds.size;
    
    // From
    min_center.y = min_screen_size.height + min_frame.size.height;
    self.center = min_center;
    
    // TO
    //            min_center.y = (min_screen_size.height - min_frame.size.height) * 0.5;
    min_center.y = min_center2.y;
    
    [UIView animateWithDuration:duration animations:^{
        //        self.alpha = 0.3f;
        self.center = min_center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.f animations:^{
            //            self.alpha = 1.0f;
            if (finishBlock)
            {
                finishBlock();
            }
        }];
    }];
}

/**
 view 消失动画
 
 @param duration duration
 @param finishBlock finishBlock
 */
- (void)yz_animation_dismissFromBottomWithDuration:(CGFloat)duration
                                       finishBlock:(void(^)(void))finishBlock
{
    CGPoint min_center = self.center;
    CGRect  min_frame  = self.frame;
    CGSize  min_screen_size = [UIScreen mainScreen].bounds.size;
    
//    switch (positionType) {
//        case BAKit_ViewAnimationEnterDirectionTypeTop:
//        {
//            min_center.y = - min_frame.size.height * 0.5;
//        }
//            break;
//        case BAKit_ViewAnimationEnterDirectionTypeBottom:
//        {
            min_center.y = min_screen_size.height + min_frame.size.height * 0.5;
//        }
//            break;
//        case BAKit_ViewAnimationEnterDirectionTypeLeft:
//        {
//            min_center.x = - min_center.x - min_screen_size.width * 0.5;
//        }
//            break;
//        case BAKit_ViewAnimationEnterDirectionTypeRitht:
//        {
//            min_center.x = min_screen_size.width + min_frame.size.width;
//        }
//            break;
//
//        default:
//            break;
//    }
    [UIView animateWithDuration:duration animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            self.center = min_center;
        } completion:^(BOOL finished) {
            if (finishBlock) {
                finishBlock();
            }
        }];
    }];
}


@end


@implementation UIView (YZGradient)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

+ (UIView *)yz_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    UIView *view = [[self alloc] init];
    [view yz_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}

- (void)yz_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.yz_colors = [colorsM copy];
    self.yz_locations = locations;
    self.yz_startPoint = startPoint;
    self.yz_endPoint = endPoint;
}

#pragma mark- Getter&Setter

- (NSArray *)yz_colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYz_colors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(yz_colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.yz_colors];
    }
}

- (NSArray<NSNumber *> *)yz_locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYz_locations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(yz_locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.yz_locations];
    }
}

- (CGPoint)yz_startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setYz_startPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(yz_startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.yz_startPoint];
    }
}

- (CGPoint)yz_endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setYz_endPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(yz_endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.yz_endPoint];
    }
}


@end
