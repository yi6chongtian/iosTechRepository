//
//  NSObject+YZDBModel.h
//  OC_Test
//
//  Created by tang on 2018/4/28.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"
#import "YZFMDB.h"

// 数据库中常见的几种类型
#define SQL_TEXT     @"TEXT" //文本
#define SQL_INTEGER  @"INTEGER" //int long integer ...
#define SQL_REAL     @"REAL" //浮点
#define SQL_BLOB     @"BLOB" //data


@protocol YZDBModelProtocol

@required

+ (YZFMDB *)yzDB;

+ (NSDictionary *)primaryKeys;



@optional

+ (NSString *)tableName;

+ (NSArray *)excludeProList;

@end

@interface NSObject (YZDBModel)<YZDBModelProtocol>


//@property (nonatomic,strong) NSNumber *yzId;
//
//@property (nonatomic,copy) NSString *createDate;
//
//@property (nonatomic,copy) NSString *updateDate;

//+ (BOOL)createTable;
//
//- (BOOL)saveToDB;
//
//- (BOOL)updateToDB;

//- (BOOL)updateToDB:(NSString *)where;

//- (BOOL)removeFromDB;
//
//+ (BOOL)removeFromDB:(NSString *)where;
//
//+ (NSArray *)getAllData;
//
//+ (NSArray *)getData:(NSString *)where;

@end
