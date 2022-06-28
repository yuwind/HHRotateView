//
//  UIView+HHAdd.m
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import "UIView+HHAdd.h"
#import <objc/runtime.h>

#define mViewAddress(view) [NSString stringWithFormat:@"%p",view]

static char * const kActionMutableDictionary  = "kActionMutableDictionary";
static char * const kTextFieldMaxChar         = "kTextFieldMaxChar";
static char * const kTextViewMaxChar          = "kTextViewMaxChar";

@implementation UITextField (HHMaxCharacters)

- (void)setHh_maxCharacters:(NSUInteger)hh_maxCharacters {
    objc_setAssociatedObject(self, kTextFieldMaxChar, @(hh_maxCharacters), OBJC_ASSOCIATION_ASSIGN);
}
- (NSUInteger)hh_maxCharacters {
    return ((NSNumber *)objc_getAssociatedObject(self, kTextFieldMaxChar)).unsignedIntegerValue;
}

@end

@implementation UITextView (HHMaxCharacters)

- (void)setHh_maxCharacters:(NSUInteger)hh_maxCharacters {
    objc_setAssociatedObject(self, kTextViewMaxChar, @(hh_maxCharacters), OBJC_ASSOCIATION_ASSIGN);
}

- (NSUInteger)hh_maxCharacters {
    return ((NSNumber *)objc_getAssociatedObject(self, kTextViewMaxChar)).unsignedIntegerValue;
}

@end

@interface UIView () < UITextViewDelegate >

@end

@implementation UIView (HHAdd)

#pragma mark -- 快速添加视图

- (UIView *)hh_addView:(void(^)(UIView *))callback {
    UIView *view_ = [UIView new];
    [self addSubview:view_];
    if(callback)callback(view_);
    return view_;
}

- (UILabel *)hh_addLabel:(void (^)(UILabel *))callback {
    UILabel *label_ = [UILabel new];
    [self addSubview:label_];
    if(callback)callback(label_);
    return label_;
}

- (UIImageView *)hh_addImageView:(void(^)(UIImageView *))callback {
    UIImageView *imageView_ = [UIImageView new];
    [self addSubview:imageView_];
    if(callback)callback(imageView_);
    return imageView_;
}

- (UIButton *)hh_addButton:(void (^)(UIButton *))callback {
    return [self hh_addButton:callback action:nil];
}

- (UIButton *)hh_addButton:(void(^)(UIButton *))callback action:(void (^)(UIButton *))action {
    return [self hh_addButton:callback events:UIControlEventTouchUpInside action:action];
}

- (UIButton *)hh_addButton:(void (^)(UIButton *))callback events:(UIControlEvents)controlEvents action:(void (^)(UIButton *))action {
    UIButton *button_ = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button_];
    if(callback)callback(button_);
    if (action != nil) {
        [self.actionMutableDictionary setValue:action forKey:mViewAddress(button_)];
        [button_ addTarget:self action:@selector(hh_buttonClicked:) forControlEvents:controlEvents];
    }
    return button_;
}

- (void)hh_buttonClicked:(UIButton *)sender {
    void (^block)(UIButton *) = [self.actionMutableDictionary objectForKey:mViewAddress(sender)];
    if (block) {
        block(sender);
    }
}

- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *))callback {
    return [self hh_addSwitch:callback action:nil];
}

- (UISwitch *)hh_addSwitch:(void(^)(UISwitch *))callback action:(void (^)(UISwitch *))action {
    UISwitch *switch_ = [UISwitch new];
    [self addSubview:switch_];
    if(callback)callback(switch_);
    if (action != nil) {
        [self.actionMutableDictionary setValue:action forKey:mViewAddress(switch_)];
        [switch_ addTarget:self action:@selector(hh_switchClickedAction:) forControlEvents:UIControlEventValueChanged];
    }
    return switch_;
}

- (void)hh_switchClickedAction:(UISwitch *)Switch {
    void (^block)(UISwitch *) = [self.actionMutableDictionary objectForKey:mViewAddress(Switch)];
    if (block) {
        block(Switch);
    }
}

- (UITextField *)hh_addTextField:(void (^)(UITextField *))callback {
    return [self hh_addTextField:callback action:nil];
}

