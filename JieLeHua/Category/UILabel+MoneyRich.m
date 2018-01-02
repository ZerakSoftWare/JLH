//
//  UILabel+MoneyRich.m
//  JieLeHua
//
//  Created by admin on 17/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "UILabel+MoneyRich.h"

@implementation UILabel (MoneyRich)

- (void)setMoneyRichText:(NSString *)string
{
    NSString *latePriceStr = [NSString stringWithFormat:@"¥%@",string];
        
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: latePriceStr];
    
    [attributedStr01 addAttribute: NSFontAttributeName
                            value: [UIFont systemFontOfSize:12]
                            range: NSMakeRange(0, 1)];
    
    [attributedStr01 addAttribute: NSForegroundColorAttributeName
                            value: VVColor999999
                            range: NSMakeRange(0, 1)];
    
    [attributedStr01 addAttributes:@{NSKernAttributeName : @(3.0f)} range:NSMakeRange(0, 1)];
    
    self.attributedText = attributedStr01;
}

- (void)setHomeMoneyRichText:(NSString *)string
{
    NSString *latePriceStr = [NSString stringWithFormat:@"¥%@",string];
    
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: latePriceStr];
    
    [attributedStr01 addAttribute: NSFontAttributeName
                            value: [UIFont systemFontOfSize:21]
                            range: NSMakeRange(0, 1)];
    
    [attributedStr01 addAttribute: NSForegroundColorAttributeName
                            value: [UIColor colorWithHexString:@"333333"]
                            range: NSMakeRange(0, 1)];
    
    [attributedStr01 addAttributes:@{NSKernAttributeName : @(3.0f)} range:NSMakeRange(0, 1)];
    
    self.attributedText = attributedStr01;
}
@end
