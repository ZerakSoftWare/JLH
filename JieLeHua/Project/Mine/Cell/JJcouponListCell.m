//
//  JJcouponListCell.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJcouponListCell.h"

@implementation JJcouponListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.limitedDateLabel.backgroundColor = VVRandomColor;
//    self.noteLabel.backgroundColor = VVRandomColor;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = [UIColor blackColor];
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    self.numberLabel.textColor = [UIColor redColor];
    self.limitedDateLabel.textAlignment = NSTextAlignmentLeft;
    self.limitedDateLabel.textColor =VVColor666666;
    self.noteLabel.textAlignment = NSTextAlignmentLeft;
    self.noteLabel.textColor = VVColor666666;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
