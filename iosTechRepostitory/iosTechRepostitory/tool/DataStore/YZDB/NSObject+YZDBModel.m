//
//  NSObject+YZDBModel.m
//  OC_Test
//
//  Created by tang on 2018/4/28.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "NSObject+YZDBModel.h"
#import <objc/runtime.h>
#import "YZFMDB.h"



#define AUTOINCREMENT @"AUTOINCREMENT"


@implementation NSObject (YZDBModel)

# pragma mark - 分类实现属性

//- (NSNumber *)yzId{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setYzId:(NSNumber *)yzId{
//    objc_setAssociatedObject(self, @selector(yzId), yzId, OBJC_ASSOCIATION_RETAIN);
//}
//
//- (NSString *)createDate{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setCreateDate:(NSString *)createDate{
//    objc_setAssociatedObject(self, @selector(createDate), createDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//}
//
//- (NSString *)updateDate{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//- (void)setUpdateDate:(NSString *)updateDate{
//    objc_setAssociatedObject(self, @selector(updateDate), updateDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

#pragma mark - YZDBModelProtocol

//+ (YZFMDB *)yzDB{
//    return [YZFMDB shareDB];
//}

//+ (NSDictionary *)primaryKeys{
//    return @{YZID:@"integer PRIMARY KEY AUTOINCREMENT"};
//}

+ (NSString *)tableName{
    return NSStringFromClass(self);
}

+ (NSArray *)excludeProList{
    return nil;
}

+ (NSDictionary *)primaryKeys {
    return nil;
}
@end
