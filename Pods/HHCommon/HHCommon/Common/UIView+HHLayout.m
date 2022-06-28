//
//  UIView+HHLayout.m
//  HHLayout
//
//  Created by yufeng on 2017/12/7.
//  Copyright © 2017年 yufeng. All rights reserved.
//

#import "UIView+HHLayout.h"
#import <objc/runtime.h>

static char * const topConstraintKey        = "topConstraintKey";
static char * const leftConstraintKey       = "leftConstraintKey";
static char * const bottomConstraintKey     = "bottomConstraintKey";
static char * const rightConstraintKey      = "rigthConstraintKey";
static char * const widthConstraintKey      = "widthConstraintKey";
static char * const heightConstraintKey     = "heightConstraintKey";
static char * const leadingConstraintKey    = "leadingConstraintKey";
static char * const trailingConstraintKey   = "trailingConstraintKey";
static char * const centerXConstraintKey    = "centerXConstraintKey";
static char * const centerYConstraintKey    = "centerYConstraintKey";
static char * const layoutArrayMKey         = "layoutArrayMKey";
static char * const offsetArrayMKey         = "offsetArrayMKey";
static char * const relativeViewKey         = "relativeViewKey";

@interface HHLayoutConstraintProxy : NSObject

@property (nonatomic, weak) UIView *associateView;

+ (instancetype)proxyWithView:(UIView *)view;

@end

@implementation HHLayoutConstraintProxy

+ (instancetype)proxyWithView:(UIView *)view {
    HHLayoutConstraintProxy *proxy = [HHLayoutConstraintProxy new];
    proxy.associateView = view;
    return proxy;
}

@end


@interface NSLayoutConstraint ()

@property (nonatomic, strong) HHLayoutConstraintProxy *associateProxy_;

@end

@implementation NSLayoutConstraint (HHLayout)

- (void)removeConstraintFromOwner {
    if (self.associateProxy_.associateView) {
        [self.associateProxy_.associateView removeConstraint:self];
    }
}

