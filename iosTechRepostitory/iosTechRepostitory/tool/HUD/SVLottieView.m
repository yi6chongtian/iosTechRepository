//
//  SVLottieView.m
//  YZFFServer
//
//  Created by Lam BG on 2018/11/23.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import "SVLottieView.h"

#import "UIView+Frame.h"

#import <Lottie/Lottie.h>

@interface SVLottieView ()

@property (nonatomic, strong) LOTAnimationView *lotView;

@end

@implementation SVLottieView

- (void)willMoveToSuperview:(UIView*)newSuperview {
    if (newSuperview) {
        [self addSubview:self.lotView];
    } else {
        if (_lotView.isAnimationPlaying) {
            [_lotView stop];
        }
        [_lotView removeFromSuperview];
        _lotView = nil;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)startAnimating {
    
    if (!self.lotView.isAnimationPlaying) {
        CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
        [self.lotView setPosition:center atAnchorPoint:CGPointMake(.5, .5)];
        [self.lotView play];
    }
}

- (void)stopAnimating {
    if (self.lotView.isAnimationPlaying) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.lotView stop];
        });
    }
}

#pragma mark - getter

- (LOTAnimationView *)lotView {
    
    if (_lotView == nil) {
        
//        _lotView = [LOTAnimationView animationNamed:@"common_loading" inBundle:[YZServerBundle bundle]];
        _lotView = [LOTAnimationView animationNamed:@"comon_test" inBundle:[YZServerBundle bundle]];
        _lotView.loopAnimation = YES;
        _lotView.frame = CGRectMake(0, 0, 48, 48);
    }
    
    return _lotView;
}

@end
