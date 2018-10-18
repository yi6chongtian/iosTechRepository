//
//  BILineChart.m
//  Chart
//
//  Created by tangzhibiao on 2018/10/18.
//  Copyright © 2018年 tangzhibiao. All rights reserved.
//

#import "BILineChart.h"

// 十六进制创建颜色
#define kColorWithHex(hexValue) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define kColorWithHexAlpha(hexValue,a) [UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:(a)]

#define FUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BILineChart ()

@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) NSMutableArray* layers;

@property (nonatomic) CGFloat min;
@property (nonatomic) CGFloat max;
@property (nonatomic) CGMutablePathRef initialPath;
@property (nonatomic) CGMutablePathRef newPath;

@end

@implementation BILineChart

#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit
{
    _layers = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    [self setDefaultParameters];
}

- (void)setDefaultParameters
{
    self.backgroundColor = kColorWithHex(0xC662F);
    _color = kColorWithHex(0xFFC400);
    //    _fillColor = kColorWithHexAlpha(0x0B9845, 0.7);
    _verticalGridStep = 3;
    _horizontalGridStep = 3;
    _margin = 0.0f;
    _axisWidth = self.frame.size.width - 2 * _margin;
    _axisHeight = self.frame.size.height - 2 * _margin;
    _axisColor = kColorWithHex(0xC662F);
    _innerGridColor = kColorWithHex(0x098A46);
    _drawInnerGrid = YES;
    _bezierSmoothing = NO;
    _bezierSmoothingTension = 0.2;
    _lineWidth = 1;
    _innerGridLineWidth = 1;
    _axisLineWidth = 3;
    _animationDuration = 0.5;
    _displayDataPoint = YES;
    _dataPointRadius = 3;
    _dataPointColor = kColorWithHex(0xB78300);
    _dataPointBackgroundColor = _color;
    
    // Labels attributes
    _indexLabelBackgroundColor = [UIColor clearColor];
    _indexLabelTextColor = kColorWithHex(0x004C1E);
    _indexLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    
    _valueLabelBackgroundColor = [UIColor clearColor];
    _valueLabelTextColor = kColorWithHex(0x004C1E);
    _valueLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    _valueLabelPosition = ValueLabelLeft;
}

- (void)layoutSubviews
{
    _axisWidth = self.frame.size.width - 2 * _margin;
    _axisHeight = self.frame.size.height - 2 * _margin;
    
    // Removing the old label views as well as the chart layers.
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.layers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CALayer* layer = (CALayer*)obj;
        [layer removeFromSuperlayer];
    }];
    
    [self layoutChart];
    [super layoutSubviews];
}