- (void)setAssociateProxy_:(HHLayoutConstraintProxy *)associateProxy_ {
    objc_setAssociatedObject(self, @selector(associateProxy_), associateProxy_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HHLayoutConstraintProxy *)associateProxy_ {
    return objc_getAssociatedObject(self, @selector(associateProxy_));
}

@end


@interface UIView ()

@property (nonatomic, strong) NSLayoutConstraint *top_cs;
@property (nonatomic, strong) NSLayoutConstraint *left_cs;
@property (nonatomic, strong) NSLayoutConstraint *bott_cs;
@property (nonatomic, strong) NSLayoutConstraint *righ_cs;
@property (nonatomic, strong) NSLayoutConstraint *widt_cs;
@property (nonatomic, strong) NSLayoutConstraint *heit_cs;
@property (nonatomic, strong) NSLayoutConstraint *lead_cs;
@property (nonatomic, strong) NSLayoutConstraint *trai_cs;
@property (nonatomic, strong) NSLayoutConstraint *centX_cs;
@property (nonatomic, strong) NSLayoutConstraint *centY_cs;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*layoutArrayM;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*offsetArrayM;
@property (nonatomic, strong) UIView *relativeView;
@property (nonatomic, assign) BOOL isWidthSelf;
@property (nonatomic, assign) BOOL isHeightSelf;

@end

static CGFloat multiply_ = 1.0f;
static NSLayoutRelation relation_ = NSLayoutRelationEqual;

@implementation UIView (HHLayout)

- (void)setRelativeView:(UIView *)relativeView {
    objc_setAssociatedObject(self, relativeViewKey, relativeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)relativeView {
    return objc_getAssociatedObject(self, relativeViewKey);
}

- (void)setOffsetArrayM:(NSMutableArray<NSNumber *> *)offsetArrayM {
    objc_setAssociatedObject(self, offsetArrayMKey, offsetArrayM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<NSNumber *> *)offsetArrayM {
    NSMutableArray *offsetArrayM = objc_getAssociatedObject(self, offsetArrayMKey);
    if (offsetArrayM) {
        return offsetArrayM;
    }
    offsetArrayM = [NSMutableArray array];
    self.offsetArrayM = offsetArrayM;
    return offsetArrayM;
}

- (void)setLayoutArrayM:(NSMutableArray<NSNumber *> *)layoutArrayM {
    objc_setAssociatedObject(self, layoutArrayMKey, layoutArrayM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<NSNumber *> *)layoutArrayM {
    NSMutableArray *layoutArrayM = objc_getAssociatedObject(self, layoutArrayMKey);
    if (layoutArrayM) {
        return layoutArrayM;
    }
    layoutArrayM = [NSMutableArray array];
    self.layoutArrayM = layoutArrayM;
    return layoutArrayM;
}

- (void)setTop_cs:(NSLayoutConstraint *)top_cs {
    objc_setAssociatedObject(self, topConstraintKey, top_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)top_cs {
    return objc_getAssociatedObject(self, topConstraintKey);
}

- (void)setLeft_cs:(NSLayoutConstraint *)left_cs {
    objc_setAssociatedObject(self, leftConstraintKey, left_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)left_cs {
    return objc_getAssociatedObject(self, leftConstraintKey);
}

- (void)setBott_cs:(NSLayoutConstraint *)bott_cs {
    objc_setAssociatedObject(self, bottomConstraintKey, bott_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)bott_cs {
    return objc_getAssociatedObject(self, bottomConstraintKey);
}

- (void)setRigh_cs:(NSLayoutConstraint *)righ_cs {
    objc_setAssociatedObject(self, rightConstraintKey, righ_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)righ_cs {
    return objc_getAssociatedObject(self, rightConstraintKey);
}

- (void)setWidt_cs:(NSLayoutConstraint *)widt_cs {
    objc_setAssociatedObject(self, widthConstraintKey, widt_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)widt_cs {
    return objc_getAssociatedObject(self, widthConstraintKey);
}

- (void)setHeit_cs:(NSLayoutConstraint *)heit_cs {
    objc_setAssociatedObject(self, heightConstraintKey, heit_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heit_cs {
    return objc_getAssociatedObject(self, heightConstraintKey);
}

- (void)setLead_cs:(NSLayoutConstraint *)lead_cs {
    objc_setAssociatedObject(self, leadingConstraintKey, lead_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lead_cs {
    return objc_getAssociatedObject(self, leadingConstraintKey);
}

- (void)setTrai_cs:(NSLayoutConstraint *)trai_cs {
    objc_setAssociatedObject(self, trailingConstraintKey, trai_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)trai_cs {
    return objc_getAssociatedObject(self, trailingConstraintKey);
}

- (void)setCentX_cs:(NSLayoutConstraint *)centX_cs {
    objc_setAssociatedObject(self, centerXConstraintKey, centX_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centX_cs {
    return objc_getAssociatedObject(self, centerXConstraintKey);
}

- (void)setCentY_cs:(NSLayoutConstraint *)centY_cs {
    objc_setAssociatedObject(self, centerYConstraintKey, centY_cs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centY_cs {
    return objc_getAssociatedObject(self, centerYConstraintKey);
}

- (UIView *)top_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeTop)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeTop)];
    }
    return self;
}

- (UIView *)left_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeLeft)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeLeft)];
    }
    return self;
}

- (UIView *)bott_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeBottom)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeBottom)];
    }
    return self;
}

- (UIView *)righ_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeRight)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeRight)];
    }
    return self;
}

- (UIView *)widt_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeWidth)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeWidth)];
    }
    return self;
}

- (UIView *)heit_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeHeight)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeHeight)];
    }
    return self;
}

- (UIView *)lead_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeLeading)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeLeading)];
    }
    return self;
}

- (UIView *)trai_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeTrailing)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeTrailing)];
    }
    return self;
}

