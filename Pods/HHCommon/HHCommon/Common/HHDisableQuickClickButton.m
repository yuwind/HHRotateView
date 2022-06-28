//
//  HHDisableQuickClickButton.m
//  HHCommon
//
//  Created by yufeng on 2022/5/2.
//


#import "HHDisableQuickClickButton.h"

@interface HHDisableQuickClickButton ()

@property (nonatomic, assign) CGFloat lastClickTime;

@end

@implementation HHDisableQuickClickButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _disableInterval = 0.25;
    }
    return self;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.disableInterval <= 0) {
        [super sendAction:action to:target forEvent:event];
        return;
    }
    CGFloat currentTime = CACurrentMediaTime();
    if (currentTime - self.lastClickTime >= self.disableInterval) {
        self.lastClickTime = currentTime;
        [super sendAction:action to:target forEvent:event];
    }
}

@end
