//
//  HHEnableInsetsLabel.m
//  HHCommon
//
//  Created by yufeng on 2022/5/2.
//

#import "HHEnableInsetsLabel.h"

@implementation HHEnableInsetsLabel

- (void)drawTextInRect:(CGRect)rect {
    CGRect newRect = UIEdgeInsetsInsetRect(rect, self.edgeInsets);
    [super drawTextInRect:newRect];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end
