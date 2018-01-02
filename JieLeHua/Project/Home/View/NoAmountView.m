//
//  NoAmountView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/7/11.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "NoAmountView.h"
#import "StatusTopView.h"
#import "JJGetTipsRequest.h"


@interface NoAmountView ()
@property (nonatomic) HomeStatus type;
@property(nonatomic,strong) UIImageView * homeStatusBg;
@property (nonatomic, strong) VVCommonButton *applyBtn;
@property (nonatomic, strong) UILabel *approvingTipLabl;
@property(nonatomic,strong) UIImageView * amountApprovingImg;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) StatusTopView *statusTopView;
@property (nonatomic, strong) JJTipsModel *tipsModel;
@end

@implementation NoAmountView
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
//        make.centerX.mas_equalTo(homeStatusBg.mas_centerX);
        make.width.mas_equalTo(vScreenWidth - 32*2 -38*2);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-52);
        make.height.equalTo(@44);
    }];
    
    //额度申请中
    UIImageView * amountApprovingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_home_no_lines"]];
    [_homeStatusBg addSubview:amountApprovingImg];
    _amountApprovingImg = amountApprovingImg;
    [amountApprovingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeStatusBg.mas_top).offset(92);
        make.centerX.mas_equalTo(self.homeStatusBg.mas_centerX);
        make.width.equalTo(@210.5);
        make.height.equalTo(@133);
    }];
    
    JJGetTipsRequest *request = [[JJGetTipsRequest alloc] initWithType:@"7"];
    __weak __typeof(self)weakSelf = self;

    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJTipsModel *model = [(JJGetTipsRequest *)request response];
        if (model.success) {
            weakSelf.tipsModel = model;
            [self setupBottomView];
        }else{
            
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
    
}

- (void)setupBottomView
{
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_homeStatusBg addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountApprovingImg.mas_bottom).offset(32);
        make.left.mas_equalTo(self.homeStatusBg.mas_left).offset(10);
        make.right.mas_equalTo(self.homeStatusBg.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.homeStatusBg.mas_bottom).offset(-120.5);
    }];
    
    
    UIView *leftView = [self createViewWithIcon:[UIImage imageNamed:@"icon_home_high"] title:[self.tipsModel.data[0] dicName] subTitle:[self.tipsModel.data[0] remark] subColor:[UIColor colorWithHexString:@"333333"]];
    leftView.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:leftView];
    
    UIView *middleView = [self createViewWithIcon:[UIImage imageNamed:@"icon_feilv"] title:[self.tipsModel.data[1] dicName] subTitle:[self.tipsModel.data[1] remark] subColor:[UIColor colorWithHexString:@"333333"]];
    middleView.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:middleView];
    
    UIView *rightView = [self createViewWithIcon:[UIImage imageNamed:@"icon_fast"] title:[self.tipsModel.data[2] dicName] subTitle:[self.tipsModel.data[2] remark] subColor:[UIColor colorWithHexString:@"333333"]];
    rightView.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView.mas_top).offset(0);
        make.left.mas_equalTo(self.bottomView.mas_left).offset(0);
        make.right.mas_equalTo(middleView.mas_left).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(0);
//        make.width.mas_equalTo(rightView);
        make.width.equalTo(@(self.frame.size.width/3-13));
    }];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView.mas_top).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(0);
        make.right.mas_equalTo(rightView.mas_left).offset(0);
        make.width.equalTo(@(self.frame.size.width/3+26));
    }];

    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView.mas_top).offset(0);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(0);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(0);
        make.width.equalTo(@(self.frame.size.width/3-13));
    }];
}

- (UIView *)createViewWithIcon:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle subColor:(UIColor *)subColor
{
    UIView *view = [[UIView alloc] init];
    UIImageView *iconView = [[UIImageView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = [UIFont systemFontOfSize:11];
    titleLabel.font = [UIFont systemFontOfSize:15];
    subTitleLabel.minimumScaleFactor = 0.5;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"0d88ff"];
    subTitleLabel.textColor = subColor;
    iconView.image = image;
    titleLabel.text = title;
    subTitleLabel.text = subTitle;
    [view addSubview:iconView];
    [view addSubview:titleLabel];
    [view addSubview:subTitleLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(0);
        if ([subTitle containsString:@"月"]) {
            make.left.mas_equalTo(view.mas_left).offset(10);
        }else{
            make.left.mas_equalTo(view.mas_left).offset(5);
        }
        make.width.equalTo(@19);
        make.height.equalTo(@16);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(0);
        make.left.mas_equalTo(iconView.mas_right).offset(0);
        make.right.mas_equalTo(view.mas_right).offset(0);
        make.height.mas_equalTo(iconView);
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).offset(0);
        if ([subTitle containsString:@"月"]) {
            make.left.mas_equalTo(view.mas_left).offset(0);
        }else{
            make.left.mas_equalTo(view.mas_left).offset(5);
        }
        make.right.mas_equalTo(view.mas_right).offset(0);
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
    }];
    
    return view;
}

- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type;
{
    self.type = type;
//    self.applyBtn.enabled = YES;
//    [self.applyBtn setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
//    [self.applyBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    switch (type) {
        case HomeStatus_NoAmount:
        {
            _amountApprovingImg.image = [UIImage imageNamed:@"img_home_no_lines"];
//            [self.applyBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        }
            break;
        case HomeStatus_AmountInvalid:
        {
            [_statusTopView updateIWithType:self.type];
            _amountApprovingImg.image = [UIImage imageNamed:@"img_home_no_lines"];
//            [self.applyBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 点击按钮
- (void)applyBtnClick
{
    if ([self.delegate respondsToSelector:@selector(clickBtnWithStatus:)]) {
        [self.delegate clickBtnWithStatus:self.type];
    }
}
@end
