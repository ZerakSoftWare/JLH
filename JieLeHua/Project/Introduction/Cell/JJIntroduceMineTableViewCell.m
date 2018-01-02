//
//  JJIntroduceMineTableViewCell.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/6/7.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJIntroduceMineTableViewCell.h"

@implementation JJIntroduceMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubView];

}

-(void)setupSubView{
    self.titleLab.font = [UIFont systemFontOfSize:18.f];
    self.detialLab.font = [UIFont systemFontOfSize:14.f];
    self.separateLine.backgroundColor = VVSeparateColor;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
