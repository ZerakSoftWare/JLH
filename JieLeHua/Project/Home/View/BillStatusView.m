//
//  BillStatusView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "BillStatusView.h"
#import "UILabel+MoneyRich.h"

@interface BillStatusView ()
@property (nonatomic) HomeStatus type;

@property(nonatomic,strong) UIImageView * homeStatusBg;
@property(nonatomic,strong) UIImageView * billBgImg;
@property(nonatomic,strong) UILabel * billLabTop;
@property(nonatomic,strong) UILabel * billLabBottom;
@property(nonatomic,strong) UILabel * billTipLab;
@property(nonatomic,strong) UILabel * repaymentLab;
@property(nonatomic,strong) UILabel * repaymentTipLab;
@property (nonatomic, strong) VVCommonButton *applyBtn;
@property (nonatomic, strong) UILabel *approvingTipLabl;

@property(nonatomic,strong) UIImageView * qingdaiImg;

@end

@implementation BillStatusView

+ (instancetype)billStatusWithType:(HomeStatus)type frame:(CGRect)frame;
{
    return [[self alloc] billStatusWithType:type frame:frame];
}

- (instancetype)billStatusWithType:(HomeStatus)type frame:(CGRect)frame;
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

    //正常账单
    UIImage *img = [UIImage imageNamed:@"img_label_home_blue"];
    UIImageView * billBgImg = [[UIImageView alloc]initWithImage:img];
    [_homeStatusBg addSubview:billBgImg];
    _billBgImg = billBgImg;
    
    [billBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(55);
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(-20);
        make.width.equalTo(@76.5);
        make.height.equalTo(@57);
    }];
    
    
//    UILabel * billLabTop = [[UILabel alloc]init];
//    billLabTop.font = [UIFont systemFontOfSize:18.f];
//    billLabTop.textAlignment = NSTextAlignmentCenter;
//    billLabTop.textColor = [UIColor whiteColor];
//    billLabTop.numberOfLines = 1;
//    billLabTop.text = @"";
//    [_billBgImg addSubview:billLabTop];
//    _billLabTop = billLabTop;
    
//    _billLabTop = [[UILabel alloc]init];
//    _billLabTop.font = [UIFont systemFontOfSize:18.f];
//    _billLabTop.textAlignment = NSTextAlignmentCenter;
//    _billLabTop.textColor = [UIColor whiteColor];
//    _billLabTop.numberOfLines = 1;
//    _billLabTop.text = @"";
//    [_billBgImg addSubview:_billLabTop];
//    _billBgImg = billBgImg;
//    
//    
//    [_billLabTop mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(self.billBgImg.mas_top).offset(8);
//        make.left.mas_equalTo(self.billBgImg.mas_left).offset(0);
//        make.right.mas_equalTo(self.billBgImg.mas_right).offset(0);
//        make.height.equalTo(@18);
//        
//    }];
//    
//    UILabel * billLabBottom = [[UILabel alloc]init];
//    billLabBottom.font = [UIFont systemFontOfSize:18.f];
//    billLabBottom.textAlignment = NSTextAlignmentCenter;
//    billLabBottom.textColor = [UIColor whiteColor];
//    billLabBottom.numberOfLines = 1;
//    billLabBottom.text = @"";
//    [_billBgImg addSubview:billLabBottom];
//    _billLabBottom = billLabBottom;
//    
//    [billLabBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.billBgImg.mas_bottom).offset(-16);
//        make.left.mas_equalTo(self.billBgImg.mas_left).offset(0);
//        make.right.mas_equalTo(self.billBgImg.mas_right).offset(0);
//        make.height.equalTo(@18);
//    }];
    
    UILabel *billTipLab = [[UILabel alloc]init];
    billTipLab.font = [UIFont systemFontOfSize:14.f];
    billTipLab.textAlignment = NSTextAlignmentLeft;
    billTipLab.textColor = VVColor666666;
    billTipLab.numberOfLines = 0;
    billTipLab.text = @"";
    [_billBgImg addSubview:billTipLab];
    _billTipLab = billTipLab;
    
    [billTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.billBgImg.centerY).offset(0);
        make.left.mas_equalTo(self.billBgImg.mas_right).offset(10);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-10);
    }];
    
    UILabel * repaymentLab = [[UILabel alloc]init];
    repaymentLab.font = [UIFont systemFontOfSize:38.f];
    repaymentLab.textAlignment = NSTextAlignmentCenter;
    repaymentLab.textColor = [UIColor globalThemeColor];
    repaymentLab.numberOfLines = 1;
    repaymentLab.text = @"";
    //        repaymentLab.text = [NSString stringWithFormat:@"¥%@",reAmt];
    [_billBgImg addSubview:repaymentLab];
    _repaymentLab =repaymentLab;
    
    [repaymentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.billTipLab.mas_bottom).offset(40);
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(0);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(0);
        make.height.equalTo(@38);
    }];
    
    UILabel * repaymentTipLab =[[UILabel alloc]init];
    repaymentTipLab.font = [UIFont systemFontOfSize:14.f];
    repaymentTipLab.textAlignment = NSTextAlignmentCenter;
    repaymentTipLab.textColor = VVColor999999;
    repaymentTipLab.numberOfLines = 0;
    repaymentTipLab.text = @"";
    [_billBgImg addSubview:repaymentTipLab];
    _repaymentTipLab = repaymentTipLab;
    
    [repaymentTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repaymentLab.mas_bottom).offset(30);
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(20);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-20);
        
    }];
    
    VVCommonButton *applyBtn = [VVCommonButton solidWhiteButtonWithTitle:@""];
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:applyBtn];
    applyBtn.layer.cornerRadius = 22;
    applyBtn.layer.masksToBounds = YES;
    _applyBtn = applyBtn;
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-25);
        if (ISIPHONE6Plus) {
            make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-35);
        }
        make.height.equalTo(@44);
    }];
    
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
    
    
    
    //正常账单
    img = [UIImage imageNamed:@"qingdai"];
    UIImageView *qingdaiImage = [[UIImageView alloc]initWithImage:img];
    [_homeStatusBg addSubview:qingdaiImage];
    _qingdaiImg = qingdaiImage;
    
    [qingdaiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(35);
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(80);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-40);
        make.width.equalTo(@190);
        if (ISIPHONE6Plus) {
            make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-60);
            make.width.equalTo(@170);
        }
        make.height.equalTo(@134);
    }];
    _qingdaiImg.hidden = YES;
}

- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type
{
    self.type = type;
    _qingdaiImg.hidden = YES;
    self.repaymentLab.hidden = NO;
    self.billTipLab.hidden = NO;
    //11,12,13暂时注释，不会用到
    NSString *day = [NSString stringWithFormat:@"%@月%@日",[[data.repayDate substringFromIndex:5] substringToIndex:2],[[data.repayDate substringFromIndex:8] substringToIndex:2]];
    switch (type) {
        case HomeStatus_Repayment_Normal_Doing:
        {
            self.billTipLab.text = [NSString stringWithFormat:@"【%@/%@期】%@应还总金额(元)",@(data.billPeriod),data.postLoanPeriod,day];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            formatter.numberStyle =NSNumberFormatterDecimalStyle;
            [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
            NSString *dueSumamtMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.dueSumamt]];
            self.repaymentTipLab.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足", [[data.repayDate substringFromIndex:8] substringToIndex:2],[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length-4]];
            [self.repaymentLab setHomeMoneyRichText:[NSString stringWithFormat:@"%@",dueSumamtMoney]];
            
            self.approvingTipLabl.text = @"";
            self.billBgImg.image = [UIImage imageNamed:@"img_label_blue"];
            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
            self.applyBtn.enabled = YES;
            [self.applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_Repayment_Overdate_Not:
        {
            self.billTipLab.text = [NSString stringWithFormat:@"【%@/%@期】%@应还总金额(元)",@(data.billPeriod),data.postLoanPeriod,day];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            formatter.numberStyle =NSNumberFormatterDecimalStyle;
            [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
            NSString *dueSumamtMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.dueSumamt]];
            self.repaymentTipLab.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足", [[data.repayDate substringFromIndex:8] substringToIndex:2],[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length-4]];
            [self.repaymentLab setHomeMoneyRichText:[NSString stringWithFormat:@"%@",dueSumamtMoney]];

            self.approvingTipLabl.text = @"本期账单已逾期，请及时还款";
//            self.billLabTop.text = @"逾期";
//            self.billLabBottom.text = @"账单";
            self.billBgImg.image = [UIImage imageNamed:@"yuqi"];
            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
            self.applyBtn.enabled = YES;
            [self.applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_Repayment_Overdate_Doing:
        {
//            NSDate *time = [VVCommonFunc dateformatDateStr:data.repayDate formatter:@"yyyy-MM-dd HH:mm:ss"];
            self.billTipLab.text = [NSString stringWithFormat:@"【%@/%@期】%@应还总金额(元)",@(data.billPeriod),data.postLoanPeriod,day];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            formatter.numberStyle =NSNumberFormatterDecimalStyle;
            [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
            NSString *dueSumamtMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.dueSumamt]];
            self.repaymentTipLab.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足", [[data.repayDate substringFromIndex:8] substringToIndex:2],[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length-4]];
            [self.repaymentLab setHomeMoneyRichText:[NSString stringWithFormat:@"%@",dueSumamtMoney]];

            
            self.approvingTipLabl.text = @"您已发起逾期账单还款，请留意银行卡扣款短信";
//            self.billLabTop.text = @"逾期";
//            self.billLabBottom.text = @"账单";
            self.billBgImg.image = [UIImage imageNamed:@"yuqi"];
            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
            self.applyBtn.enabled = NO;
            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
        }
            break;
        case HomeStatus_Repayment_Cloan_Doing:
        {
            NSString *day = [NSString stringWithFormat:@"%@年%@月%@日",[[data.repayDate substringFromIndex:0] substringToIndex:4],[[data.repayDate substringFromIndex:5] substringToIndex:2],[[data.repayDate substringFromIndex:8] substringToIndex:2]];
            self.billTipLab.text = [NSString stringWithFormat:@"%@申请还款金额",day];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            formatter.numberStyle =NSNumberFormatterDecimalStyle;
            [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
            NSString *dueSumamtMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.dueSumamt-data.reSumAmt]];
            [self.repaymentLab setHomeMoneyRichText:[NSString stringWithFormat:@"%@",dueSumamtMoney]];
            
            self.repaymentLab.hidden = YES;
            self.billTipLab.hidden = YES;
            _qingdaiImg.hidden = NO;
            self.repaymentTipLab.text = [NSString stringWithFormat:@"从%@尾号为(%@)的储蓄卡自动扣款（请确保余额充足）",data.bankName,[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length-4]];
            
            self.approvingTipLabl.text = @"您已发起提前清贷还款，请留意银行卡扣款短信";
//            self.billLabTop.text = @"提前";
//            self.billLabBottom.text = @"清贷";
            self.billBgImg.image = [UIImage imageNamed:@"advanced"];
            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            self.applyBtn.enabled = NO;
        }
            break;
            
        case HomeStatus_NeedRepayIn7Days:
        {
            
        }
            break;
        case HomeStatus_DeductFailured:
        {
            
        }
            break;
        case HomeStatus_NeedRepayImmediately:
            
            break;
        case HomeStatus_Charge:
        {
            //扣款中
            self.billTipLab.text = [NSString stringWithFormat:@"【%@/%@期】%@应还总金额(元)",@(data.billPeriod),data.postLoanPeriod,day];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            formatter.numberStyle =NSNumberFormatterDecimalStyle;
            [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
            NSString *dueSumamtMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.dueSumamt]];
            self.repaymentTipLab.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足", [[data.repayDate substringFromIndex:8] substringToIndex:2],[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length-4]];
            [self.repaymentLab setHomeMoneyRichText:[NSString stringWithFormat:@"%@",dueSumamtMoney]];
            
            
            self.approvingTipLabl.text = @"本期账单已发起扣款，请耐心等待扣款结果";
            self.billBgImg.image = [UIImage imageNamed:@"charge"];
            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
            self.applyBtn.enabled = NO;
            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
            
        }
            break;
        case HomeStatus_Freeze:
        {
            //扣款中
            self.billTipLab.text = [NSString stringWithFormat:@"【%@/%@期】%@应还总金额(元)",@(data.billPeriod),data.postLoanPeriod,day];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            formatter.numberStyle =NSNumberFormatterDecimalStyle;
            [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
            NSString *dueSumamtMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.dueSumamt]];
            self.repaymentTipLab.text = [NSString stringWithFormat:@"每月%@日自动扣款，请确保尾号为(%@)的银行卡资金充足", [[data.repayDate substringFromIndex:8] substringToIndex:2],[data.bankPersonAccount substringFromIndex:data.bankPersonAccount.length-4]];
            [self.repaymentLab setHomeMoneyRichText:[NSString stringWithFormat:@"%@",dueSumamtMoney]];
            
            
            self.approvingTipLabl.text = @"账单日扣款中，请耐心等待银行卡扣款消息";
            self.billBgImg.image = [UIImage imageNamed:@"charge"];
            [self.applyBtn setTitle:@"我要清贷" forState:UIControlStateNormal];
            self.applyBtn.enabled = NO;
            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
        }
            break;
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
@end
