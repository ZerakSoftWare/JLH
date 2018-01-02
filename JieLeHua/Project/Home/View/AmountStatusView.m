//
//  AmountStatusView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "AmountStatusView.h"
@interface AmountStatusView ()
@property (nonatomic) HomeStatus type;
@property(nonatomic,strong) UIImageView * homeStatusBg;
@property (nonatomic, strong) VVCommonButton *applyBtn;
@property (nonatomic, strong) UILabel *approvingTipLabl;
@property(nonatomic,strong) UIImageView * amountApprovingImg;
@property(nonatomic,strong) UILabel * approvingStatusLab;
@end

@implementation AmountStatusView

+ (instancetype)amountStatusWithType:(HomeStatus)type frame:(CGRect)frame
{
    return [[self alloc] amountStatusWithType:type frame:frame];
}

- (instancetype)amountStatusWithType:(HomeStatus)type frame:(CGRect)frame
{
    if (self == [super init]) {
        self.frame = frame;
        self.type = type;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI界面
- (void)setupUI
{
    UIImageView * homeStatusBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noamount_img_card_bg"]];
    homeStatusBg.frame = self.frame;
    [self addSubview:homeStatusBg];
    _homeStatusBg = homeStatusBg;
    
    VVCommonButton *applyBtn = [VVCommonButton solidBlueButtonWithTitle:@"立即申请"];
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    applyBtn.layer.cornerRadius = 22;
    applyBtn.layer.masksToBounds = YES;
    [self addSubview:applyBtn];
    _applyBtn = applyBtn;
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-52);
//        if (ISIPHONE6Plus) {
//            make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-35);
//        }
        make.height.equalTo(@44);
    }];
    
    //额度申请中
    UIImageView * amountApprovingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_home_no_lines"]];
    [_homeStatusBg addSubview:amountApprovingImg];
    _amountApprovingImg = amountApprovingImg;
    [amountApprovingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(55);
        make.width.mas_equalTo(@204.5);
        make.height.mas_equalTo(@191.5);
        make.centerX.mas_equalTo(self.homeStatusBg.centerX).offset(0);
//        if (ISIPHONE4 || ISIPHONE5) {
//            make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(50);
//            make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(25);
//            make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-25);
//            make.bottom.mas_equalTo(self.homeStatusBg.mas_bottom).offset(-135);
//        }
//        else{
//            make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(50);
//            make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(ISIPHONE6Plus?55:65);
//            make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(ISIPHONE6Plus?-55:-65);
//            make.bottom.mas_equalTo(self.homeStatusBg.mas_bottom).offset(ISIPHONE6Plus?-135:-120);
//        }
    }];
    
//    UILabel * approvingStatusLab = [[UILabel alloc]init];
//    approvingStatusLab.font = [UIFont systemFontOfSize:14.f];
//    approvingStatusLab.textAlignment = NSTextAlignmentCenter;
//    approvingStatusLab.textColor = [UIColor globalThemeColor];
//    approvingStatusLab.text = @"";
//    [_homeStatusBg addSubview:approvingStatusLab];
//    _approvingStatusLab = approvingStatusLab;
//    [approvingStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(self.amountApprovingImg.mas_bottom).offset(5);
//        make.left.mas_equalTo(self.amountApprovingImg.mas_left).offset(0);
//        make.right.mas_equalTo(self.amountApprovingImg.mas_right).offset(0);
//        
//    }];
    
    
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

- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type;
{
    self.type = type;
    self.applyBtn.enabled = YES;
//    [self.applyBtn setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    _homeStatusBg.image = [UIImage imageNamed:@"noamount_img_card_bg"];
//    [self.applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.approvingTipLabl.hidden = self.approvingStatusLab.hidden = NO;
    switch (type) {
        case HomeStatus_NoData:
        case HomeStatus_NoAmount:
        {
            self.approvingTipLabl.hidden = YES;
            _amountApprovingImg.image = [UIImage imageNamed:@"img_home_no_lines"];
            self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"999999"];
//            self.approvingStatusLab.text = @"暂无额度";
            [self.applyBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_AmountApproving:
        {
            if (data.reApply == 1) {
                //首贷
                self.approvingTipLabl.hidden = YES;
                self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"ff3131"];
                //            self.approvingStatusLab.text = @"额度审批中";
                _amountApprovingImg.image = [UIImage imageNamed:@"amount_reviewing"];
                [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            }else{
                self.approvingTipLabl.hidden = YES;
                self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"ff3131"];
                //            self.approvingStatusLab.text = @"额度审批中";
                _amountApprovingImg.image = [UIImage imageNamed:@"img_zaidai_edu_shenpi"];
                [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            }
           
        }
            break;
        case HomeStatus_AmountInvalid:
        case HomeStatus_CanNotGetAmount:
        {
            if (data.reApply == 1) {
                //首贷
                [self getReviewFailedWithData:data];
            }else{
                //再贷
                [self getReReviewFailedWithData:data];
            }
        }
            break;
        case HomeStatus_Huabei:
        case HomeStatus_ZhimaShouxin:
        case HomeStatus_BaseInfo:
        case HomeStatus_IdentityAuthentication:
        case HomeStatus_OrganCreditReporting:
        case HomeStatus_InternetCreditReporting:
        {
            self.approvingTipLabl.hidden = YES;
            self.approvingStatusLab.textColor = [UIColor globalThemeColor];
//            self.approvingStatusLab.text = @"额度申请中";
            _amountApprovingImg.image = [UIImage imageNamed:@"amountApproving"];
            [self.applyBtn setTitle:@"继续申请" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_CreditReportingSignPassed:
        {
            if (data.reApply == 1) {
                //首贷
                self.approvingTipLabl.hidden = YES;
                self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"ff3131"];
                //            self.approvingStatusLab.text = @"额度审批中";
                _amountApprovingImg.image = [UIImage imageNamed:@"amount_reviewing"];
                [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            }else{
                if (![data.isMemberShip isEqualToString:@"1"]) {
                    //再贷
                    self.approvingTipLabl.hidden = NO;
                    self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"999999"];
                    _homeStatusBg.image = [UIImage imageNamed:@"noamount_img_card_bg"];
                    _amountApprovingImg.image = [UIImage imageNamed:@"img_21"];
                    self.approvingTipLabl.text = [NSString stringWithFormat:@"请%@日后重新获取额度",@(data.lockMemberDays)];
                    [self.applyBtn setTitle:@"立即加入会员" forState:UIControlStateNormal];
                    self.applyBtn.enabled = YES;
                }
                else{
                    self.approvingTipLabl.hidden = YES;
                    self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"ff3131"];
                    //            self.approvingStatusLab.text = @"额度审批中";
                    _amountApprovingImg.image = [UIImage imageNamed:@"img_zaidai_edu_shenpi"];
                    [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
                }
            }
        }
            break;
        case HomeStatus_CreditReportingSignRefused:
        {
            self.approvingTipLabl.hidden = NO;
            self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"ff3131"];
//            self.approvingStatusLab.text = @"额度审批中";
            self.approvingTipLabl.text = @"您的额度申请资料出现问题，请立即更新";
            _amountApprovingImg.image = [UIImage imageNamed:@"amount_reviewing"];
            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_IncreasingMoney:
        {
            self.approvingTipLabl.hidden = YES;
            self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"ff3131"];
                        self.approvingStatusLab.text = @"额度审批中";
            _amountApprovingImg.image = [UIImage imageNamed:@"img_3_1"];
            self.applyBtn.enabled = YES;
            [self.applyBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        }
            break;
            case HomeStatus_LockedForever:
        {
            self.approvingTipLabl.hidden = YES;
            self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"999999"];
            _homeStatusBg.image = [UIImage imageNamed:@"noamount_img_card_bg"];
            _amountApprovingImg.image = [UIImage imageNamed:@"img_20"];
            [self.applyBtn setTitle:@"重新申请" forState:UIControlStateNormal];
//            [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            self.applyBtn.enabled = NO;
//            [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
        }
            break;
        default:
            break;
    }
}

- (void)getReReviewFailedWithData:(JJMainStateSummaryModel *)data
{
    self.approvingTipLabl.hidden = NO;
    self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"999999"];
    _homeStatusBg.image = [UIImage imageNamed:@"noamount_img_card_bg"];
    _amountApprovingImg.image = [UIImage imageNamed:@"img_20"];
    
    if (data.lockDays <= 0)
    {
        self.approvingTipLabl.text = @"您即将可以提现，明天再来看看吧！";
    }else{
        self.approvingTipLabl.text = [NSString stringWithFormat:@"%@日后可重新申请",@(data.lockDays)];
    }

    [self.applyBtn setTitle:@"重新申请" forState:UIControlStateNormal];
//    [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.applyBtn.enabled = NO;
//    [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];

}


