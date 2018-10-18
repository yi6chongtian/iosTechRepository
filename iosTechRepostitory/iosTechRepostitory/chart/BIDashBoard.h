//
//  BIDashBoard.h
//  Chart
//  仪表盘
//  Created by tangzhibiao on 2018/10/17.
//  Copyright © 2018年 tangzhibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDashBoard : UIView

@property (nonatomic,assign) CGFloat lineWidth;

@property (nonatomic,strong) UIColor *dashBgColor;

@property (nonatomic,strong) UIColor *dashColor;

/* 转动的角度:0到M_PI */
@property (nonatomic,assign) CGFloat angle;


@end
