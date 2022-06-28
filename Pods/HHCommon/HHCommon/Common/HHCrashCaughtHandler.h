//
//  HHCrashCaughtHandler.h
//  HHCommon
//
//  Created by yufeng on 2022/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHCrashCaughtHandler : NSObject

+ (void)registerCrashCaughtHandler;

@end

NS_ASSUME_NONNULL_END
