//
//  NSArray+HHSafe.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "NSArray+HHSafe.h"
#import "NSMutableArray+HHSafe.h"

@implementation NSArray (HHSafe)

- (id)hh_objectSafelyAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSArray *)hh_mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    if (!block) {
        return self;
    }
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [arrayM hh_addObjectSafely:block(obj, idx)];
    }];
    return arrayM.copy;
}

@end
