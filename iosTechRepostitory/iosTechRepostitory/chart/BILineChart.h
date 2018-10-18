//
//  BILineChart.h
//  Chart
//
//  Created by tangzhibiao on 2018/10/18.
//  Copyright © 2018年 tangzhibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BILineChart : UIView

// Block definition for getting a label for a set index (use case: date, units,...)
typedef NSString *(^FSLabelForIndexGetter)(NSUInteger index);

// Same as above, but for the value (for adding a currency, or a unit symbol for example)
typedef NSString *(^FSLabelForValueGetter)(NSUInteger index);

typedef NS_ENUM(NSInteger, ValueLabelPositionType) {
    ValueLabelLeft,
    ValueLabelRight,
    ValueLabelLeftMirrored
};

// Index label properties   x轴设置
@property (copy) FSLabelForIndexGetter labelForIndex;
@property (nonatomic, strong) UIFont* indexLabelFont;
@property (nonatomic) UIColor* indexLabelTextColor;
@property (nonatomic) UIColor* indexLabelBackgroundColor;

// Value label properties   y轴设置
@property (copy) FSLabelForValueGetter labelForValue;
@property (nonatomic, strong) UIFont* valueLabelFont;
@property (nonatomic) UIColor* valueLabelTextColor;
@property (nonatomic) UIColor* valueLabelBackgroundColor;
@property (nonatomic) ValueLabelPositionType valueLabelPosition;

// Number of visible step in the chart
@property (nonatomic) int gridStep;
@property (nonatomic) int verticalGridStep;     //纵轴有几个网格
@property (nonatomic) int horizontalGridStep;   //横轴有几个网格

// Margin of the chart
@property (nonatomic) CGFloat margin;

@property (nonatomic) CGFloat axisWidth;
@property (nonatomic) CGFloat axisHeight;

// Decoration parameters, let you pick the color of the line as well as the color of the axis
@property (nonatomic, strong) UIColor* axisColor;   //坐标轴的颜色
@property (nonatomic) CGFloat axisLineWidth;        //坐标轴的宽度

// Chart parameters
@property (nonatomic, strong) UIColor* color;       //折线颜色
@property (nonatomic, strong) UIColor* fillColor;   //折线填充颜色
@property (nonatomic) CGFloat lineWidth;            //折线宽度

// Data points  数据圆点
@property (nonatomic) BOOL displayDataPoint;
@property (nonatomic, strong) UIColor* dataPointColor;
@property (nonatomic, strong) UIColor* dataPointBackgroundColor;
@property (nonatomic) CGFloat dataPointRadius;

// Grid parameters
@property (nonatomic) BOOL drawInnerGrid;
@property (nonatomic, strong) UIColor* innerGridColor;
@property (nonatomic) CGFloat innerGridLineWidth;

// Smoothing
@property (nonatomic) BOOL bezierSmoothing;
@property (nonatomic) CGFloat bezierSmoothingTension;

// Animations
@property (nonatomic) CGFloat animationDuration;

@property (nonatomic, strong) NSArray *xData;
@property (nonatomic, assign) CGFloat maxValue; // 最大值顶部

@property (nonatomic, copy) NSString *unitX; // 横坐标单位后缀
@property (nonatomic, copy) NSString *unitY; // 纵坐标单位后缀

@property (nonatomic, strong) NSArray *standValues; // 预设值

// Set the actual data for the chart, and then render it to the view.
- (void)setChartData:(NSArray *)chartData;

// Clear all rendered data from the view.
- (void)clearChartData;

// Get the bounds of the chart
- (CGFloat)minVerticalBound;
- (CGFloat)maxVerticalBound;

@end
