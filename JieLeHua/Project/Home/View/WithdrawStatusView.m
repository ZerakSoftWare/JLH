//
//  WithdrawStatusView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "WithdrawStatusView.h"
#import "UILabel+MoneyRich.h"
#import "StatusTopView.h"

@interface WithdrawStatusView ()
@property (nonatomic) HomeStatus type;

@property(nonatomic,strong) UIImageView * homeStatusBg;
@property(nonatomic,strong) UIImageView * billBgImg;
@property(nonatomic,strong) UILabel * billLabTop;
@property(nonatomic,strong) UILabel * billLabBottom;

@property(nonatomic,strong) UILabel *availableLimitLab;
@property(nonatomic,strong) UILabel *availableLimitDetialLab;
@property(nonatomic,strong) UIView * horizontalSeparateLine;
@property(nonatomic,strong) UILabel *usedLimitLab;
@property(nonatomic,strong) UILabel *usedLimitDetialLab;
@property(nonatomic,strong) UILabel *lineOfCreditLimitLab;
@property(nonatomic,strong) UILabel *lineOfCreditLimitDetialLab;
@property(nonatomic,strong) UIView * verticalSeparateLine;
@property (nonatomic, strong) VVCommonButton *applyBtn;
//加入会员按钮
@property (nonatomic, strong) VVCommonButton *payVipBtn;
//立即提现
@property (nonatomic, strong) VVCommonButton *withdrawalBtn;

@property (nonatomic, strong) UILabel *approvingTipLabl;
@property (nonatomic, strong) StatusTopView *statusTopView;

@end

@implementation WithdrawStatusView

+ (instancetype)withdrawStatusWithType:(HomeStatus)type frame:(CGRect)frame;
{
   return [[self alloc] withdrawStatusWithType:type frame:frame];
}

- (instancetype)withdrawStatusWithType:(HomeStatus)type frame:(CGRect)frame;
{
    if (self == [super init]) {
        self.type = type;
        self.frame = frame;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI界面
- (void)setupUI
{
    UIImageView * homeStatusBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_card_bg"]];
    homeStatusBg.frame = self.frame;
    [self addSubview:homeStatusBg];
    _homeStatusBg = homeStatusBg;

    _statusTopView = [StatusTopView initWithType:self.type];
    [self addSubview:_statusTopView];
    [_statusTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeStatusBg.mas_top).offset(16);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@20);
    }];
    _statusTopView.hidden = YES;
    
    //正常账单
    UIImage *img = [UIImage imageNamed:@"amount_invalid"];
    UIImageView * billBgImg = [[UIImageView alloc]initWithImage:img];
    [_homeStatusBg addSubview:billBgImg];
    _billBgImg = billBgImg;
    
    [billBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(55);
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(-20);
        make.width.equalTo(@76.5);
        make.height.equalTo(@57);
    }];
    
    
    //显示各种额度
    UIView * horizontalSeparateLine = [[UIView alloc]init];
    horizontalSeparateLine.backgroundColor = [UIColor colorWithHexString:@"b2cbe3"];
    [_homeStatusBg addSubview:horizontalSeparateLine];
    _horizontalSeparateLine = horizontalSeparateLine;
    
    [horizontalSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(188);
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(6);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-6);
        make.height.equalTo(@0.5);
    }];
    
    UIView * verticalSeparateLine = [[UIView alloc]init];
    verticalSeparateLine.backgroundColor = VVColor999999;
    [_homeStatusBg addSubview:verticalSeparateLine];
    _verticalSeparateLine = verticalSeparateLine;
    
    [verticalSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.horizontalSeparateLine.mas_top).offset(18);
        make.height.mas_equalTo(@35);
        make.width.mas_equalTo(@0.5);
        make.centerX.mas_equalTo(self.homeStatusBg.centerX).offset(0);
    }];
    
    UILabel *availableLimitLab = [[UILabel alloc]init];
    availableLimitLab.font = [UIFont systemFontOfSize:15.f];
    availableLimitLab.textAlignment = NSTextAlignmentCenter;
    availableLimitLab.textColor = VVColor666666;
    availableLimitLab.numberOfLines = 1;
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"icon_home"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, 19, 16);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"可用额度"];
    [attri insertAttributedString:string atIndex:0];
    availableLimitLab.attributedText = attri;
//    [_homeStatusBg addSubview:availableLimitLab];
    _availableLimitLab = availableLimitLab;
    
