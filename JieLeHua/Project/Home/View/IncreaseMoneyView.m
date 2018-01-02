//
//  IncreaseMoneyView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IncreaseMoneyView.h"
#import "UILabel+MoneyRich.h"
#import "IncreaseMoneyButton.h"
#import "StatusTopView.h"

@interface IncreaseMoneyView ()<IncreaseMoneyButtonDelegate>
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
@property (nonatomic, strong) UILabel *approvingTipLabl;

//@property (nonatomic, strong) IncreaseMoneyButton *increaseBtn;

@property (nonatomic, strong) UILabel *lockDayLabel;
@property (nonatomic, strong) StatusTopView *statusTopView;
@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) VVCommonButton *increaBtn;
@property (nonatomic, strong) VVCommonButton *shortApplyBtn;
@end

@implementation IncreaseMoneyView
+ (instancetype)increaseStatusWithType:(HomeStatus)type frame:(CGRect)frame;
{
    return [[self alloc] increaseStatusWithType:type frame:frame];
}

- (instancetype)increaseStatusWithType:(HomeStatus)type frame:(CGRect)frame;
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
    
    //xx日有效
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.backgroundColor = [UIColor colorWithHexString:@"dbf2fb"];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.layer.masksToBounds = YES;
    _dayLabel.layer.cornerRadius = 4;
    _dayLabel.textColor = [UIColor colorWithHexString:@"578999"];
    _dayLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_dayLabel];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_statusTopView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(homeStatusBg.mas_centerX);
        make.width.equalTo(@75);
        make.height.equalTo(@22.5);
    }];
    
    
    //
//    UIImage *img = [UIImage imageNamed:@"img_label_green_1"];
//    UIImageView * billBgImg = [[UIImageView alloc]initWithImage:img];
//    [_homeStatusBg addSubview:billBgImg];
//    _billBgImg = billBgImg;
//
//    [billBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(55);
//        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(-20);
//        make.width.equalTo(@76.5);
//        make.height.equalTo(@57);
//    }];
    
    //倒计时label
//    _lockDayLabel = [[UILabel alloc] init];
//    _lockDayLabel.numberOfLines = 2;
//    _lockDayLabel.textAlignment = NSTextAlignmentCenter;
//    _lockDayLabel.textColor = [UIColor whiteColor];
//    [_homeStatusBg addSubview:_lockDayLabel];
//
//    [_lockDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(55);
//        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(-20);
//        make.width.equalTo(@76.5);
//        make.height.equalTo(@57);
//    }];
    
    //显示各种额度
    UIView * horizontalSeparateLine = [[UIView alloc]init];
    horizontalSeparateLine.backgroundColor = VVColor999999;
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
//    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    // 表情图片
//    attch.image = [UIImage imageNamed:@"icon_home"];
//    // 设置图片大小
//    attch.bounds = CGRectMake(0, 0, 19, 16);
//    
//    // 创建带有图片的富文本
//    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"可用额度"];
//    [attri insertAttributedString:string atIndex:0];
//    availableLimitLab.attributedText = attri;
//    [_homeStatusBg addSubview:availableLimitLab];
//    _availableLimitLab = availableLimitLab;
//    
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
    
    
    VVCommonButton *applyBtn = [VVCommonButton solidBlueButtonWithTitle:@"立即提现"];
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
    
    _increaBtn = [VVCommonButton solidBlueButtonWithTitle:@"立即提额"];
    [_increaBtn addTarget:self action:@selector(increaseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_increaBtn];
    _increaBtn.layer.cornerRadius = 22;
    _increaBtn.layer.masksToBounds = YES;
    
    _shortApplyBtn = [VVCommonButton hollowButtonWithTitle:@"立即提现"];
    [_shortApplyBtn setTitleColor:[UIColor colorWithHexString:@"36a2ff"] forState:UIControlStateNormal];
    _shortApplyBtn.layer.borderColor = [UIColor colorWithHexString:@"36a3ff"].CGColor;
    [_shortApplyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shortApplyBtn];
    _shortApplyBtn.layer.cornerRadius = 22;
    _shortApplyBtn.layer.masksToBounds = YES;
    
   
    [_increaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-32);
        make.left.mas_equalTo(verticalSeparateLine.mas_right).offset(6);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-65);
        make.height.equalTo(@44);
    }];
    
    [_shortApplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(32);
        make.right.mas_equalTo(verticalSeparateLine.mas_left).offset(-6);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-65);
        make.height.equalTo(@44);
    }];
//    self.increaBtn.hidden = self.shortApplyBtn.hidden = YES;
    
//    _increaseBtn = [[[NSBundle mainBundle] loadNibNamed:@"IncreaseMoneyButton" owner:self options:nil] lastObject];
//    _increaseBtn.delegate = self;
//    [self addSubview:_increaseBtn];
//    [_increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (ISIPHONE6Plus) {
//            make.height.equalTo(@80);
//
//        }else{
//            make.height.equalTo(@74);
//        }
//        make.bottom.mas_equalTo(self.applyBtn.mas_top).offset(-40);
//        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(0);
//        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(0);
//    }];
//    [_increaseBtn setupUIWithHuabeiStatus:NO gongjijinStatus:NO];

}

