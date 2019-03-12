//
//  MJRefreshLottieFooter.h
//  YZFFServer
//
//  Created by Kelvin on 2018/12/24.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import "MJRefreshBackStateFooter.h"
#import <Lottie/Lottie.h>
@interface MJRefreshLottieFooter : MJRefreshBackStateFooter
@property (weak, nonatomic, readonly) LOTAnimationView *lotView;
@end
