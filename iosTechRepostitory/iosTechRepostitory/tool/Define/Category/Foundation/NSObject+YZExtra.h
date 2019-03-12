//
//  NSObject+YZExtra.h
//  YZFFMain
//
//  Created by Kelvin on 2018/10/10.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YZExtra)
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
@end
