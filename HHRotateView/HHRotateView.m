//
//  HHRotateView.m
//  HHRotateView
//
//  Created by 豫风 on 2019/6/11.
//  Copyright © 2019 豫风. All rights reserved.
//

#import "HHRotateView.h"
#import "HHCommon.h"

typedef NS_ENUM(NSUInteger, HHScrollDirection) {
    HHScrollDirectionNone,
    HHScrollDirectionLeft,
    HHScrollDirectionRight,
};

@interface HHRotateView ()<UIScrollViewDelegate>

@property (nonatomic, assign) HHRotateViewStyle style;
@property (nonatomic, strong) NSMutableDictionary *cellDictM;
@property (nonatomic, strong) NSMutableDictionary *reuseDictM;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, assign) HHScrollDirection direction;
@property (nonatomic, assign) BOOL isLeftAdd;
@property (nonatomic, assign) BOOL isRightAdd;
@property (nonatomic, strong) HHSafeTimer *safeTimer;
@property (nonatomic, assign) CGRect scrollFrame;

@end

@implementation HHRotateView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:HHRotateViewHorizonal];
}

- (instancetype)initWithFrame:(CGRect)frame style:(HHRotateViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        [self configInitialInfo];
        [self startAutoScrollAction];
        [self firstAutoReloadData];
    }
    return self;
}

- (void)configInitialInfo {
    _timeInterval = 5;
    _dragEnable = YES;
    _shouldAutoScroll = YES;
    _cellDictM = [NSMutableDictionary dictionary];
    _reuseDictM = [NSMutableDictionary dictionary];
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    _scrollView.around_();
    
    _leftView = [UIView new];
    [_scrollView addSubview:_leftView];
    _middleView = [UIView new];
    [_scrollView addSubview:_middleView];
    _rightView = [UIView new];
    [_scrollView addSubview:_rightView];
    
    if (self.style == HHRotateViewHorizonal) {
        _leftView.top_.left_.bott_.widt_.centY_
        .equalTo(_scrollView).on_();
        _middleView.left_.top_.bott_.widt_.centY_
        .equalTo(_leftView.righ_).on_();
        _rightView.left_.top_.bott_.widt_.centY_
        .equalTo(_middleView.righ_).on_();
        _rightView.righ_.equalTo(_scrollView).on_();
    } else if (self.style == HHRotateViewVertical) {
        _leftView.top_.left_.righ_.heit_.centX_
        .equalTo(_scrollView).on_();
        _middleView.top_.left_.righ_.heit_.centX_
        .equalTo(_leftView.bott_).on_();
        _rightView.top_.left_.righ_.heit_.centX_
        .equalTo(_middleView.bott_).on_();
        _rightView.bott_.equalTo(_scrollView).on_();
    }
}

- (void)firstAutoReloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

- (void)startAutoScrollAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startTimerActionIfNeeded];
    });
}

- (void)startTimerActionIfNeeded {
    if (self.shouldAutoScroll == NO) {
        return;
    }
    [self.safeTimer invalidate];
    self.safeTimer = nil;
    self.safeTimer = [[HHSafeTimer alloc] initWithInterval:self.timeInterval target:self selector:@selector(timerDidFireAction)];
    [self.safeTimer startWithDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
}

- (void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
}

- (void)setDragEnable:(BOOL)dragEnable {
    _dragEnable = dragEnable;
    self.scrollView.scrollEnabled = dragEnable;
}

- (void)stopTimerAction {
    [self.safeTimer invalidate];
    self.safeTimer = nil;
}

- (void)registerClass:(Class)cellClass identifier:(NSString *)identifier {
    [self.cellDictM setValue:cellClass forKey:identifier];
}

- (HHRotateViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier index:(NSInteger)index {
    HHRotateViewCell *cell = [self.reuseDictM objectForKey:identifier];
    cell.index = index;
    if (cell == nil) {
        Class cellClass = [self.cellDictM objectForKey:identifier];
        cell = [[cellClass alloc] initWithFrame:self.scrollView.bounds];
        cell.identifier = identifier;
        cell.index = index;
        [cell addTarget:self action:@selector(didSelectCellAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)didSelectCellAtIndex:(HHRotateViewCell *)cell {
    if ([self.delegate respondsToSelector:@selector(didSelectCell:index:)]) {
        [self.delegate didSelectCell:cell index:cell.index];
    }
}

- (void)reloadData {
    self.currentIndex = 0;
    self.isRightAdd = NO;
    self.isLeftAdd = NO;
    [self startTimerActionIfNeeded];
    [self.reuseDictM removeAllObjects];
    if (self.style == HHRotateViewHorizonal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:NO];
    } else if (self.style == HHRotateViewVertical) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.height) animated:NO];
    }
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInRotateView:)]) {
        self.totalRows = [self.dataSource numberOfRowsInRotateView:self];
    }
    if (self.totalRows > 0 && [self.dataSource respondsToSelector:@selector(rotateView:cellForRowAtIndex:)]) {
        [self.middleView.subviews.firstObject removeFromSuperview];
        HHRotateViewCell *cell = [self.dataSource rotateView:self cellForRowAtIndex:0];
        [self.middleView addSubview:cell];
        cell.around_();
    }
    if ([self.delegate respondsToSelector:@selector(rotateView:didScrollAtIndex:)]) {
        [self.delegate rotateView:self didScrollAtIndex:0];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimerAction];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimerActionIfNeeded];
}

