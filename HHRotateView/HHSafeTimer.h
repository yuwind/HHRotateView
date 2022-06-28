//
//  HHSafeTimer.h
//  HHSafeTimerDemo
//
//  Created by 豫风 on 2017/8/18.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHSafeTimer : NSObject


/**
 这是一个安全的timer，不需要主动销毁
 
 @userage:
 if (count==5) //回调次数结束，自动销毁
 *stop = YES;//销毁定时器
 
 @param interval 时间间隔
 @param block 回调事件，`warning`循环引用
 @return 实例对象
 */
+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval action:(void(^)(NSInteger count, BOOL *stop))block;

- (instancetype)initWithInterval:(NSTimeInterval)interval action:(void (^)(NSInteger count, BOOL *stop))block;


/**
 这是一个安全的timer，不需要主动销毁
 
 @param interval 时间间隔
 @param aTarget target
 @param aSelector selector
 @param count 回调次数结束，自动销毁
 @return 实例对象
 */
+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector count:(NSInteger)count;

- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector count:(NSInteger)count;

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
