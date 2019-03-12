//
//  MJRefreshLottieHeader.m
//  YZFFServer
//
//  Created by Lam BG on 2018/11/22.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import "MJRefreshLottieHeader.h"

@implementation MJRefreshLottieHeader {
    
    __unsafe_unretained LOTAnimationView *_lotView;
}

#pragma mark - 重写父类的方法

- (void)placeSubviews {
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
//    if (!self.stateLabel.hidden) {
//        CGFloat stateWidth = self.stateLabel.mj_textWith;
//        CGFloat timeWidth = 0.0;
//        if (!self.lastUpdatedTimeLabel.hidden) {
//            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
//        }
//        CGFloat textWidth = MAX(stateWidth, timeWidth);
//        arrowCenterX -= textWidth / 2 + self.labelLeftInset;
//    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    self.lotView.center = arrowCenter;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.state != MJRefreshStateIdle) return;
                [self.lotView stop];
            });
        }else{
            [self.lotView stop];
        }
    } else if (state == MJRefreshStatePulling) {
        
        [self.lotView play];
    } else if (state == MJRefreshStateRefreshing) {
        
        [self.lotView play];
    }
}

#pragma mark - getter

- (LOTAnimationView *)lotView {
    
    if (_lotView == nil) {
        
        LOTAnimationView *lotView = [LOTAnimationView animationNamed:@"common_loading" inBundle:[YZServerBundle bundle]];
        lotView.loopAnimation = YES;
        // zy & gx 讨论确定 65
        lotView.mj_size = CGSizeMake(44, 44);
        [self addSubview:_lotView = lotView];
    }
    
    return _lotView;
}

@end
