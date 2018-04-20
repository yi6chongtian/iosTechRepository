//
//  KeyChainTool.m
//  iosTechRepostitory
//
//  Created by tang on 2018/4/12.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "KeyChainTool.h"

@implementation KeyChainTool

+ (NSMutableDictionary *)keyChainQueryDictionaryWithService:(NSString *)service{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [dict setObject:service forKey:(id)kSecAttrService];
    [dict setObject:service forKey:(id)kSecAttrAccount];
    return dict;
}

+ (BOOL)addData:(id)data forService:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self keyChainQueryDictionaryWithService:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if(status == noErr){
        return YES;
    }
    return NO;
}

+ (id)queryDataWithService:(NSString *)service{
    id result;
    NSMutableDictionary *keychainQuery = [self keyChainQueryDictionaryWithService:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if(SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr){
        @try{
            result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch(NSException *exception){
            
        }
        @finally{
            
        }
    }
    if(keyData){
        CFRelease(keyData);
    }
    return result;
}

+ (BOOL)updateData:(id)data forService:(NSString *)service{
    NSMutableDictionary *searchDict = [self keyChainQueryDictionaryWithService:service];
    if(!searchDict){
        return NO;
    }
    NSMutableDictionary *updateDict = [[NSMutableDictionary alloc] init];
    [updateDict setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDict, (CFDictionaryRef)updateDict);
    if(status == errSecSuccess){
        return YES;
    }
    return NO;
}

+ (BOOL)deleteDataWithService:(NSString *)service{
    NSMutableDictionary *keychainDict = [self keyChainQueryDictionaryWithService:service];
    OSStatus status = SecItemDelete((CFDictionaryRef)keychainDict);
    if(status == noErr){
        return YES;
    }
    return NO;
}

@end
