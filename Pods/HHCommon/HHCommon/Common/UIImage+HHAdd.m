//
//  UIImage+HHAdd.m
//  HHCommon
//
//  Created by yufeng on 2022/5/1.
//

#import "UIImage+HHAdd.h"

@implementation UIImage (HHAdd)

+ (UIImage *)hh_imageWithColor:(UIColor *)color {
    return [self hh_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)hh_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
        return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
            [color setFill];
            [rendererContext fillRect:rendererContext.format.bounds];
        }];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();;
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)hh_imageTintedWithColor:(UIColor *)color {
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:self.size];
        return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
            CGContextTranslateCTM(rendererContext.CGContext, 0, self.size.height);
            CGContextScaleCTM(rendererContext.CGContext, 1.0, -1.0);
            CGContextDrawImage(rendererContext.CGContext, renderer.format.bounds, self.CGImage);
            [color setFill];
            [rendererContext fillRect:rendererContext.format.bounds blendMode:kCGBlendModeSourceIn];
        }];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [color setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

+ (UIImage *)hh_gradientImageWithWidth:(NSUInteger)width height:(NSUInteger)height from:(UIColor*)from to:(UIColor*)to type:(HHGradientType)type {
    CGPoint start;
    CGPoint end;
    switch (type) {
        case HHGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, height);
            break;
        case HHGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(width, 0.0);
            break;
        case HHGradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(width, height);
            break;
        case HHGradientTypeUprightToLowleft:
            start = CGPointMake(width, 0.0);
            end = CGPointMake(0.0, height);
            break;
        default:
            break;
    }
    
    CGFloat r0, g0, b0, a0;
    [from getRed:&r0 green:&g0 blue:&b0 alpha:&a0];
    CGFloat r1, g1, b1, a1;
    [to getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(width, height)];
        return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGFloat components[8] = {r0, g0, b0, a0, /* Start color */ r1, g1, b1, a1 /* End color */};
            CGFloat locations[2] = {0.0, 1.0};
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
            CGContextDrawLinearGradient(rendererContext.CGContext, gradient, start, end, 0);
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
        }];
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t gradientNumberOfLocations = 2;
    CGFloat gradientComponents[8] = {r0, g0, b0, a0, /* Start color */r1, g1, b1, a1};  // End color
    CGFloat gradientLocations[2] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    return image;
}

+ (UIImage *)hh_gradientImageWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors type:(HHGradientType)type {
    CGPoint start;
    CGPoint end;
    switch (type) {
        case HHGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case HHGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case HHGradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case HHGradientTypeUprightToLowleft:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    
    NSMutableArray *cgcolors = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cgcolors addObject:(id)obj.CGColor];
    }];
    
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)cgcolors, NULL);
        CGContextDrawLinearGradient(rendererContext.CGContext, gradient, start, end, 0);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }];
}

+ (UIImage *)hh_gradientImageWithWidth:(NSUInteger)width height:(NSUInteger)height from:(UIColor *)from to:(UIColor *)to {
    return [UIImage hh_gradientImageWithWidth:width height:height from:from to:to type:HHGradientTypeTopToBottom];
}

+ (UIImage *)hh_gradientImageForLayer:(CAGradientLayer *)gradientLayer start:(UIColor *)start end:(UIColor *)end angle:(CGFloat)angle scale:(CGFloat)scale {
    gradientLayer.colors = @[(id)start.CGColor, (id)end.CGColor];
    if (gradientLayer.frame.size.height <= 0) { return [UIImage new]; }
    
    CGFloat radians = M_PI * angle / 180.0;
    CGFloat x = 0.5;
    CGFloat y = 32 / gradientLayer.frame.size.height;
    
    CGFloat dx = scale * x * cos(radians);
    CGFloat dy = scale * y * sin(radians);
    
    gradientLayer.startPoint = CGPointMake(x + dx, y - dy);
    gradientLayer.endPoint = CGPointMake(x - dx, y + dy);
    
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:gradientLayer.bounds.size];
        return [[renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
            [gradientLayer renderInContext:rendererContext.CGContext];
        }] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    }
    
    UIGraphicsBeginImageContext(gradientLayer.bounds.size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = [UIGraphicsGetImageFromCurrentImageContext() resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIGraphicsEndImageContext();
    return gradientImage;
}

+ (UIImage *)hh_gradientImageForSize:(CGSize)size start:(UIColor *)start end:(UIColor *)end angle:(CGFloat)angle scale:(CGFloat)scale {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = CGRectMake(0, -20, size.width, size.height);
    return [UIImage hh_gradientImageForLayer:gradientLayer start:start end:end angle:angle scale:scale];
}

- (UIImage *)hh_imageCroppedAtCenterWithSize:(CGSize)size {
    CGFloat x = 0.5 * (self.size.width - size.width);
    CGFloat y = 0.5 * (self.size.height - size.height);
    CGSize canvasSize = CGSizeMake(MIN(size.width, self.size.width), MIN(size.height, self.size.height));
    
    return [self hh_imageCroppedForFrame:CGRectMake(x, y, canvasSize.width, canvasSize.height)];
}

- (UIImage *)hh_imageCroppedForFrame:(CGRect)frame {
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
        format.scale = self.scale;
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:frame.size format:format];
        return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
            CGContextSetInterpolationQuality(rendererContext.CGContext, kCGInterpolationHigh);
            CGContextTranslateCTM(rendererContext.CGContext, -frame.origin.x, -frame.origin.y);
            [self drawAtPoint:CGPointZero];
        }];
    }
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, self.scale);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    [self drawAtPoint:CGPointZero];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

