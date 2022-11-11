//
//  NSString+LPExtension.h
//  APPSearch
//
//  Created by iOS开发 on 16/4/8.
//  Copyright © 2016年 高欣研究院. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LPExtension)
- (CGSize)stringSizeWithFont:(UIFont *)font;
- (CGSize)stringSizeWithFount:(CGFloat)fount;
- (CGSize)boundingRectWithSize:(CGSize)size withFont:(CGFloat)fount;

/** MD5加密*/
- (NSString *)md5String;
/** 邮箱验证*/
- (BOOL)validateEmail;
/** 手机号码验证*/
- (BOOL)validateMobile;
/** 密码验证*/
- (BOOL)validataPsd;
/** 小写32MD5*/
- (NSString*)md532BitLower;
/** 大写32MD5*/
- (NSString*)md532BitUpper;

///** 时间戳转化为时间字符串*/
//- (NSString *)timeStampChangeTimeStringWithFormartStyle:(NSString *)formartStr;


- (NSString *)urlEnCoding;

/// 去空格
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

// 移除后缀的字符串
- (NSString *)removeLastChars:(NSString *)chars;

//!@brief 字符串反转
- (NSString *)reverseString;

//含有多少位字符
- (int)convertToInt;

#pragma mark - AttributeSting

/// 格式化字符串颜色
/// @param rangeString 需要格式化的字符串
/// @param originColor 字符串默认的颜色
/// @param rangeColor 格式化的颜色
/// @param font 字体大小
- (NSAttributedString *)rangeString:(NSString *)rangeString originColor:(UIColor *)originColor rangeColor:(UIColor *)rangeColor fontSize:(CGFloat)font;


/// 格式化字符串字体
/// @param rangeString 要格式的字符串
/// @param font 字体
- (NSAttributedString *)rangeString:(NSString *)rangeString font:(UIFont *)font;

- (NSMutableAttributedString *)rangeString:(NSString *)rangeString rangeColor:(UIColor *)rangeColor font:(UIFont *)font;

@end
