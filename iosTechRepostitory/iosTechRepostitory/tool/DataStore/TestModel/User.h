//
//  User.h
//  OC_Test
//
//  Created by tang on 2018/4/28.
//  Copyright © 2018年 tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YZDBModel.h"

@interface User : NSObject

@property (nonatomic,strong) NSNumber *yzId;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) float height;

@property (nonatomic,strong) NSString *idcard;


@end