- (UIImage *)hh_roundImageWithSize:(CGSize)size {
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
        return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
            CGContextSetInterpolationQuality(rendererContext.CGContext, kCGInterpolationHigh);
            CGRect bounds = CGRectMake(0, 0, size.width, size.height);
            [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:MIN(size.width, size.height)] addClip];
            [self drawInRect:bounds];
        }];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:MIN(size.width, size.height)] addClip];
    [self drawInRect:bounds];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return roundedImage;
}

- (UIImage *)hh_ImageWithCornerRadius:(CGFloat)cornerRadius {
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:self.size];
        return [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
            CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
            [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius] addClip];
            [self drawInRect:bounds];
        }];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius] addClip];
    [self drawInRect:bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//参考文档:https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIGaussianBlur
- (UIImage *)imageWithBlurRadius:(CGFloat)blurRadius {
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *ciImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(blurRadius) forKey:@"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:ciImage.extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (UIImage *)fixOrientation {
    // No-op if the orientation is already correct.
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context.
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

- (UIImage *)rotateByAngle:(CGFloat)angleInRadians {
    // Calculate the size of the rotated image.
    CGRect rotatedImageFrame = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGSize rotatedImageSize = CGRectApplyAffineTransform(rotatedImageFrame, CGAffineTransformMakeRotation(angleInRadians)).size;
    // Create a bitmap-based graphics context.
    UIGraphicsBeginImageContextWithOptions(rotatedImageSize, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Move the origin of the user coordinate system in the context to the middle.
    CGContextTranslateCTM(context, rotatedImageSize.width / 2, rotatedImageSize.height / 2);
    // Rotates the user coordinate system in the context.
    CGContextRotateCTM(context, angleInRadians);
    // Flip the handedness of the user coordinate system in the context.
    CGContextScaleCTM(context, 1.0, -1.0);
    // Draw the image into the context.
    CGContextDrawImage(context, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), self.CGImage);
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rotatedImage;
}

- (BOOL)hasAlpha {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    return (alphaInfo == kCGImageAlphaFirst || alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaPremultipliedLast);
}

- (UIImage *)croppedImageWithFrame:(CGRect)frame angle:(NSInteger)angle circularClip:(BOOL)circular {
    UIGraphicsBeginImageContextWithOptions(frame.size, !self.hasAlpha && !circular, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // If we're capturing a circular image, set the clip mask first
    if (circular) {
        CGContextAddEllipseInRect(context, (CGRect){CGPointZero, frame.size});
        CGContextClip(context);
    }

    // Offset the origin (Which is the top left corner) to start where our cropping origin is
    CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);

    // If an angle was supplied, rotate the entire canvas + coordinate space to match
    if (angle != 0) {
        // Rotation in radians
        CGFloat rotation = angle * (M_PI/180.0f);

        // Work out the new bounding size of the canvas after rotation
        CGRect imageBounds = (CGRect){CGPointZero, self.size};
        CGRect rotatedBounds = CGRectApplyAffineTransform(imageBounds,
                                                          CGAffineTransformMakeRotation(rotation));
        // As we're rotating from the top left corner, and not the center of the canvas, the frame
        // will have rotated out of our visible canvas. Compensate for this.
        CGContextTranslateCTM(context, -rotatedBounds.origin.x, -rotatedBounds.origin.y);

        // Perform the rotation transformation
        CGContextRotateCTM(context, rotation);
    }

    // Draw the image with all of the transformation parameters applied.
    // We do not need to worry about specifying the size here since we're already
    // constrained by the context image size
    [self drawAtPoint:CGPointZero];
    
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Re-apply the retina scale we originally had
    return [UIImage imageWithCGImage:croppedImage.CGImage scale:self.scale orientation:UIImageOrientationUp];
}

@end
