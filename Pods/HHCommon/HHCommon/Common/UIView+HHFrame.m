//
//  UIView+HHFrame.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "UIView+HHFrame.h"

@implementation UIView (HHFrame)

- (void)setX:(CGFloat)x {
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setMaxX:(CGFloat)maxX {
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = maxX - self.width;
    self.frame = tempFrame;
}

- (CGFloat)maxX {
    return self.x+self.width;
}

- (void)setMaxY:(CGFloat)maxY {
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = maxY - self.height;
    self.frame = tempFrame;
}

- (CGFloat)maxY {
    return self.y+self.height;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint centerPoint = self.center;
    centerPoint.x = centerX;
    self.center = centerPoint;
}

-(CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint centerPoint = self.center;
    centerPoint.y = centerY;
    self.center = centerPoint;
}

@end
