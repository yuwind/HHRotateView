//
//  NSMutableArray+HHSafe.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray<ObjectType> (HHSafe)

- (void)hh_addObjectsSafelyFromArray:(nullable NSArray *)array;
- (void)hh_addObjectSafely:(nullable ObjectType)object;
- (void)hh_removeObjectSafely:(nullable ObjectType)object;
- (void)hh_insertObjectSafely:(ObjectType)object atIndex:(NSUInteger)index;
- (void)hh_replaceObjectSafelyAtIndex:(NSUInteger)index withObject:(nullable ObjectType)object;

@end

NS_ASSUME_NONNULL_END
