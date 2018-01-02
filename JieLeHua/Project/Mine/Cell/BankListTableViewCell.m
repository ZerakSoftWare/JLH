//
//  BankListTableViewCell.m
//  JieLeHua
//
//  Created by admin on 17/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "BankListTableViewCell.h"
#import "VVUtils.h"
#import "BankListDTO.h"

@interface BankListTableViewCell ()

@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *lab;

@property (nonatomic, strong) UIImageView *bankIcon;

@property (nonatomic, strong) UILabel *bankLab;

@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, retain) CAGradientLayer *gradientLayer;

@end

@implementation BankListTableViewCell

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.locations = @[@0.0, @1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    return _gradientLayer;
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.textColor = [UIColor whiteColor];
        _numLab.font = [UIFont systemFontOfSize:20];
        _numLab.text = @"6164 **** *** 3456";
    }
    return _numLab;
}

- (UILabel *)bankLab {
    if (!_bankLab) {
        _bankLab = [[UILabel alloc] init];
        _bankLab.textColor = [UIColor whiteColor];
        _bankLab.font = [UIFont systemFontOfSize:15];
        _bankLab.text = @"建设银行";
    }
    return _bankLab;
}

- (UIImageView *)bankIcon {
    if (!_bankIcon) {
        _bankIcon = [[UIImageView alloc] init];
    }
    return _bankIcon;
}

- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 4;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.font = [UIFont systemFontOfSize:14];
        _lab.textColor = VVColor(153, 153, 153);
        _lab.text = @"额度提现银行卡";
    }
    return _lab;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bankListTableViewCell";
    BankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BankListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = VVColor(241,244,246);
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.lab.frame = CGRectMake(12, 20, 100, 20);
        [self.contentView addSubview:self.lab];
        
        self.whiteView.frame = CGRectMake(0, 46, kScreenWidth, 106);
        [self.contentView addSubview:self.whiteView];
        
        self.backView.frame = CGRectMake(12, 10, kScreenWidth-24, 86);
        [self.whiteView addSubview:self.backView];
        
        self.gradientLayer.frame = self.backView.bounds;
        [self.backView.layer addSublayer:self.gradientLayer];
        
        self.bankIcon.frame = CGRectMake(8, 8, 33, 33);
        [self.backView addSubview:self.bankIcon];
        
        self.bankLab.frame = CGRectMake(52, 8, CGRectGetWidth(self.backView.frame)-60, 33);
        [self.backView addSubview:self.bankLab];
        
        self.numLab.frame = CGRectMake(52, CGRectGetMaxY(self.bankIcon.frame)+5.5f, 250, 28);
        [self.backView addSubview:self.numLab];
    }
    
    return self;
}

- (void)setItem:(BankListDTO *)item
{
    NSString *bankGreenStr = @"民生银行、农业银行、邮储银行";
    NSString *bankBlueStr = @"重庆银行、光大银行、杭州银行、汉口银行、江苏银行、建设银行、交通银行、洛阳银行、南昌银行、浦发银行、上海银行、厦门银行、兴业银行、上海浦东发展银行、浦东发展银行";
    
    self.bankLab.text = item.bankName;
    [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:nil];
    
    self.lab.text = (item.isDrawMoneyBankcard == 1)? @"额度提现银行卡" : @"还款银行卡";
    
    self.numLab.text  = [VVUtils formatCardNumber:item.bankPersonAccount];
    
    if ([bankGreenStr containsString:item.bankName])
    {
        self.gradientLayer.colors = @[(__bridge id)VVColor(98, 190, 140).CGColor,
                                      (__bridge id)VVColor(66, 162, 113).CGColor];
    }
    else if ([bankBlueStr containsString:item.bankName])
    {
        self.gradientLayer.colors = @[(__bridge id)VVColor(111, 141, 212).CGColor,
                                      (__bridge id)VVColor(68, 103, 185).CGColor];
    }
    else
    {
        self.gradientLayer.colors = @[(__bridge id)VVColor(218, 108, 132).CGColor,
                                      (__bridge id)VVColor(192, 82, 78).CGColor];
    }
}

@end
