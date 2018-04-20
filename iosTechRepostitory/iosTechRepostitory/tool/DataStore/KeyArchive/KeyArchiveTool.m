//
//  KeyArchiveTool.m
//  iosTechRepostitory
//
//  Created by tang on 2018/4/12.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "KeyArchiveTool.h"


@implementation KeyArchiveTool

static NSString * KEY_ARCHIVE_PATH;

+ (void)load{
    KEY_ARCHIVE_PATH = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];;
}

+(BOOL)keyArchiveObject:(id)object forKey:(NSString *)key{
    if(![object conformsToProtocol:@protocol(NSCoding)]){
        return NO;
    }
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    NSString *path = [KEY_ARCHIVE_PATH stringByAppendingPathComponent:key];
    BOOL result = [data writeToFile:path atomically:YES];
    return result;
}

+ (id)keyUnarchiveObjectWithKey:(NSString *)key{
    NSString *path = [KEY_ARCHIVE_PATH stringByAppendingPathComponent:key];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    id object= [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return object;
}


@end
