//
//  UIView+HHLayout.h
//  HHLayout
//
//  Created by yufeng on 2017/12/7.
//  Copyright © 2017年 yufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HHContentPriority) {
    HHContentPriorityDefault,
    HHContentPriorityHigh,
    HHContentPriorityRequired,
};

@interface NSLayoutConstraint (HHLayout)

- (void)removeConstraintFromOwner;

@end

@interface UIView (HHLayout)

/**
 约束方式
 */
@property (nonatomic, assign, readonly) UIView *top_;
@property (nonatomic, assign, readonly) UIView *left_;
@property (nonatomic, assign, readonly) UIView *bott_;
@property (nonatomic, assign, readonly) UIView *righ_;
@property (nonatomic, assign, readonly) UIView *widt_;
@property (nonatomic, assign, readonly) UIView *heit_;
@property (nonatomic, assign, readonly) UIView *lead_;
@property (nonatomic, assign, readonly) UIView *trai_;
@property (nonatomic, assign, readonly) UIView *cent_;
@property (nonatomic, assign, readonly) UIView *centX_;
@property (nonatomic, assign, readonly) UIView *centY_;
@property (nonatomic, assign, readonly) UIView *size_;
@property (nonatomic, assign, readonly) UIView *(^rate_wh)(CGFloat);
@property (nonatomic, assign, readonly) UIView *(^rate_hw)(CGFloat);
@property (nonatomic, assign, readonly) UIView *(^widPriority)(HHContentPriority);
@property (nonatomic, assign, readonly) UIView *(^higPriority)(HHContentPriority);
@property (nonatomic, assign, readonly) UIView *(^equalTo)(UIView *);
@property (nonatomic, assign, readonly) UIView *(^greatThan)(UIView *);
@property (nonatomic, assign, readonly) UIView *(^lessThan)(UIView *);
@property (nonatomic, assign, readonly) UIView *(^mult_)(CGFloat);//width&height
@property (nonatomic, assign, readonly) UIView *(^offset_)(CGFloat);
@property (nonatomic, assign, readonly) UIView *(^offsets_)(NSNumber *,...);//需要以`nil`结尾
@property (nonatomic, assign, readonly) UIView *(^on_)(void);
@property (nonatomic, assign, readonly) UIView *(^removeAll)(void);

/**
 快速添加约束
 */
@property (nonatomic, assign, readonly) UIView *(^topLeft_)(CGRect);//左上距离父控件、宽高固定
@property (nonatomic, assign, readonly) UIView *(^topRight_)(CGRect);//右上距离父控件、宽高固定
@property (nonatomic, assign, readonly) UIView *(^bottomLeft_)(CGRect);//左下距离父控件、宽高固定
@property (nonatomic, assign, readonly) UIView *(^bottomRight_)(CGRect);//右上距离父控件、宽高固定
@property (nonatomic, assign, readonly) UIView *(^heightTop_)(CGRect);//左上右距离父控件、高度固定
@property (nonatomic, assign, readonly) UIView *(^heightBottom_)(CGRect);//左下右距离父控件、高度固定
@property (nonatomic, assign, readonly) UIView *(^insetFrame_)(UIEdgeInsets);//约束四周边距,对应左上下右
@property (nonatomic, assign, readonly) UIView *(^around_)(void);//约束等于父视图

/**
 回调约束对象,可后期修改，做动画eg.
 */
@property (nonatomic, strong, readonly) NSLayoutConstraint *top_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *left_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *bott_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *righ_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *widt_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *heit_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *lead_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *trai_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *centX_cs;
@property (nonatomic, strong, readonly) NSLayoutConstraint *centY_cs;

@end
