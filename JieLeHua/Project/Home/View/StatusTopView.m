//
//  StatusTopView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "StatusTopView.h"

@interface StatusTopView()
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation StatusTopView
+ (instancetype)initWithType:(HomeStatus)type
{
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(HomeStatus)type
{
    if (self == [super init]) {
        [self setupUIWithType:(HomeStatus)type];
    }
    return self;
}

- (void)updateIWithType:(HomeStatus)type
{
    switch (type) {
        case HomeStatus_AdvanceIn30Days:
        {
            //可提现 状态5
            _rightLabel.text = @"可用额度";
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"ff850d"]];
            _leftImage.image = [UIImage imageNamed:@"icon_can_use_line"];
        }
            break;
        case HomeStatus_AdvanceApprovedWaitReviewing:
        case HomeStatus_Advancing:
        case HomeStatus_ReviewRefused:
        case HomeStatus_SignatureRefused:
        case HomeStatus_FillBankCardInfo:
        case HomeStatus_FillContractInfo:
        case HomeStatus_SignaturePassed:
        case HomeStatus_ReviewPassed:
        case HomeStatus_Loaded:
        case HomeStatus_Termination:
        case HomeStatus_RepayDone:
        case HomeStatus_LockOrder:
        case HomeStatus_LoanAgain:
        case HomeStatus_CreditReportingSignPassed:
        case HomeStatus_CreditReportingSignRefused:
        {
            //提现电审中 状态7 8 9 10 21 22 25 26 31 32 33 34 35
            _rightLabel.text = @"可用额度";
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"ff850d"]];
            _leftImage.image = [UIImage imageNamed:@"icon_can_use_line"];
        }
            break;
        case HomeStatus_NoAmount:
        {
            //暂无额度 状态1
            _rightLabel.text = @"暂无额度";
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"773cff"]];
            _leftImage.image = [UIImage imageNamed:@"icon_line_lapse"];
        }
            break;
        case HomeStatus_AmountInvalid:
        {
            //暂无额度 状态1
            _rightLabel.text = @"额度失效";
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"773cff"]];
            _leftImage.image = [UIImage imageNamed:@"icon_line_lapse"];
        }
            break;
        case HomeStatus_Repayment_Overdate_Not:
        {
            //逾期账单 37
            _rightLabel.text = @"逾期账单";
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"ff6584"]];
            _leftImage.image = [UIImage imageNamed:@"iocn_bill_whack"];
        }
            break;
        case HomeStatus_Repayment_Overdate_Doing:
        {
            //逾期还款中   扣款中38
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"03d9b7"]];
            _rightLabel.text = @"扣款中";
            _leftImage.image = [UIImage imageNamed:@"icon_deducting"];
        }
            break;
        case HomeStatus_LoadAndNotRepay:
        {
            //账单生成中 29状态
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"0d88ff"]];
            _rightLabel.text = @"账单生成中";
            _leftImage.image = [UIImage imageNamed:@"iocn_bill_production"];
        }
            break;
        case HomeStatus_Charge://43
        case HomeStatus_Freeze:
        {
            //扣款中 45状态
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"03d9b7"]];
            _rightLabel.text = @"扣款中";
            _leftImage.image = [UIImage imageNamed:@"icon_deducting"];
        }
            break;
            
        case HomeStatus_Repayment_Normal_Doing:
        {
            //正常账单  36
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"0d88ff"]];
            _rightLabel.text = @"正常账单";
            _leftImage.image = [UIImage imageNamed:@"icon_bill_nor"];
        }
            break;
        case HomeStatus_Repayment_Cloan_Doing:
        {
            //提前清贷  39
            [_rightLabel setTextColor:[UIColor colorWithHexString:@"95aeec"]];
            _rightLabel.text = @"提前清贷";
            _leftImage.image = [UIImage imageNamed:@"icon_advance_repayments"];
        }
            break;
            
        default:
            break;
    }
}

- (void)setupUIWithType:(HomeStatus)type
{
    _leftImage = [[UIImageView alloc] init];
    [self addSubview:_leftImage];
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(-45);
        make.top.mas_equalTo(self.top).offset(0);
        make.height.equalTo(@17);
        make.width.equalTo(@17);
    }];
    
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _rightLabel.textAlignment = NSTextAlignmentLeft;
    UIFont *semiboldFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:20];//这个是9.0以后自带的平方字体
    if(semiboldFont == nil){
//        //这个是我手动导入的第三方平方字体
        semiboldFont = [UIFont fontWithName:@"PingFangSC-Medium"size:20];
    }
    _rightLabel.font = semiboldFont;
    [self addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftImage.mas_left).offset(17+5);
        make.top.mas_equalTo(self.top).offset(0);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
    }];
    [self updateIWithType:type];
}

@end