- (void)layoutChart
{
    if(_data == nil) {
        return;
    }
    
    [self computeBounds];
    
    // No data
    if(isnan(_max)) {
        _max = 1;
    }
    
    [self strokeChart];
    
    if(_displayDataPoint) {
        [self strokeDataPoints];
    }
    
    if(_labelForValue) {
        for(int i = 0; i < _verticalGridStep + 1;i++) {
            
            UILabel* label = [self createLabelForValue:i];
            
            if(label) {
                [self addSubview:label];
            }
        }
    }
    
    if(_labelForIndex) {
        for(int i = 0; i < _horizontalGridStep; i++) {
            
            UILabel* label = [self createLabelForIndex:i];
            
            if(label) {
                [self addSubview:label];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)setChartData:(NSArray *)chartData
{
    if (chartData == nil || chartData.count == 0) {
        return;
    }
    
    _data = [NSMutableArray arrayWithArray:chartData];
    [self layoutChart];
}

#pragma mark - Labels creation

- (UILabel*)createLabelForValue: (NSUInteger)index
{
    if (_max == 0) {
        
        return nil;
    }
    if (self.data.count == 0) {
        
        return nil;
    }
    NSString* text = _labelForValue(index);
    if(!text) {
        return nil;
    }
    
    
    //    CGPoint p = CGPointMake(_margin + (_valueLabelPosition == ValueLabelRight ? _axisWidth : 0), (_axisHeight - 16) - (_axisHeight - 16) / (_verticalGridStep - 1) * index);
    CGFloat value = [text floatValue];
    CGPoint p = CGPointMake(0, _axisHeight - value * (_axisHeight / _max));
    
    CGRect rect = CGRectMake(_margin, p.y + 2, self.frame.size.width - _margin * 2 - 4.0f, 14);
    
    float width = [text boundingRectWithSize:rect.size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{ NSFontAttributeName:_valueLabelFont }
                                     context:nil].size.width;
    
    CGFloat xPadding = 6;
    CGFloat xOffset = width + xPadding;
    
    if (_valueLabelPosition == ValueLabelLeftMirrored) {
        xOffset = -xPadding;
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p.x - xOffset, p.y, width + 2, 14)];
//    [label setPosition:p atAnchorPoint:CGPointMake(1, .5)];
    label.layer.position = p;
    label.layer.anchorPoint = CGPointMake(1, .5);
    label.text = text;
    label.font = _valueLabelFont;
    label.textColor = _valueLabelTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = _valueLabelBackgroundColor;
    
    return label;
}

- (UILabel*)createLabelForIndex: (NSUInteger)index
{
    CGFloat scale = [self horizontalScale];
    NSInteger q = (int)_data.count / _horizontalGridStep;
    NSInteger itemIndex = q * index;
    
    if(itemIndex >= _data.count)
    {
        itemIndex = _data.count - 1;
    }
    
    NSString* text = _labelForIndex(itemIndex);
    
    if(!text)
    {
        return nil;
    }
    
    CGPoint p = CGPointMake(_margin + index * (_axisWidth / _horizontalGridStep) * scale, _axisHeight + _margin);
    
    CGRect rect = CGRectMake(_margin, p.y + 2, self.frame.size.width - _margin * 2 - 4.0f, 14);
    
    float width = [text boundingRectWithSize:rect.size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{ NSFontAttributeName:_indexLabelFont }
                                     context:nil].size.width;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width + 2, 14)];
    label.text = text;
    label.font = _indexLabelFont;
    label.textColor = _indexLabelTextColor;
    label.backgroundColor = _indexLabelBackgroundColor;
    
    if (index == 0) {
        
        label.textAlignment = NSTextAlignmentLeft;
//        [label setPosition:p atAnchorPoint:CGPointMake(0, 0)];
        label.layer.position = p;
        label.layer.anchorPoint = CGPointMake(.0, .0);
    } else if (index == _data.count - 1) {
        
        label.textAlignment = NSTextAlignmentRight;
//        [label setPosition:p atAnchorPoint:CGPointMake(1, 0)];
        label.layer.position = p;
        label.layer.anchorPoint = CGPointMake(1, .0);
    } else {
        
        label.textAlignment = NSTextAlignmentCenter;
//        [label setPosition:p atAnchorPoint:CGPointMake(.5, 0)];
        label.layer.position = p;
        label.layer.anchorPoint = CGPointMake(.5, .0);
    }
    
    return label;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if (_data.count > 0) {
        [self drawGrid];
    }
}

- (void)drawGrid
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetLineWidth(ctx, _axisLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
    
    // draw coordinate axis
    CGContextMoveToPoint(ctx, _margin, _margin);
    CGContextAddLineToPoint(ctx, _margin, _axisHeight + _margin);
    CGContextStrokePath(ctx);
    
    CGFloat scale = [self horizontalScale];
    CGFloat minBound = [self minVerticalBound];
    CGFloat maxBound = [self maxVerticalBound];
    
    CGContextSetLineWidth(ctx, _axisLineWidth);
    CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
    
    CGPoint point = CGPointMake(_margin, (_verticalGridStep) * _axisHeight / _verticalGridStep + _margin);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, _axisWidth + _margin, point.y);
    CGContextStrokePath(ctx);
    
    // draw grid
    if(_drawInnerGrid) {
        
        for(int i = 0; i < _horizontalGridStep; i++) {
            
            CGContextSetStrokeColorWithColor(ctx, [_innerGridColor CGColor]);
            CGContextSetLineWidth(ctx, _innerGridLineWidth);
            CGFloat lengths[] = {2};
            //            CGContextSetLineDash(ctx, 0, lengths, 1);
            CGPoint point = CGPointMake((1 + i) * _axisWidth / _horizontalGridStep * scale + _margin, _margin);
            
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, point.x, _axisHeight + _margin - 1);
            CGContextStrokePath(ctx);
        }
        
        for(int i = 0; i < _verticalGridStep + 1; i++) {
            // If the value is zero then we display the horizontal axis
            CGFloat v = maxBound - (maxBound - minBound) / _verticalGridStep * i;
            
            if(v == 0) {
                CGContextSetLineWidth(ctx, _axisLineWidth);
                CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
            } else {
                CGContextSetStrokeColorWithColor(ctx, [_innerGridColor CGColor]);
                CGContextSetLineWidth(ctx, _innerGridLineWidth);
            }
            
            CGPoint point = CGPointMake(_margin, (i) * _axisHeight / _verticalGridStep + _margin);
            
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, _axisWidth + _margin, point.y);
            CGContextStrokePath(ctx);
        }
    }
    
    UIGraphicsPopContext();
}