- (UITextField *)hh_addTextField:(void (^)(UITextField *))callback action:(void (^)(UITextField *,BOOL))action {
    UITextField *textField_ = [UITextField new];
    [self addSubview:textField_];
    if(callback)callback(textField_);
    if (action != nil) {
        [self.actionMutableDictionary setValue:action forKey:mViewAddress(textField_)];
        [textField_ addTarget:self action:@selector(hh_textFieldChangedAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return textField_;
}

- (void)hh_textFieldChangedAction:(UITextField *)textField {
    void(^block)(UITextField *, BOOL) = [self.actionMutableDictionary objectForKey:mViewAddress(textField)];
    if (block == nil || textField.hh_maxCharacters == 0) {
        return;
    }
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if(selectedRange && position) {
        return;
    }
    NSString *nameString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    textField.text = nameString;
    BOOL isOverMax = NO;
    if (nameString.length > textField.hh_maxCharacters) {
        NSRange rangeIndex = [nameString rangeOfComposedCharacterSequenceAtIndex:textField.hh_maxCharacters];
        isOverMax = YES;
        if (rangeIndex.length == 1) {
            textField.text = [nameString substringToIndex:textField.hh_maxCharacters];
        } else {
            NSRange rangeRange = [nameString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, textField.hh_maxCharacters)];
            textField.text = [nameString substringWithRange:rangeRange];
        }
    }
    block(textField, isOverMax);
}

- (UITextView *)hh_addTextView:(void(^)(UITextView *))callback {
    return [self hh_addTextView:callback action:nil];
}

- (UITextView *)hh_addTextView:(void (^)(UITextView *))callback action:(void (^)(UITextView *, BOOL))action {
    UITextView *textView_ = [UITextView new];
    [self addSubview:textView_];
    if (action != nil) {
        [self.actionMutableDictionary setValue:action forKey:mViewAddress(textView_)];
        textView_.delegate = self;
    }
    if(callback)callback(textView_);
    return textView_;
}

- (void)textViewDidChange:(UITextView *)textView {
    void(^block)(UITextView *,BOOL) = [self.actionMutableDictionary objectForKey:mViewAddress(textView)];
    if (block == nil || textView.hh_maxCharacters == 0) {
        return;
    }
    UITextRange *editRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:editRange.start offset:0];
    if (editRange && position) {
        return;
    }
    
    BOOL isOverMax = NO;
    if (textView.text.length > textView.hh_maxCharacters) {
        isOverMax = YES;
        textView.text = [textView.text substringToIndex:textView.hh_maxCharacters];
    }
    block(textView, isOverMax);
}

- (void)hh_addGestureType:(HHGestureType)type gesture:(void (^)(id _Nonnull))callback action:(void (^)(UIGestureRecognizer * _Nonnull))block {
    UIGestureRecognizer *gestureRec = nil;
    switch (type) {
        case HHGestureTypeTap:
            gestureRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypePan:
            gestureRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypeSwipe:
            gestureRec = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypePinch:
            gestureRec = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypeRotation:
            gestureRec = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        case HHGestureTypeLongPress:
            gestureRec = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
        default:
            gestureRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hh_gestureRecognizerDidChanged:)];
            break;
    }
    [self addGestureRecognizer:gestureRec];
    [self.actionMutableDictionary setValue:block forKey:mViewAddress(gestureRec)];
    if (callback) {
        callback(gestureRec);
    }
}

- (void)hh_gestureRecognizerDidChanged:(UIGestureRecognizer *)gesture {
    void (^block)(UIGestureRecognizer *) = [self.actionMutableDictionary objectForKey:mViewAddress(gesture)];
    if (block) {
        block(gesture);
    }
}

- (void)hh_addClickAction:(void (^_Nullable)(UIView *sender))block {
    if ([self isKindOfClass:UIControl.class]) {
        UIControlEvents events = UIControlEventTouchUpInside;
        if ([self isKindOfClass:UISwitch.class]) {
            events = UIControlEventValueChanged;
        } else if ([self isKindOfClass:UITextField.class]) {
            events = UIControlEventEditingChanged;
        }
        [self hh_addBlockEvents:events action:block];
        return;
    }
    self.userInteractionEnabled = YES;
    __weak __typeof(self) weakSelf = self;
    [self hh_addGestureType:HHGestureTypeTap gesture:nil action:^(UIGestureRecognizer * _Nonnull gesture) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (block) {
            block(strongSelf);
        }
    }];
}

- (void)hh_addBlockEvents:(UIControlEvents)controlEvents action:(void (^)(UIControl *sender))block {
    if (![self isKindOfClass:[UIControl class]] || block == nil) {
        return;
    }
    [self.actionMutableDictionary setValue:block forKey:mViewAddress(self)];
    UIControl *control = (UIControl *)self;
    [control addTarget:self action:@selector(hh_controlClickedAction:) forControlEvents:controlEvents];
}

- (void)hh_controlClickedAction:(UIControl *)control {
    void (^block)(UIControl *) = [self.actionMutableDictionary objectForKey:mViewAddress(control)];
    if (block) {
        block(control);
    }
}

- (NSMutableDictionary *)actionMutableDictionary {
    NSMutableDictionary *dictionaryM = objc_getAssociatedObject(self, kActionMutableDictionary);
    if (dictionaryM != nil) {
        return dictionaryM;
    }
    dictionaryM = @{}.mutableCopy;
    objc_setAssociatedObject(self, kActionMutableDictionary, dictionaryM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dictionaryM;
}

@end
