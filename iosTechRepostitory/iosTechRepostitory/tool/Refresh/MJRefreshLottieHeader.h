//
//  MJRefreshLottieHeader.h
//  YZFFServer
//
//  Created by Lam BG on 2018/11/22.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#import "MJRefreshStateHeader.h"

#import <Lottie/Lottie.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJRefreshLottieHeader : MJRefreshHeader

@property (weak, nonatomic, readonly) LOTAnimationView *lotView;

@end

NS_ASSUME_NONNULL_END
