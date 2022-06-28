//
//  HHSafeTimer.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "HHSafeTimer.h"

@interface PUGTimerAction : NSObject

@property (nonatomic, weak) HHSafeTimer *safeTimer;
@property (nonatomic, copy) void(^blockAction)(NSInteger count, HHSafeTimer *timer);
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak)   id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation PUGTimerAction

- (instancetype)initWithBlock:(void (^)(NSInteger, HHSafeTimer *))block {
    if (self = [super init]) {
        self.count = 0;
        self.blockAction = block;
    }
    return self;
}

- (void)timerBlockAction:(NSTimer *)timer {
    if (self.blockAction) {
        self.count++;
        self.blockAction(self.count,self.safeTimer);
    } else {
        [timer invalidate];
        timer = nil;
    }
}

- (instancetype)initWithTarget:(id)aTarget selector:(SEL)aSelector{
    if (self = [super init]) {
        self.target = aTarget;
        self.selector = aSelector;
        self.count = 0;
    }
    return self;
}

- (void)timerSelAction:(NSTimer *)timer {
    if ([self.target respondsToSelector:self.selector]) {
        self.count++;
        [self.target performSelectorOnMainThread:self.selector withObject:@(self.count) waitUntilDone:NO];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

- (void)resetCountZero {
    self.count = 0;
}

@end

@interface HHSafeTimer ()

@property (nonatomic, strong) PUGTimerAction *timerAction;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HHSafeTimer

- (NSTimeInterval)timeInterval {
    return self.timer.timeInterval;
}

+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval action:(void (^)(NSInteger, HHSafeTimer *))block {
    return [[self alloc] initWithInterval:interval action:block];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval action:(void (^)(NSInteger, HHSafeTimer *))block {
    if (self = [super init]) {
        self.timerAction = [[PUGTimerAction alloc] initWithBlock:block];
        self.timerAction.safeTimer = self;
        self.timer = [NSTimer timerWithTimeInterval:interval target:self.timerAction selector:@selector(timerBlockAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self stop];
    }
    return self;
}

+ (instancetype)safeTimerWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector {
    return [[self alloc] initWithInterval:interval target:aTarget selector:aSelector];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector {
    if (self = [super init]) {
        self.timerAction = [[PUGTimerAction alloc] initWithTarget:aTarget selector:aSelector];
        self.timerAction.safeTimer = self;
        self.timer = [NSTimer timerWithTimeInterval:interval target:self.timerAction selector:@selector(timerSelAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self stop];
    }
    return self;
}

- (void)start {
    [self startWithDate:[NSDate date]];
}

- (void)startWithDate:(NSDate *)date {
    if ([self.timer isValid]) {
        [self.timer setFireDate:date];
    }
}

- (void)reset {
    [self.timerAction resetCountZero];
}

- (void)stop {
    if ([self.timer isValid]) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)resume {
    if ([self.timer isValid]) {
        [self.timer setFireDate:[NSDate date]];
    }
}

- (void)invalidate {
    if ([self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc{
    [self invalidate];
}

@end
