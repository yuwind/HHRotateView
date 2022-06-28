//
//  HHGradientLayerButton.m
//  HHCommon
//
//  Created by yufeng on 2022/5/30.
//

#import "HHGradientLayerButton.h"

@implementation HHGradientLayerButton

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors = [self translateUIColorToCGColorWithArray:colors];
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
}

- (NSArray *)translateUIColorToCGColorWithArray:(NSArray *)colorArray {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (UIColor *color in colorArray) {
        [mutableArray addObject:(__bridge id)color.CGColor];
    }
    return mutableArray.copy;
}

@end