- (void)updateUIWithData:(JJMainStateModel *)data type:(HomeStatus)type
{
    self.type = type;
    self.applyBtn.enabled = YES;
    self.applyBtn.hidden = YES;
    [self.increaBtn setTitle:@"立即提额" forState:UIControlStateNormal];

//    [self.applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.approvingTipLabl.hidden = NO;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    [formatter setPositiveFormat:@"#,###.##"];  //自定义数据格式
    NSString *avaiableMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.summary.vbsCreditMoney-data.summary.usedMoney]];
    NSString *usedMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.summary.usedMoney]];
    NSString *creditMoney = [formatter stringFromNumber:[NSNumber numberWithFloat:data.summary.vbsCreditMoney]];
    
    //    self.availableLimitDetialLab.text = [NSString stringWithFormat:@"￥%@",avaiableMoney];
    self.usedLimitDetialLab.text = [NSString stringWithFormat:@"%@",usedMoney];
    self.lineOfCreditLimitDetialLab.text = [NSString stringWithFormat:@"%@",creditMoney];
    
    [self.availableLimitDetialLab setHomeMoneyRichText:avaiableMoney];
    
    self.billLabTop.hidden = self.billLabBottom.hidden = YES;
    self.usedLimitLab.textColor = self.usedLimitDetialLab.textColor = self.lineOfCreditLimitLab.textColor = self.lineOfCreditLimitDetialLab.textColor = VVColor666666;
    self.availableLimitLab.textColor = [UIColor globalThemeColor];
    _dayLabel.text  = [NSString stringWithFormat:@"%@日有效",@(data.summary.lockDays)];
    
    //本地假数据，与服务器33状态不雷同
    if (type == HomeStatus_LoanAgain) {
        [self showBtnEnable:YES];
//        [_horizontalSeparateLine mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(180);
//        }];
    }else{
        [self showBtnEnable:NO];
//        [_horizontalSeparateLine mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(130);
//        }];
    }
    
    
    
//    if (data.improveCreditStatus.gongjijinCreditStatus == 0 && data.improveCreditStatus.antsChantFlowersCreditStatus == 0) {
//
//    }
//    else if (data.improveCreditStatus.gongjijinCreditStatus == 4 && data.improveCreditStatus.antsChantFlowersCreditStatus == 4){
//        //公积金提额失败
//        [_increaseBtn setupUIWithHuabeiStatus:YES gongjijinStatus:YES];
//    }
//    else if (data.improveCreditStatus.gongjijinCreditStatus == 4){
//        //公积金提额失败
//        [_increaseBtn setupUIWithHuabeiStatus:NO gongjijinStatus:YES];
//    }
//    else if (data.improveCreditStatus.antsChantFlowersCreditStatus == 4){
//        //花呗失败
//        [_increaseBtn setupUIWithHuabeiStatus:YES gongjijinStatus:NO];
//    }
//    else {
//        [_increaseBtn removeFromSuperview];
//    }
//    data.data.isMemberShip = @"1";
    if (![data.data.isMemberShip isEqualToString:@"1"]) {
        self.increaBtn.hidden = self.shortApplyBtn.hidden = NO;
        self.applyBtn.hidden = YES;
        [self.increaBtn setTitle:@"加入会员" forState:UIControlStateNormal];
    }else{
        //会员
    }
}

- (void)showBtnEnable:(BOOL)hidden
{
    if (hidden) {
//        self.increaseBtn.hidden = YES;
        self.increaBtn.hidden = self.shortApplyBtn.hidden = YES;
        self.applyBtn.hidden = NO;
    }else{
//        self.increaseBtn.hidden = NO;
        self.increaBtn.hidden = self.shortApplyBtn.hidden = NO;
        self.applyBtn.hidden = YES;
    }
}


#pragma mark - 按钮事件
- (void)applyBtnClick
{
    if ([self.delegate respondsToSelector:@selector(clickBtnWithStatus:)]) {
        [self.delegate clickBtnWithStatus:self.type];
    }
}

- (void)increaseAction
{
    if ([self.delegate respondsToSelector:@selector(presentIncrease)]) {
        [self.delegate presentIncrease];
    }
}

#pragma mark - IncreaseMoneyButtonDelegate
- (void)startIncreaseMoneyWithType:(IncreaseType)type
{
    if (type == IncreaseType_Huabei) {
        [[JCRouter shareRouter] pushURL:@"huabei/1"];
    }else{
        //
//        [VVAlertUtils showAlertViewWithTitle:@"" message:@"即将开放，敬请期待" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//            [alertView hideAlertViewAnimated:YES];
//        }];
        [[JCRouter shareRouter] pushURL:@"housing"];
    }
}

@end
