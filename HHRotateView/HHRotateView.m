//
//  HHRotateView.m
//  HHRotateView
//
//  Created by 豫风 on 2019/6/11.
//  Copyright © 2019 豫风. All rights reserved.
//

#import "HHRotateView.h"
#import "UIView+HHLayout.h"
#import "HHSafeTimer.h"

typedef NS_ENUM(NSUInteger, HHScrollDirection) {
    HHScrollDirectionNone,
    HHScrollDirectionLeft,
    HHScrollDirectionRight,
};

@interface HHRotateView ()<UIScrollViewDelegate>

@property (nonatomic, assign) HHRotateViewStyle style;
@property (nonatomic, strong) NSMutableDictionary *dictM;
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
@property (nonatomic, strong) UIView<HHRotateViewDelegate> *supplymentView;

@end

@implementation HHRotateView

- (instancetype)initWithFrame:(CGRect)frame style:(HHRotateViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        [self configInitialInfo];
        [self startAutoScrollAction];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:HHRotateViewHorizonal];
}

- (void)configInitialInfo {
    _timeInterval = 3;
    _dragEnable = YES;
    _shouldAutoScroll = YES;
    _dictM = [NSMutableDictionary dictionary];
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
        _leftView.top_.left_.bott_.widt_.centY
        .equalTo(_scrollView).on_();
        _middleView.left_.top_.bott_.widt_.centY
        .equalTo(_leftView.righ_).on_();
        _rightView.left_.top_.bott_.widt_.centY
        .equalTo(_middleView.righ_).on_();
        _rightView.righ_.equalTo(_scrollView).on_();
    } else if (self.style == HHRotateViewVertical) {
        _leftView.top_.left_.righ_.heit_.centX
        .equalTo(_scrollView).on_();
        _middleView.top_.left_.righ_.heit_.centX
        .equalTo(_leftView.bott_).on_();
        _rightView.top_.left_.righ_.heit_.centX
        .equalTo(_middleView.bott_).on_();
        _rightView.bott_.equalTo(_scrollView).on_();
    }
}

- (void)setAutoScroll:(BOOL)autoScroll {
    [self stopTimerAction];
}

- (void)startAutoScrollAction {
    [self startTimerAction];
}

- (void)startTimerAction {
    [self.safeTimer invalidate];
    self.safeTimer = nil;
    self.safeTimer = [[HHSafeTimer alloc] initWithInterval:self.timeInterval target:self selector:@selector(timerDidFireAction) count:-1];
}

- (void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
    [self startTimerAction];
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
    [self.dictM setValue:cellClass forKey:identifier];
}

- (HHRotateViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier index:(NSInteger)index {
    HHRotateViewCell *cell = [self.reuseDictM objectForKey:identifier];
    cell.index = index;
    if (!cell) {
        Class cellClass = [self.dictM objectForKey:identifier];
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
    [self layoutIfNeeded];
    self.currentIndex = 0;
    self.isRightAdd = NO;
    self.isLeftAdd = NO;
    [self startTimerAction];
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
        [self.middleView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        HHRotateViewCell *cell = [self.dataSource rotateView:self cellForRowAtIndex:0];
        [_middleView addSubview:cell];
        cell.around_();
    }
    if (self.totalRows <= 1) {
        [self stopTimerAction];
        self.scrollView.scrollEnabled = NO;
        [self.supplymentView removeFromSuperview];
    } else {
        if ([self.dataSource respondsToSelector:@selector(viewForSupplementaryView:)]) {
            UIView <HHRotateViewDelegate>*supplyView = [self.dataSource viewForSupplementaryView:self];
            if (supplyView) {
                [self.supplymentView removeFromSuperview];
                self.supplymentView = supplyView;
                [self addSubview:self.supplymentView];
                if ([self.dataSource respondsToSelector:@selector(layoutForSupplementaryView)]) {
                    HHSupplementViewLayout *layout = [self.dataSource layoutForSupplementaryView];
                    if (layout) {
                        [self configSupplymentViewWith:layout];
                    }
                } else {
                    self.supplymentView.bott_.centX
                    .equalTo(self).offset_(-5).on_();
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimerAction];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimerAction];
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
    CGFloat offset = 0;
    if (self.style == HHRotateViewHorizonal) {
        offset = scrollView.contentOffset.x;
        self.direction = offset > self.width ? HHScrollDirectionLeft : offset < self.width ? HHScrollDirectionRight : HHScrollDirectionNone;
    } else if(self.style == HHRotateViewVertical) {
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
            HHRotateViewCell *cell = [self.dataSource rotateView:self cellForRowAtIndex:self.nextIndex];
            [self.leftView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.leftView addSubview:cell];
            cell.around_();
            [self.leftView layoutIfNeeded];
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
            HHRotateViewCell *cell = [self.dataSource rotateView:self cellForRowAtIndex:self.nextIndex];
            [self.rightView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.rightView addSubview:cell];
            cell.around_();
            [self.rightView layoutIfNeeded];
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
    [self.reuseDictM setValue:cell forKey:cell.identifier];
    if (direction == HHScrollDirectionRight) {
        HHRotateViewCell *leftCell = self.leftView.subviews.firstObject;
        [self.middleView addSubview:leftCell];
        leftCell.around_();
        self.isLeftAdd = NO;
    } else if (direction == HHScrollDirectionLeft){
        HHRotateViewCell *rightCell = self.rightView.subviews.firstObject;
        [self.middleView addSubview:rightCell];
        rightCell.around_();
        self.isRightAdd = NO;
    }
    [self.middleView layoutIfNeeded];
    self.currentIndex = self.nextIndex;
    if (self.style == HHRotateViewHorizonal) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0);
    } else if (self.style == HHRotateViewVertical){
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.height);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(rotateView:didScrollAtIndex:)]) {
        [self.delegate rotateView:self didScrollAtIndex:self.currentIndex];
    }
    if (self.supplymentView && [self.supplymentView respondsToSelector:@selector(rotateView:didScrollAtIndex:)]) {
        [self.supplymentView rotateView:self didScrollAtIndex:self.currentIndex];
    }
}

- (void)configSupplymentViewWith:(HHSupplementViewLayout *)layout {
    self.supplymentView.translatesAutoresizingMaskIntoConstraints = NO;
    for (int i = 0; i < layout.relationArray.count; i++) {
        NSInteger relation = [layout.relationArray[i] integerValue];
        CGFloat constant = [layout.constArray[i] floatValue];
        switch (relation) {
            case NSLayoutAttributeLeft: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:constant];
                [self addConstraint:constraint];
            }
                break;
            case NSLayoutAttributeRight: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:constant];
                [self addConstraint:constraint];
            }
                break;
            case NSLayoutAttributeTop: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:constant];
                [self addConstraint:constraint];
            }
                break;
            case NSLayoutAttributeBottom: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:constant];
                [self addConstraint:constraint];
            }
                break;
            case NSLayoutAttributeWidth: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:constant];
                [self.supplymentView addConstraint:constraint];
            }
                break;
            case NSLayoutAttributeHeight: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:constant];
                [self.supplymentView addConstraint:constraint];
            }
                break;
            case NSLayoutAttributeCenterX: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:constant];
                [self addConstraint:constraint];
            }
                break;
            case NSLayoutAttributeCenterY: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.supplymentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:constant];
                [self addConstraint:constraint];
            }
                break;
            default:
                break;
        }
    }
}

@end
