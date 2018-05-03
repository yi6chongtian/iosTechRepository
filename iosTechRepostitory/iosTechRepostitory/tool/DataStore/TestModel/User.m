//
//  User.m
//  OC_Test
//
//  Created by tang on 2018/4/28.
//  Copyright © 2018年 tang. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)primaryKeys{
    return @{@"yzId":@"integer PRIMARY KEY AUTOINCREMENT"};
}


+ (NSArray *)excludeProList{
    return @[@"height"];
}

@end
