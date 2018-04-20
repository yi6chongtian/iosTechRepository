//
//  NSUserDefaultTool.h
//  iosTechRepostitory
//
//  Created by tang on 2018/4/12.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultTool : NSObject

+ (id)getObjectForkey:(NSString *)key;

+ (BOOL)setObject:(id)object forkey:(NSString *)key;

+ (BOOL)deleteObjectWithKey:(NSString *)key;

@end
