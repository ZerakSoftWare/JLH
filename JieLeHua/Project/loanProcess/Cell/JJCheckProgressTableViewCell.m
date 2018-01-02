//
//  JJCheckProgressTableViewCell.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/4/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJCheckProgressTableViewCell.h"

@implementation JJCheckProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topBgView.backgroundColor = [UIColor colorWithWholeRed:241 green:244 blue:246];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
