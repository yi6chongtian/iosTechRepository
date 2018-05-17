//
//  YZFMDB.m
//  OC_Test
//
//  Created by tang on 2018/4/28.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "YZFMDB.h"
#import "NSObject+YZDBModel.h"
#import <objc/runtime.h>

// 数据库中常见的几种类型
#define SQL_TEXT     @"TEXT" //文本
#define SQL_INTEGER  @"INTEGER" //int long integer ...
#define SQL_REAL     @"REAL" //浮点
#define SQL_BLOB     @"BLOB" //data

#define AUTOINCREMENT @"AUTOINCREMENT"

#define PRIMARYKEYDESC @"integer PRIMARY KEY AUTOINCREMENT"

#define INTEGER @"integer"



@interface YZFMDB()

@property (nonatomic, strong) NSString *dbPath;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) FMDatabase *db;

@end

static YZFMDB *_singleDB;

@implementation YZFMDB

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        FMDatabaseQueue *fmdb = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        self.dbQueue = fmdb;
        [_db close];
        self.db = [fmdb valueForKey:@"_db"];
    }
    return _dbQueue;
}

+ (instancetype)shareDB{
    //线程锁
    @synchronized (self) {
        if (_singleDB == nil) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            path = [path stringByAppendingPathComponent:@"pigdata"];
            NSFileManager *fm = [NSFileManager defaultManager];
            BOOL isDir = FALSE;
            BOOL isDirExist = [fm fileExistsAtPath:path
                                                isDirectory:&isDir];
            if(!(isDirExist && isDir)){
                BOOL result = [fm createDirectoryAtPath:path
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:nil];
                NSAssert(result, @"创建文件夹失败");
            }
            path = [path stringByAppendingPathComponent:@"yz.sqlite"];
            FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
            if([fmdb open]){
                _singleDB = [[YZFMDB alloc] init];
                _singleDB.db = fmdb;
                _singleDB.dbPath = path;
//                [fmdb close];
            }
        }
    }
    return _singleDB;
}

- (BOOL)createTable:(Class)c{
    if([c conformsToProtocol:@protocol(YZDBModelProtocol)]){
        NSString *tableName = [c tableName];
        NSArray *excludeProList = [c excludeProList];
        NSDictionary *primaryKeyList = [c primaryKeys];
        NSAssert(primaryKeyList.count > 0, @"请提供主键信息");
        NSDictionary *dataBaseDic = [self modelToDataBaseDictionary:c excludePropertyName:excludeProList];
        for (NSString *key in primaryKeyList) {
            NSAssert([dataBaseDic.allKeys containsObject:key], @"主键信息不正确");
        }
        //创建表 ----默认设置主键字段和类型
        NSMutableString *fieldStr = nil;
        if(primaryKeyList.count == 1){
            fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ %@,", tableName,primaryKeyList.allKeys[0],primaryKeyList.allValues[0]];
        }else{
            fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", tableName];
        }
        
        int keyCount = 0;
        for (NSString *key in dataBaseDic) {
            keyCount++;
            //不包括的字段列表包括当前字段或者key为pkid，
            if ((excludeProList && [excludeProList containsObject:key])) {
                continue;
            }
            //主键略过
            if(primaryKeyList.count == 1 &&
               [key isEqualToString:primaryKeyList.allKeys[0]] &&
               [primaryKeyList.allValues[0] rangeOfString:AUTOINCREMENT].location > 0){
                if(keyCount == dataBaseDic.count){//最后一个键
                    //CREATE TABLE IF NOT EXISTS User (yzId integer PRIMARY KEY AUTOINCREMENT, name TEXT, idcard TEXT,
                    [fieldStr deleteCharactersInRange:NSMakeRange(fieldStr.length-1, 1)];
                    [fieldStr appendFormat:@")"];
                }
                continue;
            }
            //最后一个字段
            if (keyCount == dataBaseDic.count) {
                if(primaryKeyList.count == 1){
                    [fieldStr appendFormat:@" %@ %@)", key, dataBaseDic[key]];
                }else{
                    //其它字段
                    [fieldStr appendFormat:@" %@ %@,", key, dataBaseDic[key]];
                    //添加主键信息
                    //PRIMARY KEY(yzId, age)
                    [fieldStr appendString:@"PRIMARY KEY("];
                    for (NSString *pk in primaryKeyList.allKeys) {
                        [fieldStr appendFormat:@"%@,",pk];
                    }
                    //insert语句删除最后的逗号
                    [fieldStr deleteCharactersInRange:NSMakeRange(fieldStr.length-1, 1)];
                    [fieldStr appendString:@")"];
                    [fieldStr appendString:@")"];
                    
                }
                break;
            }
            //其它字段
            [fieldStr appendFormat:@" %@ %@,", key, dataBaseDic[key]];
        }
        /*
         CREATE TABLE tb_pig (
         pkid  INTEGER PRIMARY KEY,
         pig_id TEXT,
         pig_sex_id INTEGER,
         pig_sex_name TEXT,
         pig_type_id INTEGER,
         pig_type_name TEXT,
         pig_weight REAL,
         pig_day_age INTEGER,
         farm_pkid INTEGER
         );
         */
        //执行创建表语句
        BOOL creatFlag;
        creatFlag = [self.db executeUpdate:fieldStr];
        return creatFlag;
    }
    return NO;
}

