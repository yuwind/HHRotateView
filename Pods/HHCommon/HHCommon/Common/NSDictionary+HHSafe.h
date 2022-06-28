//
//  NSDictionary+HHSafe.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<KeyType, ObjectType> (HHSafe)

- (nullable ObjectType)hh_objectForKeySafely:(nullable KeyType)key;
- (nullable NSArray *)hh_arrayForKeySafely:(nullable KeyType)key;
- (nullable NSDictionary *)hh_dictionaryForKeySafely:(nullable KeyType)key;
- (nullable NSString *)hh_stringForKeySafely:(nullable KeyType)key;
- (nullable NSNumber *)hh_numberForKeySafely:(nullable KeyType)key;
- (BOOL)hh_boolForKeySafely:(KeyType)key defaultValue:(BOOL)defaultValue;
- (nullable NSDate *)hh_dateForKeySafely:(nullable KeyType)key;
- (NSInteger)hh_integerForKey:(nullable KeyType)key;
- (NSUInteger)hh_unsignedIntegerForKey:(nullable KeyType)key;
- (float)hh_floatForKey:(nullable KeyType)key;
- (double)hh_doubleForKey:(nullable KeyType)key;

@end

NS_ASSUME_NONNULL_END
