//
//  MemberTableViewCell.m
//  JieLeHua
//
//  Created by admin on 2017/12/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "MemberTableViewCell.h"
#import "JJMemberFeeBillModel.h"

@interface MemberTableViewCell ()

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UILabel *tipLab;

@property (nonatomic, strong) UILabel *startTimeLab;

@property (nonatomic, strong) UILabel *endTimeLab;

@end

@implementation MemberTableViewCell

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kColor_SeparaterLine_Color;
    }
    return _line;
}

- (UIButton *)applyRefundBtn {
    if (!_applyRefundBtn) {
        _applyRefundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyRefundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        [_applyRefundBtn setTitleColor:RGB(30, 139, 251) forState:UIControlStateNormal];
        _applyRefundBtn.titleLabel.font  = [UIFont systemFontOfSize:14.0];
        _applyRefundBtn.layer.cornerRadius = 20;
        _applyRefundBtn.layer.borderWidth = 2;
        _applyRefundBtn.layer.borderColor = RGB(30, 139, 251).CGColor;
        _applyRefundBtn.clipsToBounds = YES;
        [_applyRefundBtn addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyRefundBtn;
}

- (UILabel *)endTimeLab {
    if (!_endTimeLab) {
        _endTimeLab = [[UILabel alloc] init];
        _endTimeLab.font = kFont_TipTitle;
        _endTimeLab.textColor = kColor_TipColor;
        _endTimeLab.text = @"缴费日期：2017-12-30";
    }
    return _endTimeLab;
}

- (UILabel *)startTimeLab {
    if (!_startTimeLab) {
        _startTimeLab = [[UILabel alloc] init];
        _startTimeLab.font = kFont_TipTitle;
        _startTimeLab.textColor = kColor_TipColor;
        _startTimeLab.text = @"有效日期：2017-12-30";
    }
    return _startTimeLab;
}

- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.text = @"优享会员一年期";
        _tipLab.textColor = kColor_TitleColor;
        _tipLab.font = kFont_NormalTitle;
    }
    return _tipLab;
}

- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        _statusLab.text = @"已付款";
        _statusLab.textColor = [UIColor whiteColor];
        _statusLab.layer.cornerRadius = 12;
        _statusLab.clipsToBounds = YES;
        _statusLab.font = kFont_TipTitle;
        _statusLab.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLab;
}

- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc] initWithImage:kGetImage(@"img_user_VIP")];
    }
    return _img;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"memberTableViewCell";
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MemberTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.statusLab];
        [self.contentView addSubview:self.tipLab];
        [self.contentView addSubview:self.startTimeLab];
        [self.contentView addSubview:self.endTimeLab];
        [self.contentView addSubview:self.applyRefundBtn];
        [self.contentView addSubview:self.line];
        
        if (ISIPHONE5 || ISIPHONE4)
        {
            self.img.frame = CGRectMake(10, 24, 75, 40);
            self.applyRefundBtn.frame = CGRectMake(kScreenWidth-100, 40, 78, 40);
        }
        else
        {
            self.img.frame = CGRectMake(10, 19, 94, 50);
            self.applyRefundBtn.frame = CGRectMake(kScreenWidth-118, 40, 78, 40);
        }
        
        self.statusLab.frame = CGRectMake(CGRectGetMaxX(self.img.frame)+8, 8, 60, 24);
        
        self.tipLab.frame = CGRectMake(CGRectGetMaxX(self.statusLab.frame)+6, 0, 150, 40);
        
        self.startTimeLab.frame = CGRectMake(CGRectGetMaxX(self.img.frame)+8, 38, 200, 20);
        self.endTimeLab.frame = CGRectMake(CGRectGetMaxX(self.img.frame)+8, CGRectGetMaxY(self.startTimeLab.frame), 200, 24);
        
        self.line.frame = CGRectMake(10, 87.5f, kScreenWidth, 0.5f);
    }
    
    return self;
}

- (void)setItem:(JJMemberFeeBillModel *)item
{
    NSInteger memberfeeStatus = [item.memberfeeStatus integerValue];
    
    switch (memberfeeStatus) {
        case 1:
            self.statusLab.backgroundColor = RGB(30, 139, 251);
            self.statusLab.text = @"已付款";
            self.endTimeLab.text = [NSString stringWithFormat:@"有效日期：%@", [item.feeExpireTime substringToIndex:10]];
            self.startTimeLab.text = [NSString stringWithFormat:@"缴费日期：%@", [item.feeValidTime substringToIndex:10]];
            break;
        case 2:
            self.statusLab.backgroundColor = [UIColor redColor];
            self.statusLab.text = @"付款中";
            self.endTimeLab.text = @"暂未缴费";
            self.startTimeLab.text = @"暂未缴费";
            break;
        case 3:
            self.statusLab.backgroundColor = kColor_Disable_Color;
            self.statusLab.text = @"待退款";
            self.endTimeLab.text = [NSString stringWithFormat:@"有效日期：%@", [item.feeExpireTime substringToIndex:10]];
            self.startTimeLab.text = [NSString stringWithFormat:@"缴费日期：%@", [item.feeValidTime substringToIndex:10]];
            break;
        case 4:
            self.statusLab.backgroundColor = kColor_Disable_Color;
            self.statusLab.text = @"已退款";
            self.endTimeLab.text = [NSString stringWithFormat:@"有效日期：%@", [item.feeExpireTime substringToIndex:10]];
            self.startTimeLab.text = [NSString stringWithFormat:@"缴费日期：%@", [item.feeValidTime substringToIndex:10]];
            break;
        case 5:
            self.statusLab.backgroundColor = kColor_Disable_Color;
            self.statusLab.text = @"支付失败";
            self.endTimeLab.text = [NSString stringWithFormat:@"有效日期：%@", [item.feeExpireTime substringToIndex:10]];
            self.startTimeLab.text = [NSString stringWithFormat:@"缴费日期：%@", [item.feeValidTime substringToIndex:10]];
            break;
        case 6:
            self.statusLab.backgroundColor = kColor_Disable_Color;
            self.statusLab.text = @"退款失败";
            self.endTimeLab.text = [NSString stringWithFormat:@"有效日期：%@", [item.feeExpireTime substringToIndex:10]];
            self.startTimeLab.text = [NSString stringWithFormat:@"缴费日期：%@", [item.feeValidTime substringToIndex:10]];
            break;
            
        default:
            break;
    }


}

- (void)refundAction
{
    if (self.clickOperation) {
        self.clickOperation();
    }
}

@end