- (BOOL)dropTable:(Class)c{
    if([c conformsToProtocol:@protocol(YZDBModelProtocol)]){
        NSString *tablename = [c tableName];
        NSString *sql = [NSString stringWithFormat:@"drop table %@",tablename];
        BOOL flag = [self.db executeUpdate:sql];
        return flag;
    }
    return NO;
}

- (BOOL)insertRecord:(id<YZDBModelProtocol>)record{
    BOOL flag = NO;
    NSString *tableName = [[(id)record class] tableName];
    NSDictionary *primaryKeyList = [[(id)record class] primaryKeys];
    NSAssert(primaryKeyList.count > 0, @"请提供主键信息");
    NSArray *columnArr = [self getColumnArr:tableName];
    NSMutableDictionary *dic = [self getModelPropertyKeyValue:record tableName:tableName clomnArr:columnArr];
//    for (NSString *key in primaryKeyList) {
//
//    }
    //insert语句
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    //参数列表
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    //遍历字典key
    for (NSString *key in dic) {
        //数据库字段列表不包括该key
        if (![columnArr containsObject:key]) {
            continue;
        }
        //单主键且自增长的忽略
        if(primaryKeyList.allKeys.count == 1 && [primaryKeyList.allKeys containsObject:key] && [primaryKeyList.allValues[0] containsString:AUTOINCREMENT]){
            continue;
        }
        //INSERT INTO tablename (col0,col1,
        [finalStr appendFormat:@"%@,", key];
        //?,
        [tempStr appendString:@"?,"];
        //参数列表添加值
        [argumentsArr addObject:dic[key]];
    }
    
    //insert语句删除最后的逗号
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    //删除最后的逗号
    if (tempStr.length){
        [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];
    }
    //insert语句生成value列表 insert into tablename (col0,col1,col2) values (?,?,?)
    [finalStr appendFormat:@") values (%@)", tempStr];
    //执行insert语句
    flag = [self.db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    //如果主键为新增，设置主键值
    
    if(primaryKeyList.count == 1 && [(NSString *)primaryKeyList.allValues[0] isEqualToString:PRIMARYKEYDESC]){
        NSInteger pkid = [self getMaxId:record];
        NSAssert(pkid != -1, @"错误");
        if(pkid != -1){
            [(NSObject *)record setValue:[NSNumber numberWithInteger:pkid] forKey:primaryKeyList.allKeys[0]];
        }
    }
    return flag;
}



- (BOOL)updateRecord:(id<YZDBModelProtocol>)record{
    BOOL flag = NO;
    NSString *tableName = [[(id)record class] tableName];
    NSDictionary *primaryKeyList = [[(id)record class] primaryKeys];
    NSAssert(primaryKeyList.count > 0, @"请提供主键信息");
    NSArray *columnArr = [self getColumnArr:tableName];
    for (NSString *key in primaryKeyList) {
        NSAssert([columnArr containsObject:key], @"主键不包括在表的字段信息中");
    }
    
    NSMutableDictionary *dic = [self getModelPropertyKeyValue:record tableName:tableName clomnArr:columnArr];
    //update语句 update tablename set
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    //参数列表
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        //数据表字段列表不包括key或者key为pkid
        if (![columnArr containsObject:key] /*|| [primaryKeyList.allKeys containsObject:key]*/) {
            continue;
        }
        // update tablename set col0 = ?,
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }
    //删除最后一个逗号 update tablename set col0 = ?,col1 = ?
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    NSMutableString *where  = [NSMutableString stringWithString:@" where "];
    for (int i = 0; i < primaryKeyList.allKeys.count; i++) {
        id primaryKeyValue = [(id)record valueForKey:primaryKeyList.allKeys[i]];
        if([primaryKeyValue isKindOfClass:[NSString class]]){
            [where appendFormat:@"%@ = '%@' and ",primaryKeyList.allKeys[i],primaryKeyValue];
        }else{
            [where appendFormat:@"%@ = %@ and ",primaryKeyList.allKeys[i],primaryKeyValue];
            
        }
        if(i == primaryKeyList.count - 1){
            [where deleteCharactersInRange:NSMakeRange(where.length - 4, 4)];
        }
    }
    [finalStr appendString:where];
    //执行update语句
    flag =  [self.db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    
    return flag;
}

- (BOOL)updateRecord:(id<YZDBModelProtocol>)record where:(NSString *)where{
    BOOL flag = NO;
    NSString *tableName = [[(id)record class] tableName];
    NSDictionary *primaryKeyList = [[(id)record class] primaryKeys];
    NSAssert(primaryKeyList.count > 0, @"请提供主键信息");
    NSArray *columnArr = [self getColumnArr:tableName];
    for (NSString *key in primaryKeyList) {
        NSAssert([columnArr containsObject:key], @"主键不包括在表的字段信息中");
    }
    
    NSMutableDictionary *dic = [self getModelPropertyKeyValue:record tableName:tableName clomnArr:columnArr];
    //update语句 update tablename set
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    //参数列表
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        //数据表字段列表不包括key或者key为pkid
        if (![columnArr containsObject:key] /*|| [primaryKeyList.allKeys containsObject:key]*/) {
            continue;
        }
        // update tablename set col0 = ?,
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }
    //删除最后一个逗号 update tablename set col0 = ?,col1 = ?
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if(where){
        [finalStr appendString:[NSString stringWithFormat:@" %@",where]];
    }
    //执行update语句
    flag =  [self.db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    
    return flag;
}

- (BOOL)saveOrUpdateRecord:(id<YZDBModelProtocol>)record{
    NSDictionary *primaryKeyList = [[(id)record class] primaryKeys];
    NSMutableString *where = [NSMutableString string];
    [where appendString:@"where "];
    for (NSString *key in primaryKeyList.allKeys) {
        BOOL isStr = ![(NSString *)primaryKeyList[key] containsString:INTEGER];
        [where appendFormat:@"%@ = ",key];
        if(isStr){
            [where appendFormat:@"'%@' and",[(NSObject *)record valueForKey:key]];
        }else{
            [where appendFormat:@"%zd and",[[(NSObject *)record valueForKey:key] integerValue]];
        }
    }
    //删除最后一个and
    [where deleteCharactersInRange:NSMakeRange(where.length-3, 3)];
    NSArray *list = [self getData:[(id)record class] where:where];
    if(list.count == 0){
        return [self insertRecord:record];
    }else{
        return [self updateRecord:record];
    }
}

- (BOOL)removeRecord:(id<YZDBModelProtocol>)record{
    NSDictionary *primaryKeyList = [[(id)record class] primaryKeys];
    NSAssert(primaryKeyList.count > 0, @"提供主键信息");
    NSString *sql = nil;
    NSMutableString *where  = [NSMutableString stringWithString:@"where "];
    for (int i = 0; i < primaryKeyList.allKeys.count; i++) {
        id primaryKeyValue = [(id)record valueForKey:primaryKeyList.allKeys[i]];
        if([primaryKeyValue isKindOfClass:[NSString class]]){
            [where appendFormat:@"%@ = '%@' and ",primaryKeyList.allKeys[i],primaryKeyValue];
        }else{
            [where appendFormat:@"%@ = %@ and ",primaryKeyList.allKeys[i],primaryKeyValue];
        }
        if(i == primaryKeyList.count - 1){
            [where deleteCharactersInRange:NSMakeRange(where.length-4, 4)];
        }
    }
    sql = [NSString stringWithFormat:@"delete from %@ %@",[[(id)record class] tableName],where];
    BOOL flag = [self.db executeUpdate:sql];
    return flag;
}

- (BOOL)removeRecord:(Class)c where:(NSString *)where{
    return [self removeRecordByTableName:[c tableName] where:where];
}

- (BOOL)removeRecordByTableName:(NSString *)tableName where:(NSString *)where{
    BOOL flag = NO;
    NSString *sql = [NSString stringWithFormat:@"delete from %@ %@",tableName,where ? where : @""];
    flag = [[self db] executeUpdate:sql];
    return flag;
}

- (NSArray *)getAllData:(Class )c{
    NSString *tablename = [c tableName];
    return [self getDataByTableName:tablename instanceType:c where:nil];
}

- (NSArray *)getData:(Class)c where:(NSString *)where{
    NSString *tablename = [c tableName];
    return [self getDataByTableName:tablename instanceType:c where:where];
}

- (NSArray *)getDataByTableName:(NSString *)tablename instanceType:(Class)type where:(NSString *)where{
    NSMutableArray *arrlist= [NSMutableArray array];
    NSArray *colArr = [self getColumnArr:tablename];
    NSDictionary *propertyType = [self modelToDataBaseDictionary:type excludePropertyName:[type excludeProList]];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ %@",tablename,where?where:@""];
    FMResultSet *set = [self.db executeQuery:sql];
    id model = nil;
    Class CLS = type;
    while ([set next]) {
        model = CLS.new;
        for (NSString *name in colArr) {
            if ([propertyType[name] isEqualToString:SQL_TEXT]) {
                id value = [set stringForColumn:name];
                if (value)
                    [model setValue:value forKey:name];
            } else if ([propertyType[name] isEqualToString:SQL_INTEGER]) {
                [model setValue:@([set longLongIntForColumn:name]) forKey:name];
            } else if ([propertyType[name] isEqualToString:SQL_REAL]) {
                [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
            } else if ([propertyType[name] isEqualToString:SQL_BLOB]) {
                id value = [set dataForColumn:name];
                if (value)
                    [model setValue:value forKey:name];
            }
        }
        [arrlist addObject:model];
    }
    return arrlist;
}




- (FMResultSet *)getTableSchema:(NSString *)tablename{
    FMResultSet *set = nil;
    if([self.db open]){
        set = [self.db getTableSchema:tablename];
//        [self.db close];
    }
    return set;
}

- (NSInteger)maxPriKeyId:(Class )c{
    NSString *tablename = [c tableName];
    NSDictionary *primaryKeyList = [c primaryKeys];
    NSAssert(primaryKeyList.count > 0, @"请提供主键信息");
    if(primaryKeyList.count == 1 && [(NSString *)primaryKeyList.allValues[0] containsString:AUTOINCREMENT]){
        NSString *sql = [NSString stringWithFormat:@"select max(%@) from %@;",primaryKeyList.allKeys[0],tablename];
        FMResultSet *set = [self.db executeQuery:sql];
        NSInteger result = -1;
        while ([set next]) {
            result = [set intForColumnIndex:0];
        }
        return result;
    }
    return -1;
    
}

#pragma mark - 线程安全操作
// =============================   线程安全操作    ===============================

- (void)yz_inDatabase:(void(^)(void))block
{
    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        block();
    }];
}

