//
//  HHSupplymentViewNormal.m
//  HHDemo
//
//  Created by 豫风 on 2019/6/12.
//  Copyright © 2019 豫风. All rights reserved.
//

#import "HHSupplymentView.h"
#import "UIView+HHLayout.h"

@interface HHSupplymentView ()

@property (nonatomic, strong) NSMutableArray<UIView *> *pageArrayM;

@end

@implementation HHSupplymentView

- (void)configInitialInfo {
    if (self.numberOfPages <= 1) {
        return;
    }
    UIView *lastView = nil;
    [self.pageArrayM removeAllObjects];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    for (int i = 0; i < self.numberOfPages; i++) {
        UIView *pageView = [UIView new];
        [self addSubview:pageView];
        [self.pageArrayM addObject:pageView];
        if (self.style == HHSupplymentViewDot) {
            pageView.layer.cornerRadius = 2.5;
            pageView.clipsToBounds = YES;
            pageView.size_.constList(@(5),@(5),nil).on_();
        } else if (self.style == HHSupplymentViewBar) {
            pageView.layer.cornerRadius = 1.5;
            pageView.clipsToBounds = YES;
            pageView.size_.constList(@(12),@(3),nil).on_();
        }
        if (i == 0) {
            pageView.backgroundColor = self.currentColor;
            pageView.left_.top_.bott_.centY.equalTo(self).on_();
        } else if (i == self.numberOfPages-1){
            pageView.backgroundColor = self.normalColor;
            pageView.left_.centY.equalTo(lastView.righ_)
            .offset_(self.margin?:5).on_();
            pageView.righ_.equalTo(self).on_();
        } else {
            pageView.backgroundColor = self.normalColor;
            pageView.left_.centY.equalTo(lastView.righ_)
            .offset_(self.margin?:5).on_();
        }
        lastView = pageView;
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self configInitialInfo];
}

- (void)setStyle:(HHSupplymentViewStyle)style {
    _style = style;
    [self configInitialInfo];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (self.pageArrayM.count > currentPage) {
        self.pageArrayM[_currentPage].backgroundColor = self.normalColor;
        self.pageArrayM[currentPage].backgroundColor = self.currentColor;
    }
    _currentPage = currentPage;
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self setupPageViewColor];
}

- (void)setCurrentColor:(UIColor *)currentColor {
    _currentColor = currentColor;
    [self setupPageViewColor];
}

- (void)setupPageViewColor {
    [self.pageArrayM enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.currentPage) {
            obj.backgroundColor = self.currentColor;
        } else {
            obj.backgroundColor = self.normalColor;
        }
    }];
}

- (void)rotateView:(HHRotateView *)rotateView didScrollAtIndex:(NSInteger)index {
    self.currentPage = index;
}

- (NSMutableArray *)pageArrayM {
    if (!_pageArrayM) {
        _pageArrayM = [NSMutableArray array];
    }
    return _pageArrayM;
}

@end
