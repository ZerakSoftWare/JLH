//
//  VVExNSString.m
//  VCREDIT
//
//  Created by TZ_JSKFZX_CAOQ on 14-5-15.
//  Copyright (c) 2014年  vcredit. All rights reserved.
//

#import "VVExNSString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(VVExNSString)



- (CGSize)sizeWithFont:(UIFont *)font {
    CGSize  actualsize ;
    NSDictionary * dic = @{NSFontAttributeName:font};
    actualsize = [self sizeWithAttributes:dic];
    return actualsize;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize  actualsize ;
    NSDictionary * dic = @{NSFontAttributeName:font};
    actualsize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;

    return actualsize;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize  actualsize ;
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary * dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    actualsize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    return actualsize;
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];      
}

/**
 *  检查手机号的合法性
 */
- (BOOL)isMobileNumber
{
    NSString *newNumber = kRegisterPhoneNumberPredicate;
    NSPredicate *regexNew = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",newNumber];
    if ([regexNew evaluateWithObject:self] == YES) {
        return YES;
    }
    return NO;
}

@end
