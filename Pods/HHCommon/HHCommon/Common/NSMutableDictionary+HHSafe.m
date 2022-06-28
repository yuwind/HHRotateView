//
//  NSMutableDictionary+HHSafe.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "NSMutableDictionary+HHSafe.h"

@implementation NSMutableDictionary (HHSafe)

- (void)hh_setObjectSafely:(id)object forKey:(id)key {
    if(object != nil && key != nil) {
        [self setObject:object forKey:key];
    }
}

- (void)hh_removeObjectForKey:(id)key {
    if (key != nil) {
        [self removeObjectForKey:key];
    }
}

- (void)hh_addEntriesFromDictionary:(NSDictionary *)otherDictionary {
    if (otherDictionary != nil) {
        [self addEntriesFromDictionary:otherDictionary];
    }
}

@end