//    [availableLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.horizontalSeparateLine.mas_top).offset(-66);
//        make.height.equalTo(@18);
//        make.centerX.mas_equalTo(self.horizontalSeparateLine.centerX).offset(0);
//    }];
    
    UILabel *availableLimitDetialLab = [[UILabel alloc]init];
    availableLimitDetialLab.font = [UIFont fontWithName:@"DINPro-Bold" size:48.f];;
    availableLimitDetialLab.textAlignment = NSTextAlignmentCenter;
    availableLimitDetialLab.textColor = [UIColor colorWithHexString:@"333333"];
    availableLimitDetialLab.numberOfLines = 1;
    availableLimitDetialLab.text = @"";
    [_homeStatusBg addSubview:availableLimitDetialLab];
    _availableLimitDetialLab= availableLimitDetialLab;
    
    [availableLimitDetialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.horizontalSeparateLine.mas_top).offset(-20);
        make.height.equalTo(@48);
        make.centerX.mas_equalTo(self.horizontalSeparateLine.centerX).offset(0);
    }];
    
    UILabel *usedLimitLab = [[UILabel alloc]init];
    usedLimitLab.font = [UIFont systemFontOfSize:15.f];
    usedLimitLab.textAlignment = NSTextAlignmentCenter;
    usedLimitLab.textColor = VVColor666666;
    usedLimitLab.numberOfLines = 1;
    usedLimitLab.text = @"已用额度";
    [_homeStatusBg addSubview:usedLimitLab];
    _usedLimitLab = usedLimitLab;
    
    [usedLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(0);
        make.right.mas_equalTo(self.verticalSeparateLine.mas_right).offset(0);
        make.top.mas_equalTo(self.horizontalSeparateLine.mas_bottom).offset(18);
        make.height.equalTo(@18);
    }];
    
    UILabel *usedLimitDetialLab = [[UILabel alloc]init];
    usedLimitDetialLab.font = [UIFont fontWithName:@"DINPro-Regular" size:21.f];
    usedLimitDetialLab.textAlignment = NSTextAlignmentCenter;
    usedLimitDetialLab.textColor = VVColor666666;
    usedLimitDetialLab.numberOfLines = 1;
    usedLimitDetialLab.text = @"";
    [_homeStatusBg addSubview:usedLimitDetialLab];
    _usedLimitDetialLab = usedLimitDetialLab;
    
    [usedLimitDetialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(0);
        make.right.mas_equalTo(self.verticalSeparateLine.mas_right).offset(0);
        make.top.mas_equalTo(self.usedLimitLab.mas_bottom).offset(10);
        make.height.equalTo(@18);
    }];
    
    UILabel *lineOfCreditLimitLab = [[UILabel alloc]init];
    lineOfCreditLimitLab.font = [UIFont systemFontOfSize:15.f];
    lineOfCreditLimitLab.textAlignment = NSTextAlignmentCenter;
    lineOfCreditLimitLab.textColor = VVColor666666;
    lineOfCreditLimitLab.numberOfLines = 1;
    lineOfCreditLimitLab.text = @"授信额度";
    [_homeStatusBg addSubview:lineOfCreditLimitLab];
    _lineOfCreditLimitLab = lineOfCreditLimitLab;
    
    [lineOfCreditLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.verticalSeparateLine.mas_left).offset(3);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-3);
        make.top.mas_equalTo(self.horizontalSeparateLine.mas_bottom).offset(18);
        make.height.equalTo(@18);
    }];
    
    UILabel *lineOfCreditLimitDetialLab = [[UILabel alloc]init];
    lineOfCreditLimitDetialLab.font = [UIFont fontWithName:@"DINPro-Regular" size:21.f];
    lineOfCreditLimitDetialLab.textAlignment = NSTextAlignmentCenter;
    lineOfCreditLimitDetialLab.textColor = VVColor666666;
    lineOfCreditLimitDetialLab.numberOfLines = 1;
    lineOfCreditLimitDetialLab.text = @"";
    [_homeStatusBg addSubview:lineOfCreditLimitDetialLab];
    _lineOfCreditLimitDetialLab = lineOfCreditLimitDetialLab;
    
    [lineOfCreditLimitDetialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.verticalSeparateLine.mas_left).offset(0);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(0);
        make.top.mas_equalTo(self.lineOfCreditLimitLab.mas_bottom).offset(10);
        make.height.equalTo(@18);
    }];

    
    VVCommonButton *applyBtn = [VVCommonButton solidBlueButtonWithTitle:@"立即申请"];
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:applyBtn];
    _applyBtn = applyBtn;
    applyBtn.layer.cornerRadius = 22;
    applyBtn.layer.masksToBounds = YES;
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-25);
        if (ISIPHONE6Plus) {
            make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-35);
        }
        make.height.equalTo(@44);
    }];
    
    //提现按钮
    VVCommonButton *withdrawalBtn = [VVCommonButton solidBlueButtonWithTitle:@"立即提现"];
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:withdrawalBtn];
    [withdrawalBtn setBackgroundImage:[UIImage imageNamed:@"btn_user_refund"] forState:UIControlStateNormal];

    _withdrawalBtn = withdrawalBtn;
    withdrawalBtn.layer.cornerRadius = 22;
    withdrawalBtn.layer.masksToBounds = YES;
    [withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.width.equalTo(@77);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-25);
        if (ISIPHONE6Plus) {
            make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-35);
        }
        make.height.equalTo(@44);
    }];
    
    //会员按钮
    VVCommonButton *payVipBtn = [VVCommonButton solidBlueButtonWithTitle:@"加入会员"];
    [payVipBtn addTarget:self action:@selector(payForVip) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payVipBtn];
    [payVipBtn setBackgroundImage:[UIImage imageNamed:@"btn_user_VIP"] forState:UIControlStateNormal];
    _payVipBtn = payVipBtn;
    payVipBtn.layer.cornerRadius = 22;
    payVipBtn.layer.masksToBounds = YES;
    [payVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(homeStatusBg.mas_left).offset(-38);
        make.width.equalTo(@77);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-25);
        if (ISIPHONE6Plus) {
            make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-35);
        }
        make.height.equalTo(@44);
    }];
    _withdrawalBtn.hidden = YES;
    _payVipBtn.hidden = YES;

    UILabel * approvingTipLab = [[UILabel alloc]init];
    approvingTipLab.font = [UIFont systemFontOfSize:14.f];
    approvingTipLab.textAlignment = NSTextAlignmentCenter;
    approvingTipLab.textColor = [UIColor redColor];
    approvingTipLab.numberOfLines = 0;
    approvingTipLab.text = @"";
    [_homeStatusBg addSubview:approvingTipLab];
    _approvingTipLabl = approvingTipLab;
    
    [approvingTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.applyBtn.mas_top).offset(-15);
        make.left.mas_equalTo(self.applyBtn.mas_left).offset(0);
        make.right.mas_equalTo(self.applyBtn.mas_right).offset(0);
        
    }];
}

- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type
{
    self.type = type;
    _statusTopView.hidden = YES;
    self.applyBtn.enabled = YES;
//    [self.applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.approvingTipLabl.hidden = NO;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
    NSString *avaiableMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.vbsCreditMoney-data.usedMoney]];
    NSString *usedMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.usedMoney]];
    NSString *creditMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.vbsCreditMoney]];

//    self.availableLimitDetialLab.text = [NSString stringWithFormat:@"￥%@",avaiableMoney];
    self.usedLimitDetialLab.text = [NSString stringWithFormat:@"%@",usedMoney];
    self.lineOfCreditLimitDetialLab.text = [NSString stringWithFormat:@"%@",creditMoney];
    
    [self.availableLimitDetialLab setHomeMoneyRichText:avaiableMoney];
//    [self.usedLimitDetialLab setHomeMoneyRichText:usedMoney];
//    [self.lineOfCreditLimitDetialLab setHomeMoneyRichText:creditMoney];

    
    self.billBgImg.hidden = self.billLabTop.hidden = self.billLabBottom.hidden = YES;
    self.usedLimitLab.textColor = self.usedLimitDetialLab.textColor = self.lineOfCreditLimitLab.textColor = self.lineOfCreditLimitDetialLab.textColor = VVColor666666;
    self.availableLimitLab.textColor  = [UIColor globalThemeColor];
    _withdrawalBtn.hidden = YES;
    _payVipBtn.hidden = YES;
    _applyBtn.hidden = NO;

    switch (type) {
        case HomeStatus_AmountInvalid:
        {
            self.billBgImg.hidden = self.billLabTop.hidden = self.billLabBottom.hidden = NO;
//            self.billLabTop.text = @"额度";
//            self.billLabBottom.text = @"失效";
            self.billBgImg.image = [UIImage imageNamed:@"amount_invalid"];
            
            self.usedLimitLab.textColor = self.usedLimitDetialLab.textColor = self.lineOfCreditLimitLab.textColor = self.lineOfCreditLimitDetialLab.textColor = [UIColor colorWithHexString:@"999999"];
//            self.availableLimitDetialLab.text = @"￥0";
            [self.availableLimitDetialLab setHomeMoneyRichText:@"0"];

            self.usedLimitDetialLab.text = self.lineOfCreditLimitDetialLab.text = @"0";
            self.approvingTipLabl.text = @"您的额度已失效，请重新申请";
            [self.applyBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_AdvanceIn30Days:
        {
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = [NSString stringWithFormat:@"您的额度有效期还有%@日，快去提现吧!",@(data.lockDays)];
            [self.applyBtn setTitle:@"立即提现" forState:UIControlStateNormal];
            [self.applyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_homeStatusBg.mas_right).offset(-38);
            }];
            _applyBtn.hidden = YES;
            _withdrawalBtn.hidden = NO;
            _payVipBtn.hidden = NO;
        }
            break;
        case HomeStatus_AdvanceApprovedWaitReviewing:
        {
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];

            self.approvingTipLabl.text = @"额度提现电审中";
            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_Advancing:
        {
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];

            self.approvingTipLabl.text = @"等待放款中";
            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_ReviewRefused:
        {
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text =  [NSString stringWithFormat:@"提现失败,请于%@日后重新尝试",@(data.lockDays)];
            [self.applyBtn setTitle:@"立即提现" forState:UIControlStateNormal];
            self.applyBtn.enabled = NO;
//            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
//            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        }
            break;
        case HomeStatus_SignatureRefused:
        {
            //签名未通过
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = @"额度提现电审中";
            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_FillBankCardInfo:
        {
            //银行卡填写
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = @"提现资料提交中，请继续提现";
            [self.applyBtn setTitle:@"继续提现" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_FillContractInfo:
        {
            //合同资料填写
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = @"提现资料提交中，请继续提现";
            [self.applyBtn setTitle:@"继续提现" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_SignaturePassed:
        {
            //签名通过
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = @"额度提现电审中";
            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_ReviewPassed:
        {
            //电审通过
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = @"等待放款中";
            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_Loaded:
        {
            //已放款
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
//            self.approvingTipLabl.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足",[[data.repayDate substringFromIndex:8] substringToIndex:2],[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length - 4]];
            self.approvingTipLabl.text = @"已放款，账单生成中";
            self.applyBtn.enabled = NO;
//            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateDisabled];
            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_Termination:
        {
            //已解约
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = @"您的额度有效期还有30日，快去提现吧!";
            [self.applyBtn setTitle:@"立即提现" forState:UIControlStateNormal];
        }
            break;
//        case HomeStatus_Loading:
//        {
//            self.approvingTipLabl.text = @"放款中";
//            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
//        }
//            break;
//        case HomeStatus_RepayingPleWaiting:
//        {
//            self.approvingTipLabl.text = @"还款中,请耐心等待";
//            self.applyBtn.enabled =NO;
//            [self.applyBtn setBackgroundColor:[UIColor unableButtonThemeColor] forState:UIControlStateDisabled];
//            [self.applyBtn setTitle:@"继续提现" forState:UIControlStateNormal];
//        }
//            break;
//        case HomeStatus_LoadAndNotRepay:
//        {
////            self.approvingTipLabl.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足",data.billDate,[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length - 4]];
//            self.approvingTipLabl.text = @"已放款，账单生成中";
//            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
//            self.applyBtn.enabled = NO;
//            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
//            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//        }
//            break;
//        case HomeStatus_Repaying:
//        {
//           
//        }
//            break;
        case HomeStatus_RepayDone:
        {
            //还款完成
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = [NSString stringWithFormat:@"您的额度有效期还有%@日，快去提现吧！",@(data.lockDays)];
            [self.applyBtn setTitle:@"立即提现" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_LockOrder:
        {
            //锁单
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            //计算天数
            if (data.lockDays < 0) {
                self.approvingTipLabl.text = @"很抱歉，您暂不符合提现要求！";
            }else{
                self.approvingTipLabl.text = [NSString stringWithFormat:@"提现失败，请于%@日后重新尝试",@(data.lockDays)];
            }
            self.applyBtn.enabled = NO;
//            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
//            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [self.applyBtn setTitle:@"立即提现" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_LoanAgain:
        {
            //再贷
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            //计算天数
            self.approvingTipLabl.text = [NSString stringWithFormat:@"您的额度有效期还有%@日，快去提现吧！",@(data.lockDays)];
            [self.applyBtn setTitle:@"立即提现" forState:UIControlStateNormal];

        }
            break;
            case HomeStatus_FillContractInfoAgain:
        {
            //再贷
            _statusTopView.hidden = NO;
            [_statusTopView updateIWithType:self.type];
            self.approvingTipLabl.text = @"提现资料提交中，请继续提现";
            [self.applyBtn setTitle:@"继续提现" forState:UIControlStateNormal];
        }
            break;
//        case HomeStatus_Repayment_Normal_Doing:
//        {
//            self.approvingTipLabl.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足",[[data.repayDate substringFromIndex:8] substringToIndex:2],[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length - 4]];
//            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
//        }
//            break;
        default:
            break;
    }
}

#pragma mark - 按钮事件
- (void)applyBtnClick
{
    if ([self.delegate respondsToSelector:@selector(clickBtnWithStatus:)]) {
        [self.delegate clickBtnWithStatus:self.type];
    }
}

- (void)payForVip
{
    VVLog(@"开通会员");
}

@end
