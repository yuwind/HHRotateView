//
//  HHSafeTimer.m
//  HHSafeTimerDemo
//
//  Created by 豫风 on 2017/8/18.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "HHSafeTimer.h"

@interface HHTimerAction : NSObject

@property (nonatomic, copy)   void(^blockAction)(NSInteger, BOOL *);
@property (nonatomic, assign) BOOL stop;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak)   id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) NSInteger countIndex;

@end

@implementation HHTimerAction

- (instancetype)initWithBlock:(void (^)(NSInteger, BOOL *))block
{
    if (self = [super init]) {
        
        self.stop = NO;
        self.count = 1;
        self.blockAction = block;
    }
    return self;
}

- (void)timerBlockAction:(NSTimer *)timer
{
    if (self.stop) {
        [timer invalidate];
        self.count = 1;
        self.stop = NO;
    }else{
        if (self.blockAction) {
            self.blockAction(self.count, &_stop);
            self.count++;
        }else{
            [timer invalidate];
        }
    }
}
- (instancetype)initWithTarget:(id)aTarget selector:(SEL)aSelector count:(NSInteger)count
{
    if (self = [super init]) {
        
        self.target = aTarget;
        self.selector = aSelector;
        self.count = count;
        self.countIndex = 0;
    }
    return self;
}
- (void)timerSelAction:(NSTimer *)timer
{
    if (self.count == self.countIndex) {
        [timer invalidate];
    }else{
        if ([self.target respondsToSelector:self.selector]) {
            
            [self.target performSelectorOnMainThread:self.selector withObject:nil waitUntilDone:NO];
            self.countIndex++;
        }else{
            [timer invalidate];
        }
    }
}

@end

@interface HHSafeTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isStop;

@end

@implementation HHSafeTimer

+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval action:(void (^)(NSInteger, BOOL *))block
{
    return [[self alloc] initWithInterval:interval action:block];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval action:(void (^)(NSInteger, BOOL *))block
{
    if (self = [super init]) {
        
        if (self.timer) return self;
        self.timer = [NSTimer timerWithTimeInterval:interval target:[[HHTimerAction alloc]initWithBlock:block] selector:@selector(timerBlockAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}
+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector count:(NSInteger)count
{
    return [[self alloc]initWithInterval:interval target:aTarget selector:aSelector count:count];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector count:(NSInteger)count
{
    if (self = [super init]) {
        
        if (self.timer)return self;
        self.timer = [NSTimer timerWithTimeInterval:interval target:[[HHTimerAction alloc]initWithTarget:aTarget selector:aSelector count:count] selector:@selector(timerSelAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)stop
{
    if (!self.isStop && [self.timer isValid]) {
        self.isStop = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
- (void)resume
{
    if (self.isStop && [self.timer isValid]) {
        self.isStop = NO;
        [self.timer setFireDate:[NSDate date]];
    }
}
- (void)invalidate
{
    if ([self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc
{
    if ([self.timer isValid]){
        [self.timer invalidate];
    }
    self.timer = nil;
}


@end
