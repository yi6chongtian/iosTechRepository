//
//  MJRefreshLottieFooter.m
//  YZFFServer
//
//  Created by Kelvin on 2018/12/24.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import "MJRefreshLottieFooter.h"

@implementation MJRefreshLottieFooter {
    
    __unsafe_unretained LOTAnimationView *_lotView;
}

#pragma mark - 重写父类的方法

- (void)placeSubviews {
    [super placeSubviews];
    
    CGFloat arrowCenterX = self.mj_w * 0.5;
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    self.lotView.center = arrowCenter;
    
    self.stateLabel.textColor = kColorWithHex(0x90FFBE);
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == MJRefreshStateNoMoreData) {
        return;
    }

    // 上拉加载，松开立即触发刷新
    if (self.scrollView.isDragging) {
        // 转为即将刷新状态
        self.state = MJRefreshStatePulling;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    [self.lotView setHidden:NO];
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
    }else if (state == MJRefreshStateNoMoreData) {
        
        [self.lotView stop];
        [self.lotView setHidden:YES];
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
