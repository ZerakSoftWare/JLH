//
//  CALayer+JJBorderColor.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "CALayer+JJBorderColor.h"

@implementation CALayer (JJBorderColor)
- (void)setBorderUIColor:(UIColor *)borderUIColor
{
    self.borderColor = borderUIColor.CGColor;
}

- (UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
