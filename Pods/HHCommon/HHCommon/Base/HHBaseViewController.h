//
//  HHBaseViewController.h
//  BaseTabBar
//
//  Created by yufeng on 2017/6/23.
//  Copyright © 2017年 yufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHBaseViewController : UIViewController

@property (nonatomic, strong, readonly) UIView *navBarView;
@property (nonatomic, strong, readonly) UIView *navView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) UIView *containerView;

/**
 动态显示navBar

 @param isShow 是否显示
 @param animate 是否需要动画
 */
- (void)showNavBar:(BOOL)isShow animation:(BOOL)animate;

/**
 强制设置转屏

 @param orientation 转屏方向
 */
- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
