//
//  BITemperatureDashBoard.m
//  Chart
//
//  Created by tangzhibiao on 2018/10/17.
//  Copyright © 2018年 tangzhibiao. All rights reserved.
//

#import "BITemperatureDashBoard.h"

@interface BITemperatureDashBoard()

@property (nonatomic,strong) NSMutableArray *layers;

@property (nonatomic,strong) CALayer *dashLayer;

@property (nonatomic,strong) NSOperationQueue *queue;

@end

@implementation BITemperatureDashBoard


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self.layers removeAllObjects];
//    [self.queue cancelAllOperations];
    
    CGFloat lineWidth = 7.0;
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat angle = rect.size.width * 0.5 - lineWidth * 0.5;
    NSInteger count = 60;
    CGFloat offsetAngle = M_PI * 2 / count;
    CGFloat perAngle = 1.0 / 120 * M_PI;//1.0 * M_PI / 180.0;
    //底环
    for (NSInteger i = 0; i < count; i++) {
        CGFloat startAngle = i * offsetAngle - perAngle * 0.5;
        CGFloat endAngle = startAngle + perAngle;
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:angle startAngle:startAngle endAngle:endAngle clockwise:YES];
        bgLayer.path = bgPath.CGPath;
        bgLayer.lineWidth = lineWidth;
        bgLayer.strokeColor = UIColor.yellowColor.CGColor;
        [self.layer addSublayer:bgLayer];
        
        [self.layers addObject:bgLayer];
    }
    
    CALayer *layer = [CALayer layer];
    layer.mask = [CALayer layer];
    layer.backgroundColor = UIColor.greenColor.CGColor;
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    [self.layers addObject:layer];
    self.dashLayer = layer;

    //方式一:设置图层的mask
    NSOperation *lastOperation = nil;
    for (NSInteger i = 0; i < 16; i++) {
        NSBlockOperation *operation_AddNewLayer2 = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:0.05];
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                // 因为前面有不可暂停的延时，所以这里要加一个强行停止的开关
                // 这个方案有误差，最好的方案应该用信号量
                self.dashLayer.mask = [self creatMask:i];
            }];
        }];
        if (lastOperation) {
            [operation_AddNewLayer2 addDependency:lastOperation];
        }
        [self.queue addOperation:operation_AddNewLayer2];
        
        lastOperation = operation_AddNewLayer2;
    }
    
  
//     方式二：
//    //有颜色的环
//    for (NSInteger i = 0; i < 16; i++) {
//        CGFloat startAngle = i * offsetAngle - perAngle * 0.5;
//        CGFloat endAngle = startAngle + perAngle;
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:angle startAngle:startAngle endAngle:endAngle clockwise:YES];
//        layer.path = path.CGPath;
//        layer.lineWidth = lineWidth;
//        layer.strokeColor = UIColor.greenColor.CGColor;
//        [self.layer addSublayer:layer];
//
//        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        strokeAnimation.fromValue = @(0.0);
//        strokeAnimation.toValue = @(1.0);
//        strokeAnimation.duration = 0.1;
//        [layer addAnimation:strokeAnimation forKey:nil];
//
//        [self.layers addObject:layer];
//
//    }
    
}

- (CALayer *)creatMask:(NSInteger)index{
    CGRect rect = self.frame;
    CGFloat lineWidth = 7.0;
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat angle = rect.size.width * 0.5 - lineWidth * 0.5;
    NSInteger count = 60;
    CGFloat offsetAngle = M_PI * 2 / count;
    CGFloat perAngle = 1.0 / 120 * M_PI;//1.0 * M_PI / 180.0;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    UIBezierPath *mainPath = [UIBezierPath bezierPath];//[UIBezierPath bezierPathWithArcCenter:center radius:angle startAngle:0 endAngle:M_PI clockwise:YES];
    for (NSInteger i = 0; i < index; i++) {
        CGFloat startAngle = i * offsetAngle - perAngle * 0.5;
        CGFloat endAngle = startAngle + perAngle;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:angle startAngle:startAngle endAngle:endAngle clockwise:YES];
        [mainPath appendPath:path];
    }

    layer.path = mainPath.CGPath;
    layer.lineWidth = lineWidth;
    layer.strokeColor = UIColor.greenColor.CGColor;
    [self.layer addSublayer:layer];
    return layer;
}

#pragma mark - Getter

- (NSMutableArray *)layers{
    if(_layers == nil){
        _layers = [NSMutableArray array];
    }
    return _layers;
}

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}


@end