- (void)yz_inTransaction:(void(^)(BOOL *rollback))block
{
    
    [[self dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        block(rollback);
    }];
    
}

#pragma mark - 辅助方法
/**
 根据对象类型生成数据库字段结构字典
 
 @param cls 对象类型
 @param nameArr 不包括的字段名称
 @return 数据库字段字典
 */
- (NSDictionary *)modelToDataBaseDictionary:(Class)cls excludePropertyName:(NSArray *)nameArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    //复制类型属性列表
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        //获取属性名称
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        //不包含的字段
        if ([nameArr containsObject:name]){
            continue;
        }
        //属性类型
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        // 获取属性类型对应的字段类型
        id value = [self propertTypeConvert:type];
        if (value) {
            [mDic setObject:value forKey:name];
        }
        
    }
    free(properties);
    
    return mDic;
}

/**
 // 获取model的key和value
 
 @param model 实例对象
 @param tableName 表名称
 @param clomnArr 数据库字段名称
 @return 字段 数据库字段：值
 */
- (NSMutableDictionary *)getModelPropertyKeyValue:(id)model tableName:(NSString *)tableName clomnArr:(NSArray *)clomnArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    //获取对象属性列表
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (int i = 0; i < outCount; i++) {
        //获取属性名称
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        //数据库字段列表不包括属性名称，跳过
        if (![clomnArr containsObject:name]) {
            continue;
        }
        //获取对象属性值
        id value = [model valueForKey:name];
        if (value) {
            //设置字典值
            [mDic setObject:value forKey:name];
        }
    }
    free(properties);
    
    
    return mDic;
}

