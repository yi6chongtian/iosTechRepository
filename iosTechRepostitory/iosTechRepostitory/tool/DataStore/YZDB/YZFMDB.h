//
//  YZFMDB.h
//  OC_Test
//
//  Created by tang on 2018/4/28.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@protocol YZDBModelProtocol;

@interface YZFMDB : NSObject


@property (nonatomic, strong,readonly) FMDatabase *db;


+ (instancetype)shareDB;

- (BOOL)createTable:(Class)c;

- (BOOL)dropTable:(Class)c;

- (BOOL)insertRecord:(id<YZDBModelProtocol>)record;

- (BOOL)updateRecord:(id<YZDBModelProtocol>)record;

- (BOOL)updateRecord:(id<YZDBModelProtocol>)record where:(NSString *)where;

- (BOOL)saveOrUpdateRecord:(id<YZDBModelProtocol>)record;

- (BOOL)removeRecord:(id<YZDBModelProtocol>)record;

- (BOOL)removeRecord:(Class)c where:(NSString *)where;

- (BOOL)removeRecordByTableName:(NSString *)tableName where:(NSString *)where;

- (NSArray *)getAllData:(Class )c;

- (NSArray *)getData:(Class)c where:(NSString *)where;


- (FMResultSet *)getTableSchema:(NSString *)tablename;

- (void)yz_inDatabase:(void(^)(void))block;

- (void)yz_inTransaction:(void(^)(BOOL *rollback))block;


@end
