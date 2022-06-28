//
//  HHCommonMethod.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HHActionBlock)(void);

static inline NSString *toString(id object){
    if ([object isEqual:[NSNull null]] || object == nil || object == NULL){
        return @"";
    } else if ([object isKindOfClass:NSString.class]){
        return [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else if ([object isKindOfClass:NSNumber.class]){
        return [(NSNumber *)object stringValue];
    } else if ([object isKindOfClass:NSDictionary.class] || [object isKindOfClass:NSArray.class]){
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            return @"";
        }
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return [NSString stringWithFormat:@"%@",object];
}

static inline BOOL isValidString(id object){
    if (object == [NSNull null] || object == nil || object == NULL){
        return NO;
    } else if ([object isKindOfClass:NSString.class]){
        return [(NSString *)object length] > 0;
    }
    return NO;
}

static inline NSString *formatString(NSString *format,...){
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return string;
}

static inline void performActionOnDebug(HHActionBlock actionBlock) {
#if DEBUG || ADHOC
    if (actionBlock) {
        actionBlock();
    }
#endif
}

static inline void performActionOnRelease(HHActionBlock actionBlock) {
#if !DEBUG && !ADHOC
    if (actionBlock) {
        actionBlock();
    }
#endif
}

static inline void performActionOnDiffEnvironment(HHActionBlock debugBlock, HHActionBlock releaseBlock) {
#if DEBUG || ADHOC
    if (debugBlock) {
        debugBlock();
    }
#else
    if (releaseBlock) {
        releaseBlock();
    }
#endif
}

static inline void performActionOnMainThread(HHActionBlock actionBlock) {
    if (NSThread.isMainThread) {
        if (actionBlock) {
            actionBlock();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (actionBlock) {
                actionBlock();
            }
        });
    }
}

NS_ASSUME_NONNULL_END
