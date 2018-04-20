//
//  TZBNetRequest.m
//  iosTechRepostitory
//
//  Created by tang on 2018/4/10.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "TZBNetRequest.h"
#import "Reachability.h"

@interface TZBNetRequest()
{
    AFHTTPSessionManager *_sessionMgr;
    NSURLSessionTask *_requestTask;
    BOOL _networkIsError;
}

//@property (nonatomic,strong) AFHTTPSessionManager *sessionMgr;

@end

@implementation TZBNetRequest

- (void)dealloc{
     NSLog(@"%s",__func__);
}

#pragma mark - 初始化

- (instancetype)init{
    self = [super init];
    if(self){
        [self initProperties];
        [self initHtttpSessionManager];
    }
    return self;
}

- (void)initProperties{
    self.method = TZBRequestMethodGet;
    self.requestSerializerType = TZBRequestSerializerTypeJSON;
    self.responseSerializerType = TZBResponseSerializerTypeJSON;
    self.timeOutInterval = 30;
    self.shouldCache = NO;
    self.allowCellularAccess = YES;
    self.isDownLoadFile = NO;
}

- (void)initHtttpSessionManager{
    _sessionMgr = [AFHTTPSessionManager manager];
    _sessionMgr.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionMgr.responseSerializer = [AFJSONResponseSerializer serializer];
    _sessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/html",nil];
    //设置https证书
    if (kOpenHttpsAuth) {
        [_sessionMgr setSecurityPolicy:[self customSecurityPolicy]];
    }
}

- (instancetype)initWithMethod:(TZBRequestMethod)method url:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock{
    if(self = [self init]){
        self.method = method;
        self.url = url;
        self.params = params;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
    }
    return self;
}

- (instancetype)initGetWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock{
    return [self initWithMethod:TZBRequestMethodGet url:url params:params successBlock:successBlock failureBlock:failureBlock];
}

+ (instancetype)requestGetWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock{
    return [[[self class] alloc] initGetWithUrlString:url params:params successBlock:successBlock failureBlock:failureBlock];
}

- (instancetype)initPostWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock{
    return [self initWithMethod:TZBRequestMethodPost url:url params:params successBlock:successBlock failureBlock:failureBlock];
}

+ (instancetype)requestPostWithUrlString:(NSString *)url params:(NSDictionary *)params successBlock:(TZBNetRequestSuccessBlock)successBlock failureBlock:(TZBNetRequestFailBlock)failureBlock{
    return [[[self class] alloc] initPostWithUrlString:url params:params successBlock:successBlock failureBlock:failureBlock];
}

- (instancetype)initWithDownloadFileWithUrlString:(NSString *)url params:(NSDictionary *)params downloadProgressBlock:(AFDownloadProgressBlock)downloadProgressBlock downloadDestinationBlock:(AFDownloadDestinationBlock)downloadDestinationBlock downloadCompleteBlock:(AFDownloadCompletionBlock)downloadCompleteBlock{
    TZBNetRequest *request = [self initWithMethod:TZBRequestMethodGet url:url params:params successBlock:NULL failureBlock:NULL];
    request.downloadProgressBlock = downloadProgressBlock;
    request.downloadDestinationBlock = downloadDestinationBlock;
    request.downloadCompletionBlock = downloadCompleteBlock;
    request.isDownLoadFile = YES;
    return request;
}

- (void)startRequest{
    //判断网络是否可用
    _networkIsError = [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus] == NotReachable ? YES : NO;
    if (_networkIsError) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"网络连接暂时不可用", @"")];
        });
        return;
    }
    
    AFHTTPRequestSerializer *requestSerializer = [self constructRequestSerializer];
    AFHTTPResponseSerializer *responseSerializer = [self constructResponseSerializer];
    _sessionMgr.responseSerializer = responseSerializer;
    
    NSError *error = nil;
    NSURLSessionTask *requstTask = nil;
    switch (self.method) {
        case TZBRequestMethodGet: {
            requstTask = [self dataTaskWithHttpMethod:@"GET" requestSerializer:requestSerializer urlString:self.url params:self.params uploadProgress:NULL downloadProgress:self.downloadProgressBlock constructingBodyWithBlock:NULL error:&error];
        } break;
        case TZBRequestMethodPost: {
            requstTask = [self dataTaskWithHttpMethod:@"POST" requestSerializer:requestSerializer urlString:self.url params:self.params uploadProgress:self.uploadProgressBlock downloadProgress:NULL constructingBodyWithBlock:self.constructingBodyBlock error:&error];
        } break;
    }
    
    _requestTask = requstTask;

    if(self.showHUD){
        
    }
    
    [_requestTask resume];
    
}

