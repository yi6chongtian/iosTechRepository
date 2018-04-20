//
//  KeyChainTool.h
//  iosTechRepostitory
//
//  Created by tang on 2018/4/12.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainTool : NSObject

+ (NSMutableDictionary *)keyChainQueryDictionaryWithService:(NSString *)service;

+ (BOOL)addData:(id)data forService:(NSString *)service;

+ (id)queryDataWithService:(NSString *)service;

+ (BOOL)updateData:(id)data forService:(NSString *)service;

+ (BOOL)deleteDataWithService:(NSString *)service;


@end
