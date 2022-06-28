//
//  NSString+HHAdd.m
//  HHCommon
//
//  Created by yufeng on 2022/4/27.
//

#import "NSString+HHAdd.h"
#import "HHCommonMethod.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (HHAdd)

- (UIColor *)toColor {
    return [self colorWithHex:self];
}

- (UIColor *)colorWithHex:(NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    } else if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString length] != 6) {
        return [UIColor blackColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1];
}

- (UIImage *)toImage {
    return [UIImage imageNamed:self];
}

- (UIFont *)toFont {
    CGFloat fontSize = [self floatValue];
    if (fontSize > 0) {
        return [UIFont systemFontOfSize:fontSize];
    }
    return nil;
}

- (id)toJsonObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        return nil;
    }
    return jsonObject;
}

- (BOOL)isBlank {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0;
}

- (NSString *)delBlank {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)delAllBlank {
    return self.replace(@" ", @"");
}

- (NSString *)capitalizedFirstChar {
    if (!isValidString(self)) {
        return @"";
    }
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length > 1) {
        [stringM appendString:[self substringFromIndex:1]];
    }
    return stringM.copy;
}

- (NSString *)capitalizedFirstCharLowcaseOthers {
    if (!isValidString(self)) {
        return @"";
    }
    return [self lowercaseString].capitalizedFirstChar;
}

- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)toMD5 {
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString.copy;
}

- (NSString *)toSpell {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    NSString *result = [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    return result;
}

- (BOOL (^)(NSString *))contain {
    return ^BOOL(NSString *string) {
        if (!isValidString(string)) {
            return false;
        }
        return [self containsString:string];
    };
}

- (NSArray *(^)(NSString *))split {
    return ^NSArray *(NSString *string) {
        if (!isValidString(string)) {
            return nil;
        }
        if (self.contain(string)) {
            return [self componentsSeparatedByString:string];
        }
        return nil;
    };
}

- (NSString *(^)(NSString *, NSString *))replace {
    return ^NSString *(NSString *origin, NSString *replace) {
        if (!isValidString(origin)) {
            return self;
        }
        if (self.contain(origin)) {
            if (!isValidString(replace)) {
                replace = @"";
            }
            return [self stringByReplacingOccurrencesOfString:origin withString:replace];
        }
        return self;
    };
}

- (BOOL (^)(NSString *))isMatch {
    return ^BOOL(NSString *regular) {
        if (!isValidString(regular)) {
            return false;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
        return [predicate evaluateWithObject:self];
    };
}

- (NSArray<NSTextCheckingResult *> *(^)(NSString *,NSRegularExpressionOptions))match {
    return ^NSArray<NSTextCheckingResult *> *(NSString *regular, NSRegularExpressionOptions options){
        NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regular options:options error:nil];
        return [regExp matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    };
}

@end
