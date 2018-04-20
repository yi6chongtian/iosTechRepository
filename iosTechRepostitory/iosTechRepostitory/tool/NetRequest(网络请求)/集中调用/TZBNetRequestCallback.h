//
//  TZBNetRequestCallback.h
//  iosTechRepostitory
//
//  Created by tang on 2018/4/11.
//  Copyright © 2018年 tang. All rights reserved.
//

//#ifndef TZBNetRequestCallback_h
//#define TZBNetRequestCallback_h


typedef void(^TZBNetRequestSuccessBlock)(NSInteger errCode, id responseObject);

typedef void(^TZBNetRequestFailBlock)(NSError *error);


/**
 构造请求体block 上传文件

 @param data <#data description#>
 */
typedef void(^AFConstructingBodyBlock)(id<AFMultipartFormData> data);


/**
 上传进度block

 @param process <#process description#>
 */
typedef void(^AFURLSessionTaskProgressBlock)(NSProgress *progress);
/**
 下载进度条

 @param progress <#progress description#>
 */
typedef void(^AFDownloadProgressBlock)(NSProgress *progress);
/**
 下载文件存放地

 @param targetPath <#targetPath description#>
 @param response <#response description#>
 */
typedef NSURL*(^AFDownloadDestinationBlock)(NSURL *targetPath,NSURLResponse *response);
/**
 下载文件完成

 @param response <#response description#>
 @param filepath <#filepath description#>
 @param error <#error description#>
 */
typedef void(^AFDownloadCompletionBlock)(NSURLResponse *response,NSURL *filepath,NSError *error);

//#endif /* TZBNetRequestCallback_h */

