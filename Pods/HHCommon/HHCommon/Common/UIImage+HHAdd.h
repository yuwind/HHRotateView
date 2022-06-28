//
//  UIImage+HHAdd.h
//  HHCommon
//
//  Created by yufeng on 2022/5/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHGradientType) {
    HHGradientTypeTopToBottom = 0, //从上到小
    HHGradientTypeLeftToRight = 1, //从左到右
    HHGradientTypeUpleftToLowright = 2, //左上到右下
    HHGradientTypeUprightToLowleft = 3, //右上到左下
};

@interface UIImage (HHAdd)

/**
 生成尺寸是1pt*1pt的纯色图片，可以自己拉伸
 
 @param color 颜色
 @return 图片实例
 */
+ (nullable UIImage *)hh_imageWithColor:(UIColor *)color; // size is 1x1

/**
 生成指定尺寸的纯色图片
 
 @param color 颜色
 @param size 尺寸
 @return 图片实例
 */
+ (nullable UIImage *)hh_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 将当前图片变为指定颜色，透明部分不会被着色
 
 @param color 颜色
 @return 图片实例
 */
- (UIImage *)hh_imageTintedWithColor:(UIColor *)color;

/**
 生成渐变图片
 
 @param width 宽度
 @param height 高度
 @param from 渐变开始颜色
 @param to 渐变结束颜色
 @param type 渐变方向
 
 @return 图片实例
 */
+ (UIImage *)hh_gradientImageWithWidth:(NSUInteger)width height:(NSUInteger)height from:(UIColor*)from to:(UIColor*)to type:(HHGradientType)type;

/// 生成渐变图片
/// @param size image size
/// @param colors 渐变色数组
/// @param type 渐变方向
+ (UIImage *)hh_gradientImageWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors type:(HHGradientType)type;
/**
 生成渐变图片，方向为从上至下
 
 @param width 宽度
 @param height 高度
 @param from 渐变开始颜色
 @param to 渐变结束颜色
 
 @return 图片实例
 */
+ (UIImage *)hh_gradientImageWithWidth:(NSUInteger)width height:(NSUInteger)height from:(UIColor*)from to:(UIColor*)to;

/**
 生成渐变图片
 
 @param size 生成图片的尺寸
 @param start 渐变开始颜色
 @param end 渐变结束颜色
 @param angle 渐变角度
 @param scale 渐变比例
 
 @return 图片实例
 */
+ (UIImage *)hh_gradientImageForSize:(CGSize)size start:(UIColor *)start end:(UIColor *)end angle:(CGFloat)angle scale:(CGFloat)scale;

/**
 通过CAGradientLayer生成渐变图片
 
 @param gradientLayer CAGradientLayer实例
 @param start 渐变开始颜色
 @param end 渐变结束颜色
 @param scale 渐变比例
 
 @return 图片实例
 */
+ (UIImage *)hh_gradientImageForLayer:(CAGradientLayer *)gradientLayer start:(UIColor *)start end:(UIColor *)end angle:(CGFloat)angle scale:(CGFloat)scale;

/**
 按照新的尺寸 中心对其 裁剪图片

 @param size 新的size
 @return 新的图片实例
 */
- (UIImage *)hh_imageCroppedAtCenterWithSize:(CGSize)size;

/**
 按照指定的frame裁剪图片

 @param frame frame
 @return 新的图片实例
 */
- (UIImage *)hh_imageCroppedForFrame:(CGRect)frame;

/**
 将图片裁剪为指定尺寸的圆角图片

 @param size 给定的尺寸
 @return 新的图片实例
 */
- (UIImage *)hh_roundImageWithSize:(CGSize)size;
- (UIImage *)hh_ImageWithCornerRadius:(CGFloat)cornerRadius;

/**
 获取一个高斯模糊的Image
 
 @param blurRadius 设置模糊滤镜的模糊半径
 */
- (UIImage *)imageWithBlurRadius:(CGFloat)blurRadius;

// Fix the orientation of the image.
- (UIImage *)fixOrientation;

// Rotate the image clockwise around the center by the angle, in radians.
- (UIImage *)rotateByAngle:(CGFloat)angleInRadians;

/// Crops a portion of an existing image object and returns it as a new image
/// @param frame The region inside the image (In image pixel space) to crop
/// @param angle If any, the angle the image is rotated at as well
/// @param circular Whether the resulting image is returned as a square or a circle
- (nonnull UIImage *)croppedImageWithFrame:(CGRect)frame angle:(NSInteger)angle circularClip:(BOOL)circular;

@end

NS_ASSUME_NONNULL_END
