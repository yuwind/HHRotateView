//
//  HHMacro.h
//  HHCommon
//
//  Created by yufeng on 2022/4/21.
//

#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 屏幕尺寸

#define mScreenScale ([UIScreen mainScreen].scale)
#define mScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define mIs4_0InchScreen (mScreenHeight == 568)
#define mIs4_7InchScreen (mScreenHeight == 667)
#define mIs5_5InchScreen (mScreenHeight == 736)
#define mIs5_8InchScreen (mScreenHeight == 812 && mScreenWidth == 375)
#define mIs6_1InchScreen ((mScreenHeight == 896 && mScreenWidth == 414) || (mScreenHeight == 844 && mScreenWidth == 390))
#define mIs6_5InchScreen (mScreenHeight == 896 && mScreenWidth == 414)
#define mIs5_4InchScreen (mScreenHeight == 812 && mScreenWidth == 375)
#define mIs6_7InchScreen (mScreenHeight == 926 && mScreenWidth == 428)

#define mIsLargeThan4Inch (mScreenWidth >= 375)
#define mAdapter(value) ((value) * MIN(mScreenWidth, mScreenHeight) / 375.0f)

#define mSystemSafeAreaInsets    mSafeAreaInsets(UIApplication.sharedApplication.keyWindow)
#define mSafeAreaInsets(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsMake(20, 0, 0, 0);} i;})

#define mIsIphoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define mNavigationBarHeight 44
#define mStatusBarHeight mSystemSafeAreaInsets.top
#define mNavigationBarAndStatusBarHeight (mNavigationBarHeight + mStatusBarHeight)
#define mTabBarHeight 49
#define mIndicatorHeight mSystemSafeAreaInsets.bottom
#define mTabBarAndIndicatorHeight (mTabBarHeight + mSystemSafeAreaInsets.bottom)

#pragma mark - 生成颜色
#define mRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]
#define mRGBCGColor(r, g, b) mRGBColor(r, g, b).CGColor
#define mRGBACGColor(r, g, b, a) mRGBAColor(r, g, b, a).CGColor
#define mRGBCGColorToBridge(r,g,b) (__bridge id)mRGBCGColor(r, g, b)
#define mRGBACGColorToBridge(r,g,b,a) (__bridge id)mRGBACGColor(r, g, b, a)

#pragma mark - 生成字体
#define mSystemFont(size) [UIFont systemFontOfSize:(size)]
#define mSystemBoldFont(size) [UIFont boldSystemFontOfSize:(size)]
#define mSystemLightFont(size) [UIFont systemFontOfSize:(size) weight:UIFontWeightLight]
#define mSystemMediumFont(size) [UIFont systemFontOfSize:(size) weight:UIFontWeightMedium]
#define mSystemSemiboldFont(size) [UIFont systemFontOfSize:(size) weight:UIFontWeightSemibold]
#define mSystemItalicFont(size) [UIFont italicSystemFontOfSize:(size)]
#define mCustomFont(name, fontSize) [UIFont fontWithName:(name) size:(fontSize)]

#define dispatch_main_async_safely(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}

#if DEBUG
#define hh_keywordify autoreleasepool {}
#else
#define hh_keywordify try {} @catch (...) {}
#endif

#define weakly(var) hh_keywordify __weak __typeof(var) __weak__##var = var;
#define strongly(var) hh_keywordify __strong typeof(var) var = __weak__##var;

NS_ASSUME_NONNULL_END
