//
//  MineTableViewCell.m
//  JieLeHua
//
//  Created by admin on 17/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "MineTableViewCell.h"

@interface MineTableViewCell ()

@property (nonatomic, strong) UIImageView *rightImg;

@end

@implementation MineTableViewCell

- (UIImageView *)rightImg {
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_next"]];
    }
    return _rightImg;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.font = [UIFont systemFontOfSize:15];
        _lab.textColor = VVColor(0, 0, 0);
    }
    return _lab;
}

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] init];
    }
    return _leftImg;
}

- (UIView *)bottomSeparateLine {
    if (!_bottomSeparateLine) {
        _bottomSeparateLine = [[UIView alloc] init];
        _bottomSeparateLine.backgroundColor = VVColor(205, 205, 205);
    }
    return _bottomSeparateLine;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"mineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.leftImg.frame = CGRectMake(12, 13, 23, 22);
        [self.contentView addSubview:self.leftImg];
        
        self.bottomSeparateLine.frame = CGRectMake(54, 47.5f, vScreenWidth-54, 0.5f);
        [self.contentView addSubview:self.bottomSeparateLine];
        
        self.lab.frame = CGRectMake(54, 0, 150, 48);
        [self.contentView addSubview:self.lab];
        
        self.rightImg.frame = CGRectMake(vScreenWidth-20, 17.5f, 8, 13);
        [self.contentView addSubview:self.rightImg];
    }
    
    return self;
}


@end
