//
//  HHSafeTimer.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <Foundation/Foundation.h>

@interface HHSafeTimer : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;

/**
 这是一个安全的timer，不需要主动销毁，生命周期随owner，默认是暂停状态

 @param interval 时间间隔
 @param block 回调事件，`warning`循环引用
 @return 实例对象
 */
+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval action:(void(^)(NSInteger count, HHSafeTimer *timer))block;
- (instancetype)initWithInterval:(NSTimeInterval)interval action:(void (^)(NSInteger count, HHSafeTimer *timer))block;

/**
 这是一个安全的timer，不需要主动销毁，生命周期随owner，默认是暂停状态
 
 @param interval 时间间隔
 @param aTarget target
 @param aSelector selector
 @return 实例对象
 */
+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector;
- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector;

/**
 立刻开始timer
 */
- (void)start;

/**
 开始timer，指定开始时间
 */
- (void)startWithDate:(NSDate *)date;

/**
 重置计时器从0开始
 */
- (void)reset;

/**
 暂停timer
 */
- (void)stop;

/**
 恢复timer
 */
- (void)resume;

/**
 销毁timer
 */
- (void)invalidate;

@end