- (void)clearChartData
{
    for (CAShapeLayer *layer in self.layers) {
        [layer removeFromSuperlayer];
    }
    [self.layers removeAllObjects];
}

- (void)strokeChart {
    
    if (self.data.count > 0) {
        
        CGFloat minBound = [self minVerticalBound];
        CGFloat scale = [self verticalScale];
        
        UIBezierPath *noPath = [self getLinePath:0 withSmoothing:_bezierSmoothing close:NO];
        UIBezierPath *path = [self getLinePath:scale withSmoothing:_bezierSmoothing close:NO];
        
        UIBezierPath *noFill = [self getLinePath:0 withSmoothing:_bezierSmoothing close:YES];
        UIBezierPath *fill = [self getLinePath:scale withSmoothing:_bezierSmoothing close:YES];
        
        if(_fillColor) {
            CAShapeLayer* fillLayer = [CAShapeLayer layer];
            fillLayer.frame = CGRectMake(self.bounds.origin.x + 2, self.bounds.origin.y + minBound * scale, self.bounds.size.width - 2, self.bounds.size.height - 2);
            fillLayer.bounds = self.bounds;
            fillLayer.path = fill.CGPath;
            fillLayer.strokeColor = nil;
            fillLayer.fillColor = _fillColor.CGColor;
            fillLayer.lineWidth = 0;
            fillLayer.lineJoin = kCALineJoinRound;
            
            [self.layer addSublayer:fillLayer];
            [self.layers addObject:fillLayer];
            
            CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            fillAnimation.duration = _animationDuration;
            fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            fillAnimation.fillMode = kCAFillModeForwards;
            fillAnimation.fromValue = (id)noFill.CGPath;
            fillAnimation.toValue = (id)fill.CGPath;
            [fillLayer addAnimation:fillAnimation forKey:@"path"];
        }
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + minBound * scale, self.bounds.size.width, self.bounds.size.height);
        pathLayer.bounds = self.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [_color CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = _lineWidth;
        pathLayer.lineJoin = kCALineJoinRound;
        
        [self.layer addSublayer:pathLayer];
        [self.layers addObject:pathLayer];
        
        if(_fillColor) {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = (__bridge id)(noPath.CGPath);
            pathAnimation.toValue = (__bridge id)(path.CGPath);
            [pathLayer addAnimation:pathAnimation forKey:@"path"];
        } else {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            [pathLayer addAnimation:pathAnimation forKey:@"path"];
        }
    }
}

- (void)strokeDataPoints
{
    CGFloat minBound = [self minVerticalBound];
    CGFloat scale = [self verticalScale];
    
    for(int i=0;i<_data.count;i++) {
        CGPoint p = [self getPointForIndex:i withScale:scale];
        p.y +=  minBound * scale;
        
        UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(p.x - _dataPointRadius, p.y - _dataPointRadius, _dataPointRadius * 2, _dataPointRadius * 2)];
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = CGRectMake(p.x, p.y, _dataPointRadius, _dataPointRadius);
        fillLayer.bounds = CGRectMake(p.x, p.y, _dataPointRadius, _dataPointRadius);
        fillLayer.path = circle.CGPath;
        fillLayer.strokeColor = _dataPointColor.CGColor;
        fillLayer.fillColor = _dataPointBackgroundColor.CGColor;
        fillLayer.lineWidth = 1;
        fillLayer.lineJoin = kCALineJoinRound;
        
        [self.layer addSublayer:fillLayer];
        [self.layers addObject:fillLayer];
    }
}