/**
 根据对象属性类型获取数据库字段类型
 
 @param typeStr 对象属性类型
 @return 数据库字段类型
 */
- (NSString *)propertTypeConvert:(NSString *)typeStr
{
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_TEXT;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_BLOB;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_INTEGER;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_REAL;
    }
    
    return resultStr;
}

/**
 获取数据库表的所有字段名称
 
 @param tableName 表名称
 @return 字段名称列表
 */
- (NSArray *)getColumnArr:(NSString *)tableName
{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet *resultSet = [self.db getTableSchema:tableName];
    
    while ([resultSet next]) {
        [mArr addObject:[resultSet stringForColumn:@"name"]];
    }
    
    return mArr;
}

- (NSInteger)getMaxId:(id<YZDBModelProtocol>)value{
    __block NSInteger index = -1;
    [self yz_inDatabase:^{
        NSDictionary *primaryKeyList = [[(id)value class] primaryKeys];
        NSString *tableName = [[(id)value class] tableName];
        NSString *sql = [NSString stringWithFormat:@"select max(%@) from %@",primaryKeyList.allKeys[0],tableName];
        if([self.db open]){
            FMResultSet *set = [self.db executeQuery:sql];
            while ([set next]) {
                index = [set intForColumnIndex:0];
            }
        }
    }];
    return index;
    
}



@end
