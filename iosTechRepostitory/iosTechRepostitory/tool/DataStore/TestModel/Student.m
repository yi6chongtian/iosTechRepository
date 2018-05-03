//
//  Student.m
//  OC_Test
//
//  Created by tang on 2018/5/1.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "Student.h"
#import "NSObject+YZDBModel.h"

@implementation Student

+ (NSDictionary *)primaryKeys{
    return @{@"className" : SQL_TEXT, @"studtentName": SQL_TEXT};
}

@end
