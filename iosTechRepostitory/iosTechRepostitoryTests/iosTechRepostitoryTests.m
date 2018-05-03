//
//  iosTechRepostitoryTests.m
//  iosTechRepostitoryTests
//
//  Created by tang on 2018/1/14.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AFNetworking.h"
#import "TZBNetRequest.h"
#import "PrefixHeader.pch"
#import "User.h"
#import "YZFMDB.h"
#import "Student.h"

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

#pragma mark -  fmdb

- (void)testCreateTable{
    BOOL flag = [[YZFMDB shareDB] createTable:[User class]];//[User createTable];
    XCTAssertTrue(flag);
    flag = [[YZFMDB shareDB] createTable:[Student class]];
    XCTAssertTrue(flag);
}

- (void)testInsert{
    User *user0 = [User new];
    user0.name = @"tang";
    user0.height = 1.80;
    user0.idcard = @"eegggg";
    BOOL flag = [[YZFMDB shareDB] insertRecord:user0];
    
    Student *s = [Student new];
    s.className = @"yiban";
    s.studtentName = @"tang";
    s.teacher = @"miss";
    s.height = 1.80;
    flag = [[YZFMDB shareDB] insertRecord:s];
    XCTAssertTrue(flag);
}

- (void)testUpdate{
    User *user = [[YZFMDB shareDB] getAllData:[User class]][0];
    user.name = @"junxi";
    user.idcard = @"40";
    user.height = 1.90;
    BOOL flag = [[YZFMDB shareDB] updateRecord:user];
    XCTAssertTrue(flag);
    
    Student *student =  [[YZFMDB shareDB] getAllData:[Student class]][0];
    NSString *prestudentname = student.studtentName;
    NSString *preclassnem = student.className;
    student.teacher = @"teacher";
    student.height = 2.0;
    flag = [[YZFMDB shareDB] updateRecord:student];
    XCTAssertTrue(flag);
    
    student.className = @"classname";
    student.studtentName = @"studentn";
    flag = [[YZFMDB shareDB] updateRecord:student where:[NSString stringWithFormat:@"where %@ = '%@' and className = '%@'",@"studtentName",prestudentname,preclassnem]];
    XCTAssertTrue(flag);
    
    
    
    
}

- (void)testDelete{
    User *user = [[YZFMDB shareDB] getAllData:[User class]][0];
    BOOL flag = [[YZFMDB shareDB] removeRecord:user];
    XCTAssertTrue(flag);
    
    Student *student = [[YZFMDB shareDB] getAllData:[Student class]][0];
    flag = [[YZFMDB shareDB] removeRecord:student];
    XCTAssertTrue(flag);
}

- (void)testTransaction{
    YZFMDB *db = [YZFMDB shareDB];
    //    __block NSArray *arr = nil;
    [db yz_inTransaction:^(BOOL *rollback) {
        User *user0 = [User new];
        user0.name = @"tang";
        user0.height = 1.80;
        user0.idcard = @"eegggg";
        BOOL flag = [[YZFMDB shareDB] insertRecord:user0];
        
        Student *s = [Student new];
        s.className = @"yiban";
        s.studtentName = @"tang";
        s.teacher = @"miss";
        s.height = 1.80;
        flag = [[YZFMDB shareDB] insertRecord:s];
        XCTAssertTrue(flag);
        
        //        *rollback = YES;
        
        
        
    }];
    
    XCTAssertTrue([[YZFMDB shareDB] getAllData:[User class]].count == 1);
    XCTAssertTrue([[YZFMDB shareDB] getAllData:[Student class]].count == 1);
    
}

#pragma mark - api调用
//- (void)testNetRequestWithGet1{
//    TZBNetRequest *netRequest = [TZBNetRequest requestGetWithUrlString:@"https://api.douban.com//v2/movie/in_theaters" params:nil successBlock:^(NSInteger errCode, id responseObject) {
//        if([responseObject isKindOfClass:[NSData class]]){
//            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",string);
//        }
//        NSLog(@"%@",responseObject);
//    } failureBlock:^(NSError *error) {
//        NSLog(error);
//    }];
//    //netRequest.responseSerializerType = TZBResponseSerializerTypeHTTP;
//    [netRequest startRequest];
//}
//
//- (void)testNetRequestWithGet2{
//    TZBNetRequest *netRequest = [TZBNetRequest requestGetWithUrlString:@"https://www.zhibo8.cc" params:nil successBlock:^(NSInteger errCode, id responseObject) {
//        if([responseObject isKindOfClass:[NSData class]]){
//            NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",string);
//        }else{
//            NSLog(@"%@",responseObject);
//        }
//    } failureBlock:^(NSError *error) {
//        NSLog(error);
//    }];
//    netRequest.responseSerializerType = TZBResponseSerializerTypeHTTP;
//    [netRequest startRequest];
//}
//
//
///**
// 上传文件不带进度
// */
//- (void)testNetRequestWithUpload1{
//    TZBNetRequest *netRequest = [[TZBNetRequest alloc] init];
//    netRequest.method = TZBRequestMethodPost;
//    netRequest.url = @"http://134.343.1.1:8000/index.php/Api/User/upload_user_avatar";
//    netRequest.successBlock = ^(NSInteger errCode, id responseObject) {
//        
//    };
//    netRequest.failureBlock = ^(NSError *error) {
//        
//    };
//    netRequest.constructingBodyBlock = ^(id<AFMultipartFormData> data) {
//        //添加文件信息
//        [data appendPartWithFileData:[NSData data] name:@"file" fileName:@"fff.png" mimeType:@"image/png/jpg/jpeg"];
//        //添加文字信息
//        [data appendPartWithFormData:[@"tang" dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
//    };
//    [netRequest startRequest];
//}
//
//
///**
// 上传文件带进度
// */
//- (void)testNetRequestWithUpload2{
//    TZBNetRequest *netRequest = [[TZBNetRequest alloc] init];
//    netRequest.method = TZBRequestMethodPost;
//    netRequest.url = @"http://134.343.1.1:8000/index.php/Api/User/upload_user_avatar";
//    netRequest.successBlock = ^(NSInteger errCode, id responseObject) {
//        
//    };
//    netRequest.failureBlock = ^(NSError *error) {
//        
//    };
//    netRequest.constructingBodyBlock = ^(id<AFMultipartFormData> data) {
//        //添加文件信息
//        [data appendPartWithFileData:[NSData data] name:@"file" fileName:@"fff.png" mimeType:@"image/png/jpg/jpeg"];
//        //添加文字信息
//        [data appendPartWithFormData:[@"tang" dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
//    };
//    netRequest.uploadProgressBlock = ^(NSProgress *process) {
//         NSLog(@"progress:%lld,%lld,%f", process.totalUnitCount, process.completedUnitCount, process.fractionCompleted);
//    };
//    [netRequest startRequest];
//}
//
//- (void)testNetRequestWithDownLoadFile{
//    TZBNetRequest *netRequest = [TZBNetRequest requestGetWithUrlString:@"http://134.343.1.1:8000/index.php/Api/User/123.mp4" params:nil successBlock:NULL failureBlock:NULL];
//    netRequest.downloadProgressBlock = ^(NSProgress *progress) {
//        
//    };
//    netRequest.downloadDestinationBlock = ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//    };
//    netRequest.downloadCompletionBlock = ^(NSURLResponse *response, NSURL *filepath, NSError *error) {
//        
//    };
//    [netRequest startRequest];
//}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
