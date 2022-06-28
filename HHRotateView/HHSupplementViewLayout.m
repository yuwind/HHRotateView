//
//  HHSupplementViewLayout.m
//  HHRotateView
//
//  Created by 豫风 on 2019/6/12.
//  Copyright © 2019 豫风. All rights reserved.
//

#import "HHSupplementViewLayout.h"

@interface HHSupplementViewLayout ()

@property (nonatomic, strong) NSMutableArray *relationArrayM;
@property (nonatomic, strong) NSMutableArray *constArrayM;

@end


@implementation HHSupplementViewLayout

- (HHSupplementViewLayout * (^)(CGFloat))left {
    return ^HHSupplementViewLayout * (CGFloat padding){
        [self.relationArrayM addObject:@(NSLayoutAttributeLeft)];
        [self.constArrayM addObject:@(padding)];
        return self;
    };
}

- (HHSupplementViewLayout * (^)(CGFloat))right {
    return ^HHSupplementViewLayout * (CGFloat padding){
        [self.relationArrayM addObject:@(NSLayoutAttributeRight)];
        [self.constArrayM addObject:@(padding)];
        return self;
    };
}

- (HHSupplementViewLayout *(^)(CGFloat))top {
    return ^HHSupplementViewLayout * (CGFloat padding){
        [self.relationArrayM addObject:@(NSLayoutAttributeTop)];
        [self.constArrayM addObject:@(padding)];
        return self;
    };
}

- (HHSupplementViewLayout *(^)(CGFloat))bottom {
    return ^HHSupplementViewLayout * (CGFloat padding){
        [self.relationArrayM addObject:@(NSLayoutAttributeBottom)];
        [self.constArrayM addObject:@(padding)];
        return self;
    };
}

- (HHSupplementViewLayout *(^)(CGFloat))height {
    return ^HHSupplementViewLayout * (CGFloat padding){
        [self.relationArrayM addObject:@(NSLayoutAttributeHeight)];
        [self.constArrayM addObject:@(padding)];
        return self;
    };
}

- (HHSupplementViewLayout *(^)(CGSize))size {
    return ^HHSupplementViewLayout * (CGSize size){
        [self.relationArrayM addObject:@(NSLayoutAttributeWidth)];
        [self.relationArrayM addObject:@(NSLayoutAttributeHeight)];
        [self.constArrayM addObject:@(size.width)];
        [self.constArrayM addObject:@(size.height)];
        return self;
    };
}

- (HHSupplementViewLayout *(^)(CGFloat))centX {
    return ^HHSupplementViewLayout * (CGFloat padding){
        [self.relationArrayM addObject:@(NSLayoutAttributeCenterX)];
        [self.constArrayM addObject:@(padding)];
        return self;
    };
}

- (HHSupplementViewLayout *(^)(CGFloat))centY {
    return ^HHSupplementViewLayout * (CGFloat padding){
        [self.relationArrayM addObject:@(NSLayoutAttributeCenterY)];
        [self.constArrayM addObject:@(padding)];
        return self;
    };
}

- (NSArray *)relationArray {
    return self.relationArrayM.copy;
}

- (NSArray *)constArray {
    return self.constArrayM.copy;
}

- (NSMutableArray *)relationArrayM {
    if (!_relationArrayM) {
        _relationArrayM = [NSMutableArray array];
    }
    return _relationArrayM;
}

- (NSMutableArray *)constArrayM {
    if (!_constArrayM) {
        _constArrayM = [NSMutableArray array];
    }
    return _constArrayM;
}

@end