// 标准值
- (void)drawStandLine {
    
    if (self.standValues.count == 0) {
        
        return;
    }
    
    
    // 创建标准线 layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFrame:CGRectMake(0, 0, _axisWidth, _axisHeight)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    // 设置虚线颜色
    [shapeLayer setStrokeColor:kColorWithHex(0xF8E71C).CGColor];
    // 设置虚线宽度
    [shapeLayer setLineWidth:1];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
    
    // 标准线
    CGFloat scale = [self verticalScale];
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < self.standValues.count - 1; i++) {
        
        CGPoint controlPoint[2];
        CGPoint p = [self getStandPoint:i withScale:scale];
        
        // Start the path drawing
        if(i == 0) {
            
            p.x += 2;
            p.y -= 2;
            [path moveToPoint:p];
        }
        
        CGPoint nextPoint, previousPoint, m;
        
        // First control point
        nextPoint = [self getStandPoint:i + 1 withScale:scale];
        previousPoint = [self getStandPoint:i - 1 withScale:scale];
        m = CGPointZero;
        
        if(i > 0) {
            m.x = (nextPoint.x - previousPoint.x) / 2;
            m.y = (nextPoint.y - previousPoint.y) / 2;
        } else {
            m.x = (nextPoint.x - p.x) / 2;
            m.y = (nextPoint.y - p.y) / 2;
        }
        
        controlPoint[0].x = MAX(0, MIN(p.x + m.x * _bezierSmoothingTension, p.x));
        controlPoint[0].y = MAX(0, MIN(p.y + m.y * _bezierSmoothingTension, p.y));
        
        // Second control point
        nextPoint = [self getStandPoint:i + 2 withScale:scale];
        previousPoint = [self getStandPoint:i withScale:scale];
        p = [self getStandPoint:i + 1 withScale:scale];
        m = CGPointZero;
        
        if(i < _data.count - 2) {
            m.x = (nextPoint.x - previousPoint.x) / 2;
            m.y = (nextPoint.y - previousPoint.y) / 2;
        } else {
            m.x = (p.x - previousPoint.x) / 2;
            m.y = (p.y - previousPoint.y) / 2;
        }
        
        controlPoint[1].x = MAX(0, MIN(p.x - m.x * _bezierSmoothingTension, p.x));
        controlPoint[1].y = MAX(0, MIN(p.y - m.y * _bezierSmoothingTension, p.y));
        
        [path addCurveToPoint:p controlPoint1:controlPoint[0] controlPoint2:controlPoint[1]];
    }
    
    shapeLayer.path = path.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _animationDuration;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:pathAnimation forKey:@"path"];
    
    [self.layer addSublayer:shapeLayer];
    [self.layers addObject:shapeLayer];
}

#pragma mark - Chart scale & boundaries

- (CGFloat)horizontalScale
{
    CGFloat scale = 1.0f;
    NSInteger q = (int)_data.count / _horizontalGridStep;
    
    if(_data.count > 1) {
        scale = (CGFloat)(q * _horizontalGridStep) / (CGFloat)(_data.count - 1);
    }
    
    return scale;
}

- (CGFloat)verticalScale
{
    CGFloat minBound = [self minVerticalBound];
    CGFloat maxBound = [self maxVerticalBound];
    CGFloat spread = maxBound - minBound;
    CGFloat scale = 0;
    
    if (spread != 0) {
        scale = _axisHeight / spread;
    }
    
    return scale;
}

- (CGFloat)minVerticalBound
{
    return MIN(_min, 0);
}

- (CGFloat)maxVerticalBound
{
    return MAX(_max, 0);
}

- (void)computeBounds
{
    _min = 0;
    _max = self.maxValue;
    
    
    // The idea is to adjust the minimun and the maximum value to display the whole chart in the view, and if possible with nice "round" steps.
    //    _max = [self getUpperRoundNumber:_max forGridStep:_verticalGridStep];
    
    if(_min < 0) {
        // If the minimum is negative then we want to have one of the step to be zero so that the chart is displayed nicely and more comprehensively
        float step;
        
        if(_verticalGridStep > 3) {
            step = fabs(_max - _min) / (float)(_verticalGridStep - 1);
        } else {
            step = MAX(fabs(_max - _min) / 2, MAX(fabs(_min), fabs(_max)));
        }
        
        step = [self getUpperRoundNumber:step forGridStep:_verticalGridStep];
        
        float newMin,newMax;
        
        if(fabs(_min) > fabs(_max)) {
            int m = ceilf(fabs(_min) / step);
            
            newMin = step * m * (_min > 0 ? 1 : -1);
            newMax = step * (_verticalGridStep - m) * (_max > 0 ? 1 : -1);
            
        } else {
            int m = ceilf(fabs(_max) / step);
            
            newMax = step * m * (_max > 0 ? 1 : -1);
            newMin = step * (_verticalGridStep - m) * (_min > 0 ? 1 : -1);
        }
        
        if(_min < newMin) {
            newMin -= step;
            newMax -=  step;
        }
        
        if(_max > newMax + step) {
            newMin += step;
            newMax +=  step;
        }
        
        _min = newMin;
        _max = newMax;
        
        if(_max < _min) {
            float tmp = _max;
            _max = _min;
            _min = tmp;
        }
        
    }
}

#pragma mark - Chart utils

- (CGFloat)getUpperRoundNumber:(CGFloat)value forGridStep:(int)gridStep
{
    if(value <= 0)
        return 0;
    
    // We consider a round number the following by 0.5 step instead of true round number (with step of 1)
    CGFloat logValue = log10f(value);
    CGFloat scale = powf(10, floorf(logValue));
    CGFloat n = ceilf(value / scale * 4);
    
    int tmp = (int)(n) % gridStep;
    
    if(tmp != 0) {
        n += gridStep - tmp;
    }
    
    return n * scale / 4.0f;
}

