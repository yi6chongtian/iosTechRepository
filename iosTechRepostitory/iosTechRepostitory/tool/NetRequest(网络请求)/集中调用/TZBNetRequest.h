//
//  TZBNetRequest.h
//  iosTechRepostitory
//
//  Created by tang on 2018/4/10.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZBNetRequestCallback.h"

NS_ASSUME_NONNULL_BEGIN


/**
 请求方法

 - TZBRequestMethodGet: <#TZBRequestMethodGet description#>
 - TZBRequestMethodPost: <#TZBRequestMethodPost description#>
 */
typedef NS_ENUM(NSInteger,TZBRequestMethod){
    TZBRequestMethodGet,
    TZBRequestMethodPost
};


/**
 请求体序列化方式

 - TZBRequestSerializerTypeHTTP: 二进制
 - TZBRequestSerializerTypeJSON: JSON
 */
typedef NS_ENUM(NSInteger,TZBRequestSerializerType){
    TZBRequestSerializerTypeHTTP,
    TZBRequestSerializerTypeJSON
};


/**
 响应数据序列化方式

 - TZBResponseSerializerTypeHTTP: 二进制
 - TZBResponseSerializerTypeJSON: JSON
 - TZBResponseSerializerTypeXMLParser: XML
 */
typedef NS_ENUM(NSInteger,TZBResponseSerializerType){
    TZBResponseSerializerTypeHTTP,
    TZBResponseSerializerTypeJSON,
    TZBResponseSerializerTypeXMLParser
};





@interface TZBNetRequest : NSObject

@property (nonatomic,assign) TZBRequestMethod method;

@property (nonatomic,strong) NSString *url;

@property (nonatomic,strong) NSDictionary *params;

@property (nonatomic,assign) TZBRequestSerializerType requestSerializerType;

@property (nonatomic,assign) TZBResponseSerializerType responseSerializerType;

@property (nonatomic,strong) NSDictionary *headerFields;

@property (nonatomic,assign) NSTimeInterval timeOutInterval;

@property (nonatomic,copy)  TZBNetRequestSuccessBlock successBlock;

@property (nonatomic,copy)  TZBNetRequestFailBlock failureBlock;
/**
 上传文件的block
 */
@property (nonatomic,copy)  AFConstructingBodyBlock constructingBodyBlock;
/**
 上传文件进度
 */
@property (nonatomic,copy)  AFURLSessionTaskProgressBlock uploadProgressBlock;

@property (nonatomic,assign) BOOL isDownLoadFile;

@property (nonatomic,copy) AFDownloadProgressBlock downloadProgressBlock;

@property (nonatomic,copy) AFDownloadDestinationBlock downloadDestinationBlock;

@property (nonatomic,copy) AFDownloadCompletionBlock downloadCompletionBlock;

@property (nonatomic,assign) BOOL shouldCache;

@property (nonatomic,assign) BOOL showHUD;

@property (nonatomic,assign) BOOL allowCellularAccess;

- (instancetype)initWithMethod:(TZBRequestMethod)method url:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock;

- (instancetype)initGetWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock;

+ (instancetype)requestGetWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock;

- (instancetype)initPostWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock;

+ (instancetype)requestPostWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock;

- (instancetype)initWithDownloadFileWithUrlString:(NSString *)url params:(NSDictionary *)params downloadProgressBlock:(AFDownloadProgressBlock)downloadProgressBlock downloadDestinationBlock:(AFDownloadDestinationBlock)downloadDestinationBlock downloadCompleteBlock:(AFDownloadCompletionBlock)downloadCompleteBlock;

- (void)startRequest;

- (void)cancleRequest;




@end

NS_ASSUME_NONNULL_END
