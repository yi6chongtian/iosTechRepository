//
//  PassworkTool.m
//  iosTechRepostitory
//
//  Created by tang on 2018/4/12.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "PassworkTool.h"
#import "KeyChainTool.h"

static NSString * const KEY_IN_KEYCHAIN_SERVICE = @"com.tang.app.userid";
static NSString * const KEY_PASSWORD = @"com.tang.app.password";

@implementation PassworkTool

+ (BOOL)savePassword:(NSString *)password{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:password forKey:KEY_PASSWORD];
    return [KeyChainTool addData:dict forService:KEY_IN_KEYCHAIN_SERVICE];
}

+ (id)readPassword{
    NSMutableDictionary *dict = [KeyChainTool queryDataWithService:KEY_IN_KEYCHAIN_SERVICE];
    return [dict objectForKey:KEY_PASSWORD];
}

+ (BOOL)deletePassword{
    return [KeyChainTool deleteDataWithService:KEY_IN_KEYCHAIN_SERVICE];
}

@end
