//
//  iosTechRepostitoryTests.m
//  iosTechRepostitoryTests
//
//  Created by tang on 2018/1/14.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TZBNetRequest.h"
#import "PrefixHeader.pch"

@interface iosTechRepostitoryTests : XCTestCase

@end

@implementation iosTechRepostitoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testNetRequestWithGet1{
    TZBNetRequest *netRequest = [TZBNetRequest requestGetWithUrlString:@"https://api.douban.com//v2/movie/in_theaters" params:nil successBlock:^(NSInteger errCode, id responseObject) {
        if([responseObject isKindOfClass:[NSData class]]){
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        }
        NSLog(@"%@",responseObject);
    } failureBlock:^(NSError *error) {
        NSLog(error);
    }];
    //netRequest.responseSerializerType = TZBResponseSerializerTypeHTTP;
    [netRequest startRequest];
}

- (void)testNetRequestWithGet2{
    TZBNetRequest *netRequest = [TZBNetRequest requestGetWithUrlString:@"https://www.zhibo8.cc" params:nil successBlock:^(NSInteger errCode, id responseObject) {
        if([responseObject isKindOfClass:[NSData class]]){
            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        }else{
            NSLog(@"%@",responseObject);
        }
    } failureBlock:^(NSError *error) {
        NSLog(error);
    }];
    netRequest.responseSerializerType = TZBResponseSerializerTypeHTTP;
    [netRequest startRequest];
}


/**
 上传文件不带进度
 */
- (void)testNetRequestWithUpload1{
    TZBNetRequest *netRequest = [[TZBNetRequest alloc] init];
    netRequest.method = TZBRequestMethodPost;
    netRequest.url = @"http://134.343.1.1:8000/index.php/Api/User/upload_user_avatar";
    netRequest.successBlock = ^(NSInteger errCode, id responseObject) {
        
    };
    netRequest.failureBlock = ^(NSError *error) {
        
    };
    netRequest.constructingBodyBlock = ^(id<AFMultipartFormData> data) {
        //添加文件信息
        [data appendPartWithFileData:[NSData data] name:@"file" fileName:@"fff.png" mimeType:@"image/png/jpg/jpeg"];
        //添加文字信息
        [data appendPartWithFormData:[@"tang" dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
    };
    [netRequest startRequest];
}


/**
 上传文件带进度
 */
- (void)testNetRequestWithUpload2{
    TZBNetRequest *netRequest = [[TZBNetRequest alloc] init];
    netRequest.method = TZBRequestMethodPost;
    netRequest.url = @"http://134.343.1.1:8000/index.php/Api/User/upload_user_avatar";
    netRequest.successBlock = ^(NSInteger errCode, id responseObject) {
        
    };
    netRequest.failureBlock = ^(NSError *error) {
        
    };
    netRequest.constructingBodyBlock = ^(id<AFMultipartFormData> data) {
        //添加文件信息
        [data appendPartWithFileData:[NSData data] name:@"file" fileName:@"fff.png" mimeType:@"image/png/jpg/jpeg"];
        //添加文字信息
        [data appendPartWithFormData:[@"tang" dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
    };
    netRequest.uploadProgressBlock = ^(NSProgress *process) {
         NSLog(@"progress:%lld,%lld,%f", process.totalUnitCount, process.completedUnitCount, process.fractionCompleted);
    };
    [netRequest startRequest];
}

- (void)testNetRequestWithDownLoadFile{
    TZBNetRequest *netRequest = [TZBNetRequest requestGetWithUrlString:@"http://134.343.1.1:8000/index.php/Api/User/123.mp4" params:nil successBlock:NULL failureBlock:NULL];
    netRequest.downloadProgressBlock = ^(NSProgress *progress) {
        
    };
    netRequest.downloadDestinationBlock = ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
    };
    netRequest.downloadCompletionBlock = ^(NSURLResponse *response, NSURL *filepath, NSError *error) {
        
    };
    [netRequest startRequest];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
