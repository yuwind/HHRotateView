//
//  UIView+HHAdd.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHGestureTypeTap,
    HHGestureTypePan,
    HHGestureTypeSwipe,
    HHGestureTypePinch,
    HHGestureTypeRotation,
    HHGestureTypeLongPress,
} HHGestureType;


NS_ASSUME_NONNULL_BEGIN

@interface UITextField (HHMaxCharacters)

//允许text的最大长度
@property (nonatomic, assign) NSUInteger hh_maxCharacters;

@end

@interface UITextView (HHMaxCharacters)

//允许text的最大长度
@property (nonatomic, assign) NSUInteger hh_maxCharacters;

@end

@interface UIView (HHAdd)

/**
 添加UIView视图
 
 @param callback 设置view属性
 @return 返回view对象
 */
- (UIView *)hh_addView:(void(^_Nullable)(UIView *view))callback;

/**
 添加UILabel视图
 
 @param callback 设置label属性
 @return 返回label对象
 */
- (UILabel *)hh_addLabel:(void(^_Nullable)(UILabel *label))callback;

/**
 添加UIImageView视图
 
 @param callback 设置imageView属性
 @return 返回imageView对象
 */
- (UIImageView *)hh_addImageView:(void(^_Nullable)(UIImageView *imageView))callback;

/**
 添加UIButton视图、点击事件
 
 @param callback 设置button属性
 &param action 设置button点击事件
 @return 返回button对象
 */
- (UIButton *)hh_addButton:(void(^_Nullable)(UIButton *button))callback;
- (UIButton *)hh_addButton:(void(^_Nullable)(UIButton *button))callback action:(void (^_Nullable)(UIButton *sender))action;
- (UIButton *)hh_addButton:(void(^_Nullable)(UIButton *button))callback events:(UIControlEvents)controlEvents action:(void (^_Nullable)(UIButton *sender))action;

/**
 添加UISwitch视图、点击事件
 
 @param callback 设置Switch属性
 &param action 设置Switch点击事件
 @return 返回Switch对象
 */
- (UISwitch *)hh_addSwitch:(void(^_Nullable)(UISwitch *Switch))callback;
- (UISwitch *)hh_addSwitch:(void(^_Nullable)(UISwitch *Switch))callback action:(void (^_Nullable)(UISwitch *Switch))action;

/**
 添加UITextField视图、action依赖hh_maxCharacters
 
 @param callback 设置textField属性
 &param action   设置textField点击事件
 @return 返回textField对象
 */
- (UITextField *)hh_addTextField:(void(^_Nullable)(UITextField *textField))callback;
- (UITextField *)hh_addTextField:(void(^_Nullable)(UITextField *textField))callback action:(void (^_Nullable)(UITextField *textField, BOOL isOverMax))action;

/**
 添加UITextView视图、action依赖hh_maxCharacters
 
 @param callback 设置textView属性
 &param action   设置textView点击事件
 @return 返回textView对象
 */
- (UITextView *)hh_addTextView:(void(^_Nullable)(UITextView *textView))callback;
- (UITextView *)hh_addTextView:(void(^_Nullable)(UITextView *textView))callback action:(void(^_Nullable)(UITextView *textView, BOOL isOverMax))action;

/**
 添加手势

 @param type 添加手势类型
 @param callback 回调手势对象
 @param block 手势回调事件
 */
- (void)hh_addGestureType:(HHGestureType)type gesture:(void(^_Nullable)(id gesture))callback action:(void (^_Nullable)(UIGestureRecognizer *gesture))block;

/**
 增加点击事件
 
 @param block 回调事件
 */
- (void)hh_addClickAction:(void (^_Nullable)(UIView *sender))block;

@end

NS_ASSUME_NONNULL_END
