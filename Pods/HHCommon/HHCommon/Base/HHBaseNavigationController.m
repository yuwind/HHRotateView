//
//  HHBaseNavigationController.m
//  BaseTabBar
//
//  Created by yufeng on 2017/6/23.
//  Copyright © 2017年 yufeng. All rights reserved.
//

#import "HHBaseNavigationController.h"

@interface HHBaseNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation HHBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (@available(ios 14.0, *)) {
        viewController.hidesBottomBarWhenPushed = self.viewControllers.count == 1;
    } else {
        viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0;
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1;
}

@end
