//
//  JJBankInfoTableViewCell.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBankInfoTableViewCell.h"

@interface JJBankInfoTableViewCell ()<UITextFieldDelegate>

@end

@implementation JJBankInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.endEditBlock(textField.text);
}

@end
