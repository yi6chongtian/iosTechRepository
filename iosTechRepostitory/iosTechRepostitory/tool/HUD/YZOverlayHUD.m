//
// Created by chengang on 2018/8/16.
// Copyright (c) 2018 laihj. All rights reserved.
//

#import "YZOverlayHUD.h"
#import "SVProgressHUD.h"
#import "UIFont+KWSFontKit.h"

#define YZHUD_Delay 1.5F
#define cornerRadius 3.0

static SVProgressHUDShowCompletion _c;
static CGFloat kMinimumDismissTimeInterval = 1.5;
static CGFloat kMaximumDismissTimeInterval = 3.0;

@class YZOverlayProgressHUD;
static YZOverlayProgressHUD *sHud;


@interface SVProgressHUD (Protect)

@property (nonatomic, strong) UILabel *statusLabel;
+ (SVProgressHUD*)sharedView;

@end

@interface YZOverlayProgressHUD : SVProgressHUD

@end

@implementation YZOverlayProgressHUD

+ (SVProgressHUD*)sharedView {
    return sHud;
}

@end

@interface YZOverlayHUD()

@property(nonatomic, strong) YZOverlayProgressHUD *hud;

@end

@implementation YZOverlayHUD {

}

- (instancetype)init {
#if !defined(SV_APP_EXTENSIONS)
    self.hud = [[YZOverlayProgressHUD alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
#else
    self.hud = [[YZOverlayProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif

    [self hudAppearance];

    return self;
}

-(void)hudAppearance {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wnonnull"
    [self.hud setInfoImage:nil];
    [self.hud setMinimumSize:CGSizeMake(40, 40)];
    [self.hud setCornerRadius:cornerRadius];
    [self.hud setDefaultStyle:SVProgressHUDStyleDark];
    [self.hud setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self.hud setBackgroundColor:[UIColor colorWithHex:@"000000" andAlpha:0.7]];
    [self.hud setForegroundColor:[UIColor colorWithHex:@"FFFFFF" andAlpha:1.0]];
    [self.hud setFont:[UIFont PingFangSC_RegularWithSize:14.0]];
    [self.hud setMinimumDismissTimeInterval:kMinimumDismissTimeInterval];
    [self.hud setMaximumDismissTimeInterval:kMaximumDismissTimeInterval];
    [self.hud setOffsetFromCenter:UIOffsetMake(0, -20)];
#pragma clang diagnostic pop
}

- (void)refresh {
    sHud = self.hud;
}

- (void)checkDefaultHudShowedText:(NSString *)text cb:(void(^)(bool showed))cb {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.2),
    dispatch_get_main_queue(), ^{
        cb([SVProgressHUD isVisible]);
    });
}

- (void)showWithStatus:(nullable NSString *)status {
    if (!status || !status.length) {
        return;
    }
    @weakify(self);
    [self checkDefaultHudShowedText:status cb:^(bool showed) {
        @strongify(self);
        if (!showed) {
            [self refresh];
            [YZOverlayProgressHUD showInfoWithStatus:status];
        }
    }];
}

- (void)setStatus:(nullable NSString *)status {
    if (!status || !status.length) {
        return;
    }
    @weakify(self);
    [self checkDefaultHudShowedText:status cb:^(bool showed) {
        @strongify(self);
        if (!showed) {
            [self refresh];
            [YZOverlayProgressHUD setStatus:status];
        }
    }];
}

- (void)showInfoWithStatus:(nullable NSString *)status {
    if (!status || !status.length) {
        return;
    }
    @weakify(self);
    [self checkDefaultHudShowedText:status cb:^(bool showed) {
        @strongify(self);
        if (!showed) {
            [self refresh];
            [YZOverlayProgressHUD showInfoWithStatus:status];
        }
    }];
}

- (void)showSuccessWithStatus:(nullable NSString *)status {
    if (!status || !status.length) {
        return;
    }
    @weakify(self);
    [self checkDefaultHudShowedText:status cb:^(bool showed) {
        @strongify(self);
        if (!showed) {
            [self refresh];
            [YZOverlayProgressHUD showInfoWithStatus:status];
        }
    }];
}

- (void)showErrorWithStatus:(nullable NSString *)status {
    if (!status || !status.length ||
        [status isEqualToString:@"success"] ||
        [status isEqualToString:@"SUCCESS"]) {
        return;
    }

    @weakify(self);
    [self checkDefaultHudShowedText:status cb:^(bool showed) {
        @strongify(self);
        if (!showed) {
            [self refresh];
            [YZOverlayProgressHUD showErrorWithStatus:status];
        }
    }];
}

@end
