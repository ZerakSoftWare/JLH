//
//  VVExNSString.h
//  VCREDIT
//
//  Created by TZ_JSKFZX_CAOQ on 14-5-15.
//  Copyright (c) 2014年  vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(VVExNSString)

- (CGSize)sizeWithFont:(UIFont *)font ;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode ;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (NSString*)md5;

- (BOOL)isMobileNumber;

@end
