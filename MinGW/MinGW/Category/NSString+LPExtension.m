//
//  NSString+LPExtension.m
//  APPSearch
//
//  Created by iOS开发 on 16/4/8.
//  Copyright © 2016年 高欣研究院. All rights reserved.
//

#import "NSString+LPExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <COmmoncrypto/CommonHMAC.h>

@implementation NSString (LPExtension)

- (CGSize)stringSizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)stringSizeWithFount:(CGFloat)fount
{
    return [self sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fount]}];
}
- (CGSize)boundingRectWithSize:(CGSize)size withFont:(CGFloat)fount
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fount]};
    
    CGSize retSize = [self boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}
#pragma mark - MD5加密
- (NSString *)md5String{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string,length,bytes);
    
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}
- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++) {
        [mutableString appendFormat:@"%02X", bytes[i]];
    }
    return [NSString stringWithString:mutableString];
}

#pragma mark - MD5  32位加密大小写
- (NSString*)md532BitLower
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
- (NSString*)md532BitUpper
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
#pragma mark - 邮箱验证
- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark - 手机号码验证
- (BOOL)validateMobile
{
    // 手机号以13， 15，18开头，八个 \d 数字字符
    //     @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
    NSString *phoneRegex = @"^[1][3578][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
#pragma mark - 密码验证
- (BOOL)validataPsd
{
    NSString *PsdRegex = @"(?!^\\d+$)(?!^[a-zA-Z]+$)(?!^[_#@]+$).{8,}";
    NSPredicate *PsdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PsdRegex];
    return [PsdTest evaluateWithObject:self];
}
//#pragma mark - 时间戳转化为时间字符串
//- (NSString *)timeStampChangeTimeStringWithFormartStyle:(NSString *)formartStr
//{
//    NSString *str = self;//时间戳
//    
//    NSTimeInterval time = [str doubleValue]/1000.0;
//    
//    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
//    
//    //实例化一个NSDateFormatter对象
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    //设定时间格式,这里可以设置成自己需要的格式
//    
//    [dateFormatter setDateFormat:formartStr];
//    
//    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
//    
//    return currentDateStr;
//}
//

- (NSString *)urlEnCoding {
    NSString *charactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    NSString *charactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[charactersGeneralDelimitersToEncode stringByAppendingString:charactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    NSUInteger batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < self.length) {

        NSUInteger length = MIN(self.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

/// 去通讯录中间隔符号
+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"·" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
    temp = [[temp componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""]; 
    return temp;
}

- (NSString *)reverseString{
    NSInteger length = self.length;
    unichar *buffer = calloc(length, sizeof(unichar));
    [self getCharacters:buffer range:NSMakeRange(0, length)];
    for (NSInteger i = 0; i<length/2; i++)
    {
        unichar temp = buffer[i];
        buffer[i] = buffer[length-1-i];
        buffer[length-1-i] = temp;
    }
    NSString *result = [NSString stringWithCharacters:buffer length:length];
    free(buffer);
    return result;
}

- (int)convertToInt  {
    return [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
}

- (NSAttributedString *)rangeString:(NSString *)rangeString originColor:(UIColor *)originColor rangeColor:(UIColor *)rangeColor fontSize:(CGFloat)font {
    if (!self) {
        return nil;
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    if (!rangeString) {
        return attString;
    }

    NSRange range = [self rangeOfString:rangeString];
    [attString setAttributes:@{NSForegroundColorAttributeName:originColor} range:NSMakeRange(0, self.length)];
    [attString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} range:NSMakeRange(0, self.length)];
    [attString setAttributes:@{NSForegroundColorAttributeName:rangeColor} range:range];
    return attString;
}

- (NSAttributedString *)rangeString:(NSString *)rangeString font:(UIFont *)font {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    if (!self) {
        return nil;
    }
    if (!rangeString) {
        return attString;
    }
    NSRange range = [self rangeOfString:rangeString];
    [attString setAttributes:@{NSFontAttributeName:font} range:range];
    return attString;
}

- (NSMutableAttributedString *)rangeString:(NSString *)rangeString rangeColor:(UIColor *)rangeColor font:(UIFont *)font {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self];
    if (!self) {
        return nil;
    }
    if (!rangeString) {
        return attString;
    }
    NSRange range = [self rangeOfString:rangeString];
    [attString setAttributes:@{NSFontAttributeName:font} range:range];
    [attString setAttributes:@{NSForegroundColorAttributeName:rangeColor} range:range];
    return attString;
}

- (NSString *)removeLastChars:(NSString *)chars{
    if ([self hasSuffix:chars] ) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(self.length - chars.length, chars.length) withString:@""];
    }
    return self;
}

@end
