//
//  HHRotateViewNormal.m
//  HHDemo
//
//  Created by 豫风 on 2019/6/11.
//  Copyright © 2019 豫风. All rights reserved.
//

#import "HHRotateViewNormal.h"
#import "UIView+HHLayout.h"

@interface HHRotateViewNormal ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HHRotateViewNormal

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configInitialInfo];
    }
    return self;
}

- (void)configInitialInfo {
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"我在测试";
    self.titleLabel.cent_.on_();
}

- (void)updateTitleWithIndex:(NSInteger)index {
    self.titleLabel.text = [NSString stringWithFormat:@"我是第%ld个cell",index];
}

@end
