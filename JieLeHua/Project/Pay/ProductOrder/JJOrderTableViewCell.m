//
//  JJOrderTableViewCell.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/9/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJOrderTableViewCell.h"

@interface JJOrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@end

@implementation JJOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topBgView.backgroundColor = [UIColor colorWithWholeRed:241 green:244 blue:246];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
