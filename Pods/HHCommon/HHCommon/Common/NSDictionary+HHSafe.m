//
//  NSDictionary+HHSafe.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "NSDictionary+HHSafe.h"

@implementation NSDictionary (HHSafe)

- (nullable id)hh_objectForKeySafely:(id)key {
    if (!key) {
        return nil;
    }
    id object = [self objectForKey:key];
    return object;
}

- (nullable NSArray *)hh_arrayForKeySafely:(id)key {
    id array = [self hh_objectForKeySafely:key];
    if ([array isKindOfClass:[NSArray class]])
        return array;
    return nil;
}

- (nullable NSDictionary *)hh_dictionaryForKeySafely:(id)key {
    id dictionary = [self hh_objectForKeySafely:key];
    if([dictionary isKindOfClass:[NSDictionary class]])
        return dictionary;
    return nil;
}

- (nullable NSString *)hh_stringForKeySafely:(id)key {
    id string = [self hh_objectForKeySafely:key];
    if([string isKindOfClass:[NSString class]])
        return string;
    if([string isKindOfClass:[NSNumber class]])
        return [NSString stringWithFormat:@"%@", string];
    return nil;
}

- (nullable NSNumber *)hh_numberForKeySafely:(id)key {
    id number = [self hh_objectForKeySafely:key];
    if([number isKindOfClass:[NSNumber class]]) {
        return number;
    }
    if([number isKindOfClass:[NSString class]]) {
        return [self numberFromString:(NSString *)number];
    }
    return nil;
}

- (nullable NSNumber *)numberFromString:(NSString*)string {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

- (BOOL)hh_boolForKeySafely:(id)key defaultValue:(BOOL)defaultValue {
    id boolean = [self hh_objectForKeySafely:key];
    if ([boolean isKindOfClass:[NSNumber class]]) {
        return [boolean boolValue];
    }
    if ([boolean isKindOfClass:[NSString class]]) {
        if([boolean isEqual:@"true"]) return YES;
        if([boolean isEqual:@"false"]) return NO;
    }
    return defaultValue;
}

- (nullable NSDate *)hh_dateForKeySafely:(id)key {
    id date = [self hh_objectForKeySafely:key];
    if([date isKindOfClass:[NSDate class]])
        return date;
    return nil;
}

- (NSInteger)hh_integerForKey:(id)key {
    id object = [self hh_objectForKeySafely:key];
    if ([object respondsToSelector:@selector(integerValue)]) {
        return [object integerValue];
    }
    return 0;
}

- (NSUInteger)hh_unsignedIntegerForKey:(id)key {
    id object = [self hh_objectForKeySafely:key];
    if ([object respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [object unsignedIntegerValue];
    }
    return 0;
}

- (float)hh_floatForKey:(id)key {
    id object = [self hh_objectForKeySafely:key];
    if ([object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    }
    return 0.0;
}

- (double)hh_doubleForKey:(id)key {
    id object = [self hh_objectForKeySafely:key];
    if ([object respondsToSelector:@selector(doubleValue)]) {
        return [object doubleValue];
    }
    return 0.0;
}

@end
