//
//  NSObject+HHAdd.m
//  HHCommon
//
//  Created by yufeng on 2022/5/4.
//

#import "NSObject+HHAdd.h"
#import <objc/runtime.h>

@implementation NSObject (HHAdd)

- (nullable instancetype)hh_as:(nonnull Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    }
    return nil;
}

- (nullable instancetype)hh_is:(nonnull Class)cls {
    if ([self isMemberOfClass:cls]) {
        return self;
    }
    return nil;
}

+ (void)hh_swizzleMethodWithOriginal:(SEL)original swizzled:(SEL)swizzled {
    Class class = [self class];
        
    Method originalMethod = class_getInstanceMethod(class, original);
    Method swizzledMethod = class_getInstanceMethod(class, swizzled);
        
    BOOL didAddMethod =
    class_addMethod(class, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
    if (didAddMethod) {
        class_replaceMethod(class, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
