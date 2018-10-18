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

@interface ViewController ()

@property (nonatomic,strong) BIDashBoard *dashView;

@property (nonatomic,strong) BITemperatureDashBoard *tempDashView;

@property (nonatomic,strong) BILineChart *lineChart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BIDashBoard *dashView = [[BIDashBoard alloc] init];
    dashView.backgroundColor = UIColor.whiteColor;
    dashView.dashBgColor = UIColor.blueColor;
    dashView.dashColor = UIColor.greenColor;
    dashView.lineWidth = 5;
    dashView.frame = CGRectMake(100, 20, 35*2, 35);
    [self.view addSubview:dashView];
    self.dashView = dashView;
    
    BITemperatureDashBoard *tempView = [BITemperatureDashBoard new];
    tempView.backgroundColor = UIColor.lightGrayColor;
    tempView.frame = CGRectMake(100, CGRectGetMaxY(dashView.frame) + 20, 100, 100);
    [self.view addSubview:tempView];
    self.tempDashView = tempView;
    
    NSArray *xData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    NSArray *yData = @[@"1",@"2",@"3",@"4",@"5",@"6",@"5.5"];
    BILineChart *lineChart = [[BILineChart alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(tempView.frame) + 10, self.view.frame.size.width - 30 - 8, 200)];
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
