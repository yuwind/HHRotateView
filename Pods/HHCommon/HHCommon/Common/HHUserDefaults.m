//
//  HHUserDefaults.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "HHUserDefaults.h"

@implementation HHUserDefaults

+ (void)setData:(NSData *)data forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:data forKey:key];
}

+ (NSData *)dataForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [NSUserDefaults.standardUserDefaults dataForKey:key];
}

+ (void)setString:(NSString *)string forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:string forKey:key];
}

+ (NSString *)stringForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [NSUserDefaults.standardUserDefaults stringForKey:key];
}

+ (void)setURL:(NSURL *)url forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setURL:url forKey:key];
}

+ (NSURL *)urlForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [NSUserDefaults.standardUserDefaults URLForKey:key];
}

+ (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:dictionary forKey:key];
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [NSUserDefaults.standardUserDefaults dictionaryForKey:key];
}

+ (void)setArray:(NSArray *)array forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:array forKey:key];
}

+ (NSArray *)arrayForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    return [NSUserDefaults.standardUserDefaults arrayForKey:key];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setBool:value forKey:key];
}

+ (BOOL)boolForKey:(NSString *)key {
    if (key == nil) {
        return NO;
    }
    return [NSUserDefaults.standardUserDefaults boolForKey:key];
}

+ (void)setDate:(NSDate *)date forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:date forKey:key];
}

+ (void)setNumber:(NSNumber *)number forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setObject:number forKey:key];
}

+ (NSNumber *)numberForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    id object = [NSUserDefaults.standardUserDefaults objectForKey:key];
    if (![object isKindOfClass:NSNumber.class]) {
        return nil;
    }
    return object;
}

+ (void)setInteger:(NSInteger)integer forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setInteger:integer forKey:key];
}

+ (NSInteger)integerForKey:(NSString *)key {
    if (key == nil) {
        return 0;
    }
    return [NSUserDefaults.standardUserDefaults integerForKey:key];
}

+ (void)setFloat:(float)number forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setFloat:number forKey:key];
}

+ (float)floatForKey:(NSString *)key {
    if (key == nil) {
        return 0;
    }
    return [NSUserDefaults.standardUserDefaults floatForKey:key];
}

+ (void)setDouble:(double)number forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults setDouble:number forKey:key];
}

+ (double)doubleForKey:(NSString *)key {
    return [NSUserDefaults.standardUserDefaults doubleForKey:key];
}

+ (NSDate *)dateForKey:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    id object = [NSUserDefaults.standardUserDefaults objectForKey:key];
    if (![object isKindOfClass:NSDate.class]) {
        return nil;
    }
    return object;
}

+ (void)removeObjectForKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
}

+ (BOOL)isExistKey:(NSString *)key {
    if (key == nil) {
        return NO;
    }
    return [NSUserDefaults.standardUserDefaults objectForKey:key] != nil;
}

@end