- (UIView *)cent_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeCenterX)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeCenterX)];
    }
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeCenterY)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeCenterY)];
    }
    return self;
}

- (UIView *)centX_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeCenterX)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeCenterX)];
    }
    return self;
}

- (UIView *)centY_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeCenterY)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeCenterY)];
    }
    return self;
}

- (UIView *)size_ {
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeWidth)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeWidth)];
    }
    if (![self.layoutArrayM containsObject:@(NSLayoutAttributeHeight)]) {
        [self.layoutArrayM addObject:@(NSLayoutAttributeHeight)];
    }
    return self;
}

- (UIView *(^)(CGFloat))rate_wh {
    return ^UIView *(CGFloat rate_wh) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:rate_wh constant:0];
        [self addConstraint:constraint];
        return self;
    };
}

- (UIView *(^)(CGFloat))rate_hw {
    return ^UIView *(CGFloat rate_wh) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:rate_wh constant:0];
        [self addConstraint:constraint];
        return self;
    };
}

//值越高，越不容易拉伸
- (UIView *(^)(HHContentPriority))widPriority {
    return ^UIView *(HHContentPriority priority) {
        switch (priority) {
            case HHContentPriorityDefault:
                [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
                [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
                break;
            case HHContentPriorityHigh:
                [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
                [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
                break;
            case HHContentPriorityRequired:
                [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                break;
            default:
                break;
        }
        return self;
    };
}

//值越高，越不容易拉伸
- (UIView *(^)(HHContentPriority))higPriority {
    return ^UIView *(HHContentPriority priority) {
        switch (priority) {
            case HHContentPriorityDefault:
                [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
                [self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
                break;
            case HHContentPriorityHigh:
                [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
                [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
                break;
            case HHContentPriorityRequired:
                [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                break;
        }
        return self;
    };
}

- (UIView *(^)(UIView *))lessThan {
    return ^UIView *(UIView *view) {
        relation_ = NSLayoutRelationLessThanOrEqual;
        self.relativeView = view;
        return self;
    };
}

- (UIView *(^)(UIView *))equalTo {
    return ^UIView *(UIView *view) {
        self.relativeView = view;
        return self;
    };
}

- (UIView *(^)(UIView *))greatThan {
    return ^UIView *(UIView *view) {
        relation_ = NSLayoutRelationGreaterThanOrEqual;
        self.relativeView = view;
        return self;
    };
}

- (UIView *(^)(CGFloat))mult_ {
    return ^UIView *(CGFloat multiply) {
        multiply_ = multiply;
        return self;
    };
}

- (UIView *(^)(CGFloat))offset_ {
    return ^UIView *(CGFloat offset) {
        [self.offsetArrayM addObject:@(offset)];
        return self;
    };
}

- (UIView *(^)(NSNumber *, ...))offsets_ {
    return ^UIView *(NSNumber *first,...) {
        va_list args;
        va_start(args, first);
        for (NSNumber *offset = first; offset!=nil&&[offset isKindOfClass:[NSNumber class]]; offset = va_arg(args, NSNumber *)) {
            [self.offsetArrayM addObject:offset];
        }
        va_end(args);
        return self;
    };
}

- (UIView *(^)(CGRect))topLeft_ {
    return ^UIView *(CGRect rect) {
        self.top_.left_.widt_.heit_.
        offset_(rect.origin.y).offset_(rect.origin.x).
        offset_(rect.size.width).offset_(rect.size.height).
        on_();
        return self;
    };
}

- (UIView *(^)(CGRect))topRight_ {
    return ^UIView *(CGRect rect) {
        self.top_.righ_.widt_.heit_.
        offset_(rect.origin.y).offset_(-rect.origin.x).
        offset_(rect.size.width).offset_(rect.size.height).
        on_();
        return self;
    };
}

- (UIView *(^)(CGRect))bottomLeft_ {
    return ^UIView *(CGRect rect) {
        self.bott_.left_.widt_.heit_.
        offset_(-rect.origin.y).offset_(rect.origin.x).
        offset_(rect.size.width).offset_(rect.size.height).
        on_();
        return self;
    };
}

- (UIView *(^)(CGRect))bottomRight_ {
    return ^UIView *(CGRect rect) {
        self.bott_.righ_.widt_.heit_.
        offset_(-rect.origin.y).offset_(-rect.origin.x).
        offset_(rect.size.width).offset_(rect.size.height).
        on_();
        return self;
    };
}

- (UIView *(^)(CGRect))heightTop_ {
    return ^UIView *(CGRect rect) {
        self.top_.left_.heit_.righ_.
        offset_(rect.origin.y).offset_(rect.origin.x).
        offset_(rect.size.height).offset_(-rect.size.width).
        on_();
        return self;
    };
}

- (UIView *(^)(CGRect))heightBottom_ {
    return ^UIView *(CGRect rect) {
        self.bott_.left_.heit_.righ_.
        offset_(rect.origin.y).offset_(rect.origin.x).
        offset_(rect.size.height).offset_(-rect.size.width).
        on_();
        return self;
    };
}

- (UIView *(^)(UIEdgeInsets))insetFrame_ {
    return ^UIView *(UIEdgeInsets inset) {
        self.top_.left_.bott_.righ_.
        offset_(inset.top).offset_(inset.left).
        offset_(-inset.bottom).offset_(-inset.right).
        on_();
        return self;
    };
}

- (UIView *(^)(void))around_ {
    return ^UIView *() {
        self.left_.top_.bott_.righ_.equalTo(self.superview).on_();
        return self;
    };
}

- (UIView *(^)(void))removeAll {
    return ^UIView *() {
        [self removeAllConstraint_];
        return self;
    };
}

- (void)removeAllConstraint_ {
    if (self.widt_cs) {
        [self.widt_cs removeConstraintFromOwner];
        self.widt_cs = nil;
    }
    if (self.heit_cs) {
        [self.heit_cs removeConstraintFromOwner];
        self.heit_cs = nil;
    }
    if (self.top_cs) {
        [self.top_cs removeConstraintFromOwner];
        self.top_cs = nil;
    }
    if (self.left_cs) {
        [self.left_cs removeConstraintFromOwner];
        self.left_cs = nil;
    }
    if (self.bott_cs) {
        [self.bott_cs removeConstraintFromOwner];
        self.bott_cs = nil;
    }
    if (self.righ_cs) {
        [self.righ_cs removeConstraintFromOwner];
        self.righ_cs = nil;
    }
    if (self.lead_cs) {
        [self.lead_cs removeConstraintFromOwner];
        self.lead_cs = nil;
    }
    if (self.trai_cs) {
        [self.trai_cs removeConstraintFromOwner];
        self.trai_cs = nil;
    }
    if (self.centX_cs) {
        [self.centX_cs removeConstraintFromOwner];
        self.centX_cs = nil;
    }
    if (self.centY_cs) {
        [self.centY_cs removeConstraintFromOwner];
        self.centY_cs = nil;
    }
}

- (UIView *(^)(void))on_ {
    return ^UIView *() {
        [self installAllConstraint];
        [self resetLayoutInitialInfo];
        return self;
    };
}

- (void)resetLayoutInitialInfo {
    multiply_ = 1.0f;
    relation_ = NSLayoutRelationEqual;
    [self.offsetArrayM removeAllObjects];
    [self.layoutArrayM removeAllObjects];
    self.offsetArrayM = nil;
    self.layoutArrayM = nil;
    if (self.relativeView) {
        [self.relativeView.offsetArrayM removeAllObjects];
        [self.relativeView.layoutArrayM removeAllObjects];
        self.relativeView.offsetArrayM = nil;
        self.relativeView.layoutArrayM = nil;
        self.relativeView = nil;
    }
}

- (void)installAllConstraint {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    for (int i = 0; i < self.layoutArrayM.count; i++) {
        NSInteger relative = 0;
        CGFloat constant = 0.0f;
        if (self.relativeView != nil) {
            relative = self.relativeView.layoutArrayM.count>i?self.relativeView.layoutArrayM[i].integerValue:self.layoutArrayM[i].integerValue;
            constant = self.offsetArrayM.count>i?self.offsetArrayM[i].floatValue:0.0f;
        } else {
            relative = self.layoutArrayM[i].integerValue;
            constant = self.offsetArrayM.count>i?self.offsetArrayM[i].floatValue:self.offsetArrayM.lastObject.floatValue;
        }
        [self readyDeploy:self.layoutArrayM[i].integerValue relative:relative view:self.relativeView equalTo:constant];
    }
}

- (void)readyDeploy:(NSInteger)source relative:(NSInteger)relative view:(UIView *)view equalTo:(CGFloat)constant {
    UIView *commonSuperview = [self closestCommonSuperview:view];
    switch (source) {
        case NSLayoutAttributeLeft: {
            if (self.left_cs) {
                [self.left_cs removeConstraintFromOwner];
            }
            self.left_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.left_cs];
            self.left_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
        case NSLayoutAttributeRight: {
            if (self.righ_cs) {
                [self.righ_cs removeConstraintFromOwner];
            }
            self.righ_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.righ_cs];
            self.righ_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
        case NSLayoutAttributeTop: {
            if (self.top_cs) {
                [self.top_cs removeConstraintFromOwner];
            }
            self.top_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.top_cs];
            self.top_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
        case NSLayoutAttributeBottom: {
            if (self.bott_cs) {
                [self.bott_cs removeConstraintFromOwner];
            }
            self.bott_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.bott_cs];
            self.bott_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
        case NSLayoutAttributeLeading: {
            if (self.lead_cs) {
                [self.lead_cs removeConstraintFromOwner];
            }
            self.lead_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.lead_cs];
            self.lead_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
        case NSLayoutAttributeTrailing: {
            if (self.trai_cs) {
                [self.trai_cs removeConstraintFromOwner];
            }
            self.trai_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.trai_cs];
            self.trai_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
        case NSLayoutAttributeWidth: {
            if (self.widt_cs) {
                [self.widt_cs removeConstraintFromOwner];
            }
            self.widt_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:relation_ toItem:self.offsetArrayM.count&&constant?nil:view attribute:relative multiplier:multiply_ constant:constant];
            UIView *resultView = self.offsetArrayM.count&&constant?self:view?commonSuperview:self;
            [resultView addConstraint:self.widt_cs];
            self.widt_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:resultView];
        }
            break;
        case NSLayoutAttributeHeight: {
            if (self.heit_cs) {
                [self.heit_cs removeConstraintFromOwner];
            }
            self.heit_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:relation_ toItem:self.offsetArrayM.count&&constant?nil:view attribute:relative multiplier:multiply_ constant:constant];
            UIView *resultView = self.offsetArrayM.count&&constant?self:view?commonSuperview:self;
            [resultView addConstraint:self.heit_cs];
            self.heit_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:resultView];
        }
            break;
        case NSLayoutAttributeCenterX: {
            if (self.centX_cs) {
                [self.centX_cs removeConstraintFromOwner];
            }
            self.centX_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.centX_cs];
            self.centX_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
        case NSLayoutAttributeCenterY: {
            if (self.centY_cs) {
                [self.centY_cs removeConstraintFromOwner];
            }
            self.centY_cs = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:relation_ toItem:view?:self.superview attribute:relative multiplier:1.0 constant:constant];
            [commonSuperview addConstraint:self.centY_cs];
            self.centY_cs.associateProxy_ = [HHLayoutConstraintProxy proxyWithView:commonSuperview];
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)closestCommonSuperview:(nullable UIView *)view {
    if (view == nil) {
        return self.superview;
    }
    UIView *closestCommonSuperview = nil;
    UIView *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        UIView *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
