//
//  TZBNetTool.h
//  iosTechRepostitory
//  直接调用AFN方法，返回dataTask,设置参数后直接起飞
//  缺点：缺少灵活性，如设置请求/响应的序列化格式、 设置超时时间、缓存策略、取消请求、判断网络条件、自定义请求头等
//  Created by tang on 2018/4/11.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TZBNetTool : NSObject

+ (NSURLSessionDataTask *)getWithUrlString:(NSString *)url params:(NSDictionary *)params downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgress success:(void (^)(NSURLSessionDataTask *task,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (NSURLSessionDataTask *)postWithUrlString:(NSString *)url params:(NSDictionary *)params uploadProgress:(void (^)(NSProgress *uploadProgress))uploadProgress success:(void (^)(NSURLSessionDataTask *task,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

@end