- (void)cancleRequest{
    
}

- (AFHTTPRequestSerializer *)constructRequestSerializer{
    //构造请求
    AFHTTPRequestSerializer *requestSerializer = nil;
    switch (self.requestSerializerType) {
        case TZBRequestSerializerTypeHTTP:
            requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case TZBRequestSerializerTypeJSON:
            requestSerializer = [AFJSONRequestSerializer serializer];
        default:
            break;
    }
    requestSerializer.timeoutInterval = self.timeOutInterval;
    requestSerializer.allowsCellularAccess = self.allowCellularAccess;
    //请求头
    if(self.headerFields != nil && self.headerFields.count > 0){
        for (NSString *key in self.headerFields.allKeys) {
            NSString *value = self.headerFields[key];
            [requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)constructResponseSerializer{
    AFHTTPResponseSerializer *serializer = nil;
    switch (self.responseSerializerType) {
        case TZBResponseSerializerTypeHTTP:
            serializer = [AFHTTPResponseSerializer serializer];
            break;
         case TZBResponseSerializerTypeJSON:
            serializer = [AFJSONResponseSerializer serializer];
            break;
        case TZBResponseSerializerTypeXMLParser:
            serializer = [AFXMLParserResponseSerializer serializer];
        default:
            break;
    }
    return serializer;
}

- (NSURLSessionTask *)dataTaskWithHttpMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       urlString:(NSString *)urlString
                                          params:(NSDictionary *)params
                                  uploadProgress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgress
                       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))constructBlock
                                           error:(NSError **)error{
    NSMutableURLRequest *request = nil;
    if(constructBlock){
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:urlString parameters:params constructingBodyWithBlock:constructBlock error:error];
    }else{
        request = [requestSerializer requestWithMethod:method URLString:urlString parameters:params error:error];
    }
    __block NSURLSessionTask *dataTask = nil;
    if(self.isDownLoadFile){
        dataTask = [_sessionMgr downloadTaskWithRequest:request progress:downloadProgress destination:self.downloadDestinationBlock completionHandler:self.downloadCompletionBlock];
    }else{
        dataTask = [_sessionMgr dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self handleRequestResult:dataTask response:response responseObject:responseObject error:error];
        }];
    }
   
    return dataTask;
}

- (void)handleRequestResult:(NSURLSessionTask *)dataTask
                   response:(NSURLResponse *)response
             responseObject:(id)responseObject
                      error:(NSError *)error{
    if(error){
        NSString *errString = error.localizedFailureReason;
        if(self.failureBlock){
            self.failureBlock(error);
        }
    }else{
        if(self.successBlock){
            self.successBlock(0, responseObject);
        }
    }
}

#pragma mark - Get Post Put Del


- (AFSecurityPolicy *)customSecurityPolicy {
    //先导入证书到项目
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:kCertificateName ofType:@"cer" inDirectory:@"HttpsServerAuth.bundle"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    DLog(@"%@--%@", cerPath, cerData);
    
    //AFSSLPinningModeCertificate使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    
    //validatesCertificateChain 是否验证整个证书链，默认为YES
    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
    //GeoTrust Global CA
    //    Google Internet Authority G2
    //        *.google.com
    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
    //    securityPolicy.validatesCertificateChain = NO;
    
    NSSet *cerDataSet = [NSSet setWithArray:@[cerData]];
    securityPolicy.pinnedCertificates = cerDataSet;
    
    return securityPolicy;
}



#pragma mark - Getter Setter


@end
