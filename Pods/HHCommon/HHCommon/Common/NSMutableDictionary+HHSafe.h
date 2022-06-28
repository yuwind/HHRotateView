//
//  NSMutableDictionary+HHSafe.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary<KeyType, ObjectType> (HHSafe)

- (void)hh_setObjectSafely:(nullable ObjectType)object forKey:(nullable KeyType)key;
- (void)hh_removeObjectForKey:(nullable KeyType)key;
- (void)hh_addEntriesFromDictionary:(NSDictionary<KeyType, ObjectType> *)otherDictionary;

@end

NS_ASSUME_NONNULL_END
