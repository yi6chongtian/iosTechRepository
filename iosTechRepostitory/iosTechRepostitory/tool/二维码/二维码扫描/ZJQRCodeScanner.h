//
//  ZJQRCodeScanner.h
//  QRCoderWinthSystem
//
//  Created by quiet on 15/6/8.
//  Copyright (c) 2015年 zhang jian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ZJQRCodeScanner : NSObject<AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic) AVCaptureDevice * device;
@property (strong,nonatomic) AVCaptureDeviceInput * input;
@property (strong,nonatomic) AVCaptureMetadataOutput * output;
@property (strong,nonatomic) AVCaptureSession * session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * previewLayer;
@property (nonatomic, retain) UIImageView * line;

+(instancetype)sharedInstance;
@property (copy,nonatomic) void (^result)(NSString *resultString);
-(void)scanFromView:(UIView *)view result:(void (^)(NSString *resultString))result;
@end