- (void)setGridStep:(int)gridStep
{
    _verticalGridStep = gridStep;
    _horizontalGridStep = gridStep;
}

- (CGPoint)getPointForIndex:(NSUInteger)idx withScale:(CGFloat)scale
{
    if(idx >= _data.count) {
        return CGPointZero;
    }
    
    // Compute the point position in the view from the data with a set scale value
    NSNumber* number = _data[idx];
    CGPoint point = CGPointZero;
    
    if(_data.count < 2) {
        
        point = CGPointMake(_margin, _axisHeight + _margin - [number floatValue] * scale);
    } else {
        
        point = CGPointMake(_margin + idx * (_axisWidth / (_data.count - 1)), _axisHeight + _margin - [number floatValue] * scale);
    }
    
    // 边界判断
    point.x = MAX(0, MIN(_axisWidth, point.x));
    point.y = MAX(0, MIN(_axisHeight, point.y));
    
    return point;
}

- (CGPoint)getStandPoint:(NSUInteger)idx withScale:(CGFloat)scale {
    
    if(idx >= _standValues.count) {
        return CGPointZero;
    }
    
    // Compute the point position in the view from the data with a set scale value
    NSNumber* number = _standValues[idx];
    CGPoint point = CGPointZero;
    if(_standValues.count < 2) {
        
        point = CGPointMake(_margin, _axisHeight + _margin - [number floatValue] * scale);
    } else {
        
        point = CGPointMake(_margin + idx * (_axisWidth / (_standValues.count - 1)), _axisHeight + _margin - [number floatValue] * scale);
    }
    
    // 边界判断
    point.x = MAX(0, MIN(_axisWidth, point.x));
    point.y = MAX(0, MIN(_axisHeight, point.y));
    
    return point;
}

- (UIBezierPath*)getLinePath:(float)scale withSmoothing:(BOOL)smoothed close:(BOOL)closed
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    if(smoothed) {
        for(int i=0;i<_data.count - 1;i++) {
            CGPoint controlPoint[2];
            CGPoint p = [self getPointForIndex:i withScale:scale];
            
            // Start the path drawing
            if(i == 0) {
                
                p.x += 2;
                p.y -= 2;
                [path moveToPoint:p];
            }
            
            CGPoint nextPoint, previousPoint, m;
            
            // First control point
            nextPoint = [self getPointForIndex:i + 1 withScale:scale];
            previousPoint = [self getPointForIndex:i - 1 withScale:scale];
            m = CGPointZero;
            
            if(i > 0) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (nextPoint.x - p.x) / 2;
                m.y = (nextPoint.y - p.y) / 2;
            }
            
            controlPoint[0].x = MAX(0, MIN(p.x + m.x * _bezierSmoothingTension, p.x));
            controlPoint[0].y = MAX(0, MIN(p.y + m.y * _bezierSmoothingTension, p.y));
            
            // Second control point
            nextPoint = [self getPointForIndex:i + 2 withScale:scale];
            previousPoint = [self getPointForIndex:i withScale:scale];
            p = [self getPointForIndex:i + 1 withScale:scale];
            m = CGPointZero;
            
            if(i < _data.count - 2) {
                m.x = (nextPoint.x - previousPoint.x) / 2;
                m.y = (nextPoint.y - previousPoint.y) / 2;
            } else {
                m.x = (p.x - previousPoint.x) / 2;
                m.y = (p.y - previousPoint.y) / 2;
            }
            
            controlPoint[1].x = MAX(0, MIN(p.x - m.x * _bezierSmoothingTension, p.x));
            controlPoint[1].y = MAX(0, MIN(p.y - m.y * _bezierSmoothingTension, p.y));
            
            [path addCurveToPoint:p controlPoint1:controlPoint[0] controlPoint2:controlPoint[1]];
        }
        
    } else {
        for(int i=0;i<_data.count;i++) {
            if(i > 0) {
                [path addLineToPoint:[self getPointForIndex:i withScale:scale]];
            } else {
                [path moveToPoint:[self getPointForIndex:i withScale:scale]];
            }
        }
    }
    
    if(closed) {
        // Closing the path for the fill drawing
        [path addLineToPoint:[self getPointForIndex:_data.count - 1 withScale:scale]];
        [path addLineToPoint:[self getPointForIndex:_data.count - 1 withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 withScale:0]];
        [path addLineToPoint:[self getPointForIndex:0 withScale:scale]];
    }
    
    return path;
}

#pragma mark - getter

@end
