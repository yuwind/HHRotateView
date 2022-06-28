//
//  HHBaseViewController.m
//  BaseTabBar
//
//  Created by yufeng on 2017/6/23.
//  Copyright © 2017年 yufeng. All rights reserved.
//

#import "HHBaseViewController.h"
#import "HHMacro.h"

@interface HHBaseViewController ()

@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSLayoutConstraint *navTopConstraint;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation HHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseViewInfo];
    [self configBaseConstraints];
}

- (void)configBaseViewInfo {
    self.navBarView = [UIView new];
    [self.view addSubview:self.navBarView];
    self.navBarView.backgroundColor = [UIColor whiteColor];

    self.navView = [UIView new];
    [self.navBarView addSubview:self.navView];
    self.navView.backgroundColor = [UIColor clearColor];
    
    self.containerView = [UIView new];
    [self.view addSubview:self.containerView];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:self.backButton];
    self.backButton.tintColor = [UIColor blackColor];
    UIImage *image = [[self backButtonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:image forState:UIControlStateNormal];
    [self.backButton setImage:image forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.navView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
}

- (UIImage *)backButtonImage {
    static NSString *imagePath = nil;
    if (imagePath != nil) {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    NSBundle *mainBundle = [NSBundle bundleForClass:HHBaseViewController.class];
    NSString *bundlePath = [mainBundle pathForResource:@"BaseBundle.bundle" ofType:nil];
    NSString *resourceName = [UIScreen mainScreen].scale == 3 ? @"nav_back_icon@3x.png" : @"nav_back_icon@2x.png";
    imagePath = [[NSBundle bundleWithPath:bundlePath] pathForResource:resourceName ofType:nil];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void)configBaseConstraints {
    self.navBarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.navTopConstraint = [NSLayoutConstraint constraintWithItem:self.navBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *navHeight = [NSLayoutConstraint constraintWithItem:self.navBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:mNavigationBarAndStatusBarHeight];
    [self.view addConstraint:self.navTopConstraint];
    [self.navBarView addConstraint:navHeight];
    NSDictionary *navBarDict = NSDictionaryOfVariableBindings(_navBarView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navBarView]|" options:0 metrics:nil views:navBarDict]];
    
    self.navView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *navDict = NSDictionaryOfVariableBindings(_navView);
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_navView(44)]|" options:0 metrics:nil views:navDict]];
    [self.navBarView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navView]|" options:0 metrics:nil views:navDict]];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *titleCenterX = [NSLayoutConstraint constraintWithItem:self.self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.navView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *titleCenterY = [NSLayoutConstraint constraintWithItem:self.self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.navView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.navView addConstraints:@[titleCenterX, titleCenterY]];
    
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *buttonDict = NSDictionaryOfVariableBindings(_backButton);
    [self.navView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[_backButton(44)]" options:0 metrics:nil views:buttonDict]];
    [self.navView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backButton]|" options:0 metrics:nil views:buttonDict]];
    
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *containerDict = NSDictionaryOfVariableBindings(_navBarView, _containerView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_navBarView]-0-[_containerView]|" options:0 metrics:nil views:containerDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_containerView]|" options:0 metrics:nil views:containerDict]];
}

- (void)backButtonClick:(UIButton *)sender {
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showNavBar:(BOOL)isShow animation:(BOOL)animate {
    self.navTopConstraint.constant = (isShow ? 0 : -mNavigationBarAndStatusBarHeight);
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }];
    } else {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.titleLabel.text = title;
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
