//
//  NSObject+YZExtra.m
//  YZFFMain
//
//  Created by Kelvin on 2018/10/10.
//  Copyright © 2018 Yingzi. All rights reserved.
//

#import "NSObject+YZExtra.h"

@implementation NSObject (YZExtra)
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects
{
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if(methodSignature == nil)
    {
        @throw [NSException exceptionWithName:@"抛异常错误" reason:@"没有这个方法，或者方法名字错误" userInfo:nil];
        return nil;
    }
    else
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        //签名中方法参数的个数，内部包含了self和_cmd，所以参数从第3个开始
        NSInteger  signatureParamCount = methodSignature.numberOfArguments - 2;
        NSInteger requireParamCount = objects.count;
        NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
        for (NSInteger i = 0; i < resultParamCount; i++) {
            id  obj = objects[i];
            
            if ([obj isKindOfClass:[NSNumber class]]) {
                NSInteger idx = [obj integerValue];
                [invocation setArgument:&idx atIndex:i+2];
            }else{
                [invocation setArgument:&obj atIndex:i+2];
            }
        }
        [invocation invoke];
        //返回值处理
        id callBackObject = nil;
        if(methodSignature.methodReturnLength)
        {
            [invocation getReturnValue:&callBackObject];
        }
        return callBackObject;
    }
}
@end
