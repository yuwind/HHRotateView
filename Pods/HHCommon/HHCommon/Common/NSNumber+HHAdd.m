//
//  NSNumber+HHAdd.m
//  HHCommon
//
//  Created by yufeng on 2022/4/27.
//

#import "NSNumber+HHAdd.h"

@implementation NSNumber (HHAdd)

- (UIFont *)toFont {
    CGFloat fontSize = [self floatValue];
    if (fontSize > 0) {
        return [UIFont systemFontOfSize:fontSize];
    }
    return nil;
}

@end