- (void)getReviewFailedWithData:(JJMainStateSummaryModel *)data
{
    self.approvingTipLabl.hidden = NO;
    self.approvingStatusLab.textColor = [UIColor colorWithHexString:@"999999"];
    //            self.approvingStatusLab.text = @"暂无额度";
    _homeStatusBg.image = [UIImage imageNamed:@"noamount_img_card_bg"];
    _amountApprovingImg.image = [UIImage imageNamed:@"img_failure"];
#ifdef JIELEHUAQUICK
    if ([data.userSource isEqualToString:@"0"]) {
        if (data.lockDays < 0) {
            self.approvingTipLabl.text = @"很抱歉，您暂不能申请额度！\n不要气馁哦！再去试一试花花的精选吧";
        }else{
            self.approvingTipLabl.text = [NSString stringWithFormat:@"%@日后可重新申请\n不要气馁哦！再去试一试花花的精选吧",@(data.lockDays)];
        }
        [self.applyBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        self.applyBtn.enabled = YES;
    }else{
        self.approvingStatusLab.text = @"暂无额度";
        if (data.lockDays <= 0) {
            self.approvingTipLabl.text = @"您即将可以提现，明天再来看看吧";
        }else{
            self.approvingTipLabl.text = [NSString stringWithFormat:@"%@日后可重新申请",@(data.lockDays)];
        }
        [self.applyBtn setTitle:@"重新申请" forState:UIControlStateNormal];
//        [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        self.applyBtn.enabled = NO;
//        [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
    }
#elif JIELEHUA
    if ([data.userSource isEqualToString:@"0"]) {
        if (data.lockDays < 0) {
            self.approvingTipLabl.text = @"很抱歉，您暂不能申请额度！\n不要气馁哦！再去试一试花花的精选吧";
        }else{
            self.approvingTipLabl.text = [NSString stringWithFormat:@"%@日后可重新申请\n不要气馁哦！再去试一试花花的精选吧",@(data.lockDays)];
        }
        [self.applyBtn setTitle:@"马上申请" forState:UIControlStateNormal];
        self.applyBtn.enabled = YES;
    }else{
        self.approvingStatusLab.text = @"暂无额度";
        if (data.lockDays <= 0) {
            self.approvingTipLabl.text = @"您即将可以提现，明天再来看看吧";
        }else{
            self.approvingTipLabl.text = [NSString stringWithFormat:@"%@日后可重新申请",@(data.lockDays)];
        }
        [self.applyBtn setTitle:@"重新申请" forState:UIControlStateNormal];
//        [self.applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        self.applyBtn.enabled = NO;
//        [self.applyBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]  forState:UIControlStateDisabled];
    }
#endif
}

#pragma mark - 点击按钮
- (void)applyBtnClick
{
    if ([self.delegate respondsToSelector:@selector(clickBtnWithStatus:)]) {
        [self.delegate clickBtnWithStatus:self.type];
    }
}

@end
