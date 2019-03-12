//
//  YZDefineFoundation.h
//  YZFFServer
//
//  Created by chengang on 2018/8/21.
//  Copyright © 2018年 Yingzi. All rights reserved.
//

#ifndef YZDefineFoundation_h
#define YZDefineFoundation_h

#import <objc/runtime.h>

#define kAPP_WINDOW [[[UIApplication sharedApplication] delegate] window]

#define kAPP_ROOT_VC [[[[UIApplication sharedApplication] delegate] window] rootViewController]

#define YZiOS11_Later   ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define YZiOS91_Later   ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define YZiOS9_Later    ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define YZiOS82_Later   ([UIDevice currentDevice].systemVersion.floatValue >= 8.2f)

#define kText(value) (value == nil ? @"" : value)
#define kTextDefault(value, default) ((value == nil || value.length == 0) ? default : value)

#define YZStr2NSStr(s)  [NSString stringWithCString:s encoding:[NSString defaultCStringEncoding]]

/// 国际化语言
#define YZLocalStr(str) NSLocalizedString(str, str)

/// 对象是否为nil
#define YZIsNull(obj) \
    (!obj || [obj.class isSubclassOfClass:[NSNull class]])

/// 对象是否为空
#define YZIsEmpty(obj) \
    (YZIsNull(obj) || \
    ([obj respondsToSelector:@selector(length)] && [(NSData *)obj length] == 0) || \
    ([obj respondsToSelector:@selector(count)] && [(NSArray *)obj count] == 0))

/// 抛出异常
#define YZException(r) \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:r userInfo:nil]

/// 交换selector
#define YZObjcExchangeMethodAToB(originalSelector,swizzledSelector) \
    do { \
        Method originalMethod = class_getInstanceMethod(self, originalSelector); \
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector); \
        if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) { \
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); \
        } else { \
            method_exchangeImplementations(originalMethod, swizzledMethod); \
        } \
    } while(0)
#define YZObjcExchangeClassMethodAToB(originalSelector,swizzledSelector) \
    do { \
        Class selfClass = object_getClass([self class]); \
        Method originalMethod = class_getClassMethod(selfClass, originalSelector); \
        Method swizzledMethod = class_getClassMethod(selfClass, swizzledSelector); \
        if (class_addMethod(selfClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) { \
            class_replaceMethod(selfClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); \
        } else { \
            method_exchangeImplementations(originalMethod, swizzledMethod); \
        } \
    } while(0)

#define YZClassCaller   ({\
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];\
        NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];\
        NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];\
        [array removeObject:@""];\
        array.count > 3? [array objectAtIndex:3]: nil;\
    })
#define YZMethodCaller   ({\
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];\
        NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];\
        NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];\
        [array removeObject:@""];\
        array.count > 4? [array objectAtIndex:4]: nil;\
    })

/**
 Synthsize a weak or strong reference.
 
 Example:
    @weakify(self)
    [self doSomething^{
        @strongify(self)
        if (!self) return;
        ...
    }];

 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#endif /* YZDefineFoundation_h */
