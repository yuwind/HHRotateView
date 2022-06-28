//
//  NSObject+HHAdd.h
//  HHCommon
//
//  Created by yufeng on 2022/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HHAdd)

//是否满足isKindOfClass
- (nullable instancetype)hh_as:(nonnull Class)cls;

//是否满足isMemberOfClass
- (nullable instancetype)hh_is:(nonnull Class)cls;

//交换方法
+ (void)hh_swizzleMethodWithOriginal:(SEL)original swizzled:(SEL)swizzled;

@end

NS_ASSUME_NONNULL_END