- (void)timerDidFireAction {
    if (self.shouldAutoScroll == NO) {
        [self stopTimerAction];
        return;
    }
    if (self.style == HHRotateViewHorizonal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * 2, 0) animated:YES];
    } else if (self.style == HHRotateViewVertical) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.height * 2) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!CGRectEqualToRect(scrollView.frame, self.scrollFrame)) {
        return;
    }
    CGFloat offset = 0;
    if (self.style == HHRotateViewHorizonal) {
        offset = scrollView.contentOffset.x;
        self.direction = offset > self.width ? HHScrollDirectionLeft : offset < self.width ? HHScrollDirectionRight : HHScrollDirectionNone;
    } else if (self.style == HHRotateViewVertical) {
        offset = scrollView.contentOffset.y;
        self.direction = offset > self.height ? HHScrollDirectionLeft : offset < self.height ? HHScrollDirectionRight : HHScrollDirectionNone;
    }
    if (self.direction == HHScrollDirectionRight) {
        if (!self.isLeftAdd && self.dataSource && [self.dataSource respondsToSelector:@selector(rotateView:cellForRowAtIndex:)]) {
            self.isLeftAdd = YES;
            self.isRightAdd = NO;
            self.nextIndex = (self.currentIndex - 1);
            if (self.nextIndex < 0) {
                self.nextIndex = self.totalRows - 1;
            }
            self.nextIndex = MAX(0, self.nextIndex);
            [self.leftView.subviews.firstObject removeFromSuperview];
            HHRotateViewCell *cell = [self.dataSource rotateView:self cellForRowAtIndex:self.nextIndex];
            [cell layoutIfNeeded];
            [self.leftView addSubview:cell];
            cell.around_();
        }
        if (self.style == HHRotateViewHorizonal) {
            if (self.scrollView.contentOffset.x <= 0) {
                [self changeToCenterAction:HHScrollDirectionRight];
            }
        } else if(self.style == HHRotateViewVertical) {
            if (self.scrollView.contentOffset.y <= 0) {
                [self changeToCenterAction:HHScrollDirectionRight];
            }
        }
    } else if (self.direction == HHScrollDirectionLeft) {
        if (!self.isRightAdd && [self.dataSource respondsToSelector:@selector(rotateView:cellForRowAtIndex:)]) {
            self.isRightAdd = YES;
            self.isLeftAdd = NO;
            self.nextIndex = (self.currentIndex + 1) % self.totalRows;
            [self.rightView.subviews.firstObject removeFromSuperview];
            HHRotateViewCell *cell = [self.dataSource rotateView:self cellForRowAtIndex:self.nextIndex];
            [cell layoutIfNeeded];
            [self.rightView addSubview:cell];
            cell.around_();
        }
        if (self.style == HHRotateViewHorizonal) {
            if (self.scrollView.contentOffset.x >= self.scrollView.width * 2) {
                [self changeToCenterAction:HHScrollDirectionLeft];
            }
        } else if (self.style == HHRotateViewVertical) {
            if (self.scrollView.contentOffset.y >= self.scrollView.height * 2) {
                [self changeToCenterAction:HHScrollDirectionLeft];
            }
        }
    }
}

- (void)changeToCenterAction:(HHScrollDirection)direction {
    HHRotateViewCell *cell = self.middleView.subviews.firstObject;
    [cell removeFromSuperview];
    if (cell != nil) {
        [self.reuseDictM setValue:cell forKey:cell.identifier ?: @""];
    }
    if (direction == HHScrollDirectionRight) {
        HHRotateViewCell *leftCell = self.leftView.subviews.firstObject;
        [leftCell removeFromSuperview];
        [self.middleView addSubview:leftCell];
        leftCell.around_();
        self.isLeftAdd = NO;
    } else if (direction == HHScrollDirectionLeft){
        HHRotateViewCell *rightCell = self.rightView.subviews.firstObject;
        [rightCell removeFromSuperview];
        [self.middleView addSubview:rightCell];
        rightCell.around_();
        self.isRightAdd = NO;
    }
    self.currentIndex = self.nextIndex;
    if (self.style == HHRotateViewHorizonal) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0);
    } else if (self.style == HHRotateViewVertical){
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.height);
    }
    if ([self.delegate respondsToSelector:@selector(rotateView:didScrollAtIndex:)]) {
        [self.delegate rotateView:self didScrollAtIndex:self.currentIndex];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollFrame = self.scrollView.frame;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0)];
}

@end
