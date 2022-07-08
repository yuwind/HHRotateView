//
//  HHSupplymentViewNormal.h
//  HHDemo
//
//  Created by 豫风 on 2019/6/12.
//  Copyright © 2019 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHRotateView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHSupplymentViewStyle) {
    HHSupplymentViewDot,
    HHSupplymentViewBar,
};

@interface HHSupplymentView : UIView<HHRotateViewDelegate>

@property (nonatomic, assign) HHSupplymentViewStyle style;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat margin;

@end

NS_ASSUME_NONNULL_END
