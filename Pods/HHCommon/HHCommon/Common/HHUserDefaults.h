//
//  HHUserDefaults.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHUserDefaults : NSObject

+ (void)setData:(nullable NSData *)data forKey:(NSString *)key;
+ (nullable NSData *)dataForKey:(NSString *)key;

+ (void)setString:(nullable NSString *)string forKey:(NSString *)key;
+ (nullable NSString *)stringForKey:(NSString *)key;

+ (void)setURL:(nullable NSURL *)url forKey:(NSString *)key;
+ (nullable NSURL *)urlForKey:(NSString *)key;

+ (void)setDictionary:(nullable NSDictionary *)dictionary forKey:(NSString *)key;
+ (nullable NSDictionary *)dictionaryForKey:(NSString *)key;

+ (void)setArray:(nullable NSArray *)array forKey:(NSString *)key;
+ (nullable NSArray *)arrayForKey:(NSString *)key;

+ (void)setBool:(BOOL)value forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (void)setDate:(nullable NSDate *)date forKey:(NSString *)key;
+ (nullable NSDate *)dateForKey:(NSString *)key;

+ (void)setNumber:(nullable NSNumber *)number forKey:(NSString *)key;
+ (nullable NSNumber *)numberForKey:(NSString *)key;

+ (void)setInteger:(NSInteger)integer forKey:(NSString *)key;
+ (NSInteger)integerForKey:(NSString *)key;

+ (void)setFloat:(float)number forKey:(NSString *)key;
+ (float)floatForKey:(NSString *)key;

+ (void)setDouble:(double)number forKey:(NSString *)key;
+ (double)doubleForKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;
+ (BOOL)isExistKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
