//
//  NSMutableArray+HHSafe.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "NSMutableArray+HHSafe.h"

@implementation NSMutableArray (HHSafe)

- (void)hh_addObjectsSafelyFromArray:(NSArray *)array {
    if (array != nil) {
        [self addObjectsFromArray:array];
    }
}

- (void)hh_addObjectSafely:(id)object {
    if(object != nil) {
        [self addObject:object];
    }
}

- (void)hh_removeObjectSafely:(id)object {
    if(object) {
        [self removeObject:object];
    }
}

- (void)hh_insertObjectSafely:(id)object atIndex:(NSUInteger)index {
    if (object != nil && index <= self.count) {
        [self insertObject:object atIndex:index];
    }
}

- (void)hh_replaceObjectSafelyAtIndex:(NSUInteger)index withObject:(id)object {
    if (index < self.count && object != nil) {
        [self replaceObjectAtIndex:index withObject:object];
    }
}

@end
