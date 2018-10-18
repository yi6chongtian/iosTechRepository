//
//  ViewController.m
//  iosTechRepostitory
//
//  Created by tang on 2018/1/14.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "ViewController.h"
#import "TZBNetRequest.h"
#import "BIDashBoard.h"
#import "BITemperatureDashBoard.h"
#import "BILineChart.h"
#import "RectangleIndicatorView.h"
#import "CircleIndicatorView.h"

@interface ViewController ()

@property (nonatomic,strong) BIDashBoard *dashView;

@property (nonatomic,strong) BITemperatureDashBoard *tempDashView;

@property (nonatomic,strong) BILineChart *lineChart;

@property (strong, nonatomic)  CircleIndicatorView *circleIndicatorView;

@property (strong, nonatomic)  RectangleIndicatorView *rectangleIndicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BIDashBoard *dashView = [[BIDashBoard alloc] init];
    dashView.backgroundColor = UIColor.whiteColor;
    dashView.dashBgColor = UIColor.blueColor;
    dashView.dashColor = UIColor.greenColor;
    dashView.lineWidth = 5;
    dashView.frame = CGRectMake(100, 64, 35*2, 35);
    [self.view addSubview:dashView];
    self.dashView = dashView;
    
    BITemperatureDashBoard *tempView = [BITemperatureDashBoard new];
    tempView.backgroundColor = UIColor.lightGrayColor;
    tempView.frame = CGRectMake(100, CGRectGetMaxY(dashView.frame) + 20, 100, 100);
    [self.view addSubview:tempView];
    self.tempDashView = tempView;
    
    NSArray *xData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    NSArray *yData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"5.5"];
    BILineChart *lineChart = [[BILineChart alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(tempView.frame) + 10, self.view.frame.size.width - 30 - 8, 100)];
    lineChart.displayDataPoint = YES;
    lineChart.bezierSmoothing = NO;
    lineChart.maxValue = 10;
    lineChart.xData = xData;
    lineChart.unitX = @"天";
    lineChart.unitY = @"斤";
    lineChart.horizontalGridStep = (int)xData.count;
    lineChart.verticalGridStep = 4;
    lineChart.labelForIndex = ^NSString *(NSUInteger index) {
        return [NSString stringWithFormat:@"%@%@",xData[index],lineChart.unitX];
    };
    lineChart.labelForValue = ^NSString *(NSUInteger index) {
        return [NSString stringWithFormat:@"%.1f %@", (CGFloat)lineChart.maxValue / lineChart.verticalGridStep * (int)(index),lineChart.unitY];
    };
    [lineChart setChartData:yData];
    [self.view addSubview:lineChart];
    self.lineChart = lineChart;
    
    self.rectangleIndicatorView = [[RectangleIndicatorView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(lineChart.frame) + 20, self.view.frame.size.width - 8 - 8, 200)];
    self.rectangleIndicatorView.backgroundColor = UIColor.whiteColor;
    self.rectangleIndicatorView.minValue = 40;
    self.rectangleIndicatorView.maxValue = 80;
    self.rectangleIndicatorView.valueToShowArray = @[@40, @50, @60, @70, @80];
    self.rectangleIndicatorView.indicatorValue = 50;
    self.rectangleIndicatorView.minusBlock = ^{
        NSLog(@"点击了 -");
        self.rectangleIndicatorView.indicatorValue -= 1;
    };
    self.rectangleIndicatorView.addBlock = ^{
        NSLog(@"点击了 +");
        self.rectangleIndicatorView.indicatorValue += 1;
    };
    [self.view addSubview:self.rectangleIndicatorView];
    
    self.circleIndicatorView =  [[CircleIndicatorView alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(self.rectangleIndicatorView.frame) + 10, self.view.frame.size.width - 8 - 8, 80)];
    self.circleIndicatorView.backgroundColor  = UIColor.whiteColor;
    self.circleIndicatorView.minValue = 40;
    self.circleIndicatorView.maxValue = 80;
    self.circleIndicatorView.innerAnnulusValueToShowArray = @[@40, @50, @60, @70, @80];
    self.circleIndicatorView.indicatorValue = 60;
    self.circleIndicatorView.minusBlock = ^{
        NSLog(@"点击了 -");
        self.circleIndicatorView.indicatorValue -= 1;
    };
    self.circleIndicatorView.addBlock = ^{
        NSLog(@"点击了 +");
        self.circleIndicatorView.indicatorValue += 1;
    };
    [self.view addSubview:self.circleIndicatorView];

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGFloat angle = arc4random() % 315 * 0.01;
    self.dashView.angle = angle;
    
    [self.tempDashView setNeedsDisplay];

}

@end
