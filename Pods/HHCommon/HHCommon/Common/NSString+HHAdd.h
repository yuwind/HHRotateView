//
//  NSString+HHAdd.h
//  HHCommon
//
//  Created by yufeng on 2022/4/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HHAdd)

/**
 *  16进制转UIColor
 */
@property (nonatomic, strong, readonly) UIColor *toColor;

/**
 *  字符串转UIImage
 */
@property (nonatomic, strong, nullable, readonly) UIImage *toImage;

/**
 *  字符串转UIFont
 */
@property (nonatomic, strong, nullable, readonly) UIFont *toFont;

/**
 *  字符串转json
 */
@property (nonatomic, strong, nullable, readonly) id toJsonObject;

/**
 *  是否为空
 */
@property (nonatomic, assign, readonly) BOOL isBlank;

/**
 *  删除左右空格
 */
@property (nonatomic, copy, nullable, readonly) NSString *delBlank;

/**
 *  删除所有空格
 */
@property (nonatomic, copy, nullable, readonly) NSString *delAllBlank;

/**
 *  首个字符大写
 */
@property (nonatomic, copy, nullable, readonly) NSString *capitalizedFirstChar;

/**
 *  首个字符大写其他小写
 */
@property (nonatomic, copy, nullable, readonly) NSString *capitalizedFirstCharLowcaseOthers;

/**
 *  字符串转base64编码
 */
@property (nonatomic, copy, nullable, readonly) NSString *base64EncodedString;

/**
 *  base64解码字符串
 */
@property (nonatomic, copy, nullable, readonly) NSString *base64DecodedString;

/**
 *  字符串转MD5
 */
@property (nonatomic, copy, readonly) NSString *toMD5;

/**
 *  字符串转拼音
 */
@property (nonatomic, copy, nullable, readonly) NSString *toSpell;

/**
 *  是否包含字符串
 */
@property (nonatomic, copy, readonly) BOOL (^contain)(NSString *string);

/**
 *  分割字符串
 */
@property (nonatomic, copy, nullable, readonly) NSArray *(^split)(NSString *string);

/**
 *  替换字符串
 */
@property (nonatomic, copy, readonly) NSString *(^replace)(NSString *origin, NSString *replace);

/**
 *  是否匹配字符串
 */
@property (nonatomic, copy, readonly) BOOL (^isMatch)(NSString *regular);

/**
 *  匹配字符串
 */
@property (nonatomic, copy, readonly) NSArray<NSTextCheckingResult *> *(^match)(NSString *regular,NSRegularExpressionOptions options);

@end

NS_ASSUME_NONNULL_END
