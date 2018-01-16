//
//  ZJQRCodeScanner.m
//  QRCoderWinthSystem
//
//  Created by quiet on 15/6/8.
//  Copyright (c) 2015年 zhang jian. All rights reserved.
//

#import "ZJQRCodeScanner.h"

@implementation ZJQRCodeScanner
+(instancetype)sharedInstance
{
    static ZJQRCodeScanner *scanner = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanner = [[ZJQRCodeScanner alloc] init];
    });
    return scanner;
}

-(void)scanFromView:(UIView *)view result:(void (^)(NSString *resultString))result;
{
    // 1. 摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2. 设置输入
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        return;
    }
    
    // 3. 设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.1 设置输出的代理
    // 说明：使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //    [output setMetadataObjectsDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    // 4. 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:output];
    // 4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！(所有类型)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode]];
//    [output setRectOfInterest:CGRectMake((90+64)/SCREEN_HEIGHT, (SCREEN_WIDTH-300)/2.0/SCREEN_WIDTH, 300.0/SCREEN_HEIGHT, 300.0/SCREEN_WIDTH)];
  //  [output setRectOfInterest:CGRectMake(0.16,0.15, 0.4, 0.7)];  // 中间 1/4 屏幕
    [output setRectOfInterest:CGRectMake((SCREEN_HEIGHT * 0.5 - 100) / SCREEN_HEIGHT, (SCREEN_WIDTH * 0.5 - 100)  / SCREEN_WIDTH, 200 / SCREEN_HEIGHT, 200 / SCREEN_WIDTH)];
    // 5. 设置预览图层（用来让用户能够看到扫描情况）
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // 5.1 设置preview图层的属性
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 5.2 设置preview图层的大小
    [preview setFrame:view.bounds];
    // 5.3 将图层添加到视图的图层
    [view.layer insertSublayer:preview atIndex:0];
    self.previewLayer = preview;
    
    // 6. 启动会话
    [session startRunning];
    
    //保存session, 为了停止
    self.session = session;
    
    //设置回调
    self.result = result;

}
#pragma mark - 输出代理方法
// 此方法是在识别到QRCode，并且完成转换
// 如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 会频繁的扫描，调用代理方法
    // 1. 如果扫描完成，停止会话
    [self.session stopRunning];
    // 2. 删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"%@", metadataObjects);
    // 3. 设置界面显示扫描结果
    
    NSString *resultString = nil;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        // 提示：如果需要对url或者名片等信息进行扫描，可以在此进行扩展！
        //_captureLabel.text = obj.stringValue;
        //NSLog(@"obj.stringValue = %@",obj.stringValue);
        resultString = obj.stringValue;
        
    }
    if(self.result)
    {
        self.result(resultString);
    }
}



@end
