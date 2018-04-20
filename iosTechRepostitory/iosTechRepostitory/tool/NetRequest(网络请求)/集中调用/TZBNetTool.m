//
//  TZBNetTool.m
//  iosTechRepostitory
//
//  Created by tang on 2018/4/11.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "TZBNetTool.h"

@implementation TZBNetTool

+ (BOOL)useHttpsAuth{
    return NO;
}

+(AFSecurityPolicy *)customerSecurityPolicy{
    return nil;
    
//    //先导入证书到项目
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:kCertificateName ofType:@"cer" inDirectory:@"HttpsServerAuth.bundle"];//证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    
//    DLog(@"%@--%@", cerPath, cerData);
//    
//    //AFSSLPinningModeCertificate使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    
//    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    //如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = YES;
//    
//    //validatesDomainName 是否需要验证域名，默认为YES；
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = YES;
//    
//    //validatesCertificateChain 是否验证整个证书链，默认为YES
//    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
//    //GeoTrust Global CA
//    //    Google Internet Authority G2
//    //        *.google.com
//    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
//    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
//    //    securityPolicy.validatesCertificateChain = NO;
//    
//    NSSet *cerDataSet = [NSSet setWithArray:@[cerData]];
//    securityPolicy.pinnedCertificates = cerDataSet;
//    
//    return securityPolicy;
}

+ (NSURLSessionDataTask *)getWithUrlString:(NSString *)url params:(NSDictionary *)params downloadProgress:(void (^)(NSProgress *))downloadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //设置ssl
    if([self useHttpsAuth]){
        [mgr setSecurityPolicy:[self customerSecurityPolicy]];
    }
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求头
//    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/html",nil];
    NSURLSessionDataTask *task = [mgr GET:url parameters:params progress:downloadProgress success:success failure:failure];
    return task;
    
}

+ ( NSURLSessionDataTask *)postWithUrlString:(NSString *)url params:(NSDictionary *)params uploadProgress:(void (^)(NSProgress *))uploadProgress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //设置ssl
    if([self useHttpsAuth]){
        [mgr setSecurityPolicy:[self customerSecurityPolicy]];
    }
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求头
    //    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/html",nil];
    NSURLSessionDataTask *task = [mgr POST:url parameters:params progress:uploadProgress success:success failure:failure];
    return task;
}

@end
