//
//  NSArray+HHSafe.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (HHSafe)

- (nullable ObjectType)hh_objectSafelyAtIndex:(NSUInteger)index;
- (NSArray *)hh_mapObjectsUsingBlock:(nullable id _Nullable (^)(ObjectType obj, NSUInteger idx))block;

@end

NS_ASSUME_NONNULL_END
