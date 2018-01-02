//
//  BillStatusDetailView.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "BillStatusDetailView.h"
#import "StatusTopView.h"

@interface BillStatusDetailView()
@property (nonatomic) HomeStatus type;
@property(nonatomic,strong) UIImageView * homeStatusBg;

@property (nonatomic, strong) StatusTopView *statusTopView;
//当月应还款总额(元)
@property (nonatomic, strong) UILabel *tipLabel;
//总金额￥1221.03
@property (nonatomic, strong) UILabel *totalAmountLabel;
//平台推荐费
@property (nonatomic, strong) UILabel *tuijianfeiLabel;
//已逾期账单:
@property (nonatomic, strong) UILabel *yuqiLabel;
//10月账单:
@property (nonatomic, strong) UILabel *monthLabel;
//最晚还款日:
@property (nonatomic, strong) UILabel *lastTimeLabel;
//按钮 立即还款
@property (nonatomic, strong) VVCommonButton *applyBtn;
//为避免个人征信记录出现不良记录，请按时还款
@property (nonatomic, strong) UILabel *tipBottomLabel;
@end

@implementation BillStatusDetailView

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
    [_homeStatusBg addSubview:_statusTopView];
    
    _statusTopView = [StatusTopView initWithType:self.type];
    [self addSubview:_statusTopView];
    [_statusTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeStatusBg.mas_top).offset(16);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@20);
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = @"当月应还款总额(元)";
    UIFont *mediumFont = [UIFont fontWithName:@"PingFangSC-Medium"size:15];//这个是9.0以后自带的平方字体
    if(mediumFont == nil){
//        //这个是我手动导入的第三方平方字体
        mediumFont = [UIFont fontWithName:@"PingFangSC-Medium"size:15];
    }

//    for (NSString *fontFamilyName in [UIFont familyNames])
//    {
//        NSLog(@"fontFamilyName:'%@'", fontFamilyName);
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    }
    
    _tipLabel.font = mediumFont;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor colorWithHexString:@"444444"];
    [self addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeStatusBg.mas_top).offset(64);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@21);
    }];
    
    

    //总金额
    _totalAmountLabel = [[UILabel alloc] init];
    _totalAmountLabel.textColor = [UIColor colorWithHexString:@"333333"];
   
    _totalAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_totalAmountLabel];
    [_totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeStatusBg.mas_top).offset(95.5);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@48);
    }];
    
    //平台推荐费
    _tuijianfeiLabel = [[UILabel alloc] init];
    _tuijianfeiLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tuijianfeiLabel];
    [_tuijianfeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeStatusBg.mas_top).offset(161);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@18.5);
    }];
    
    //已逾期
    _yuqiLabel = [[UILabel alloc] init];
    _yuqiLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_yuqiLabel];
    [_yuqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeStatusBg.mas_top).offset(183.5);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@18.5);
    }];
    //几月份
    _monthLabel = [[UILabel alloc] init];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_monthLabel];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeStatusBg.mas_top).offset(206);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@18.5);
    }];
    //最晚还款
    _lastTimeLabel = [[UILabel alloc] init];
    _lastTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lastTimeLabel];
    [_lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_monthLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.height.equalTo(@18.5);
    }];
    
    //还款按钮
    VVCommonButton *applyBtn = [VVCommonButton solidBlueButtonWithTitle:@"立即还款"];
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    applyBtn.layer.cornerRadius = 22;
    applyBtn.layer.masksToBounds = YES;
    [self addSubview:applyBtn];
    _applyBtn.clipsToBounds = YES;
    _applyBtn = applyBtn;
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(38);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(-38);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-65);
        make.height.equalTo(@44);
    }];
    
    _tipBottomLabel = [[UILabel alloc] init];
    _tipBottomLabel.textAlignment = NSTextAlignmentCenter;
    _tipBottomLabel.font = [UIFont systemFontOfSize:11];
    _tipBottomLabel.text = @"为避免个人征信记录出现不良记录，请按时还款";
    _tipBottomLabel.textColor = [UIColor colorWithHexString:@"2bacff"];
    [self addSubview:_tipBottomLabel];
    [_tipBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeStatusBg.mas_left).offset(0);
        make.right.mas_equalTo(homeStatusBg.mas_right).offset(0);
        make.bottom.mas_equalTo(homeStatusBg.mas_bottom).offset(-40);
        make.height.equalTo(@15);
    }];
}

- (void)updateUIWithData:(JJMainStateSummaryModel *)data type:(HomeStatus)type
{
    self.type = type;
    [_statusTopView updateIWithType:type];
    NSString *totalAmount = @"";//应还总金额
    NSString *pingtaiAmount = @"";//平台推荐费
    NSString *yuqiAmount = @"";//逾期
    NSString *dayAmount = @"";//几月
    NSString *monthAmount = @"";//几日
    NSString *statusString = @"";//当月账单状态
    
    totalAmount =  [NSString stringWithFormat:@"%.2f",data.dueSumamt];;
    pingtaiAmount = data.formalitiesFee;
    yuqiAmount = data.overDueAmt;
    monthAmount = [NSString stringWithFormat:@"%@/%@期",@(data.billPeriod),data.postLoanPeriod];
    dayAmount = [NSString stringWithFormat:@"%@月%@日",[[data.repayDate substringFromIndex:5] substringToIndex:2],[[data.repayDate substringFromIndex:8] substringToIndex:2]];
    _totalAmountLabel.textColor = [UIColor colorWithHexString:@"333333"];
    switch (type) {
        case HomeStatus_Repayment_Overdate_Not:
        {
            _applyBtn.enabled = YES;
            //逾期账单 37
            if ([data.currentPeriodBillAmt isEqualToString:@"noBill"]) {
                [_monthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@0);
                }];
            }else{
                [_monthLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@18.5);
                }];
                statusString = data.currentPeriodBillAmt;
            }
        }
            break;
        case HomeStatus_Repayment_Overdate_Doing:
        {
            //逾期还款中   扣款中 38
//            statusString = @"扣款中";
            statusString = data.currentPeriodBillAmt;
            _applyBtn.enabled = NO;
        }
            break;
        case HomeStatus_LoadAndNotRepay:
        {
            //账单生成中 29状态
            totalAmount = @"账单生成中";
            statusString = @"账单生成中";
            pingtaiAmount = @"账单生成中";
            dayAmount = @"账单生成中";
            yuqiAmount = @"暂无";
            _applyBtn.enabled = NO;
        }
            break;
        case HomeStatus_Charge:
        {
            //扣款中 43
            statusString = data.currentPeriodBillAmt;
            _applyBtn.enabled = NO;
        }
            break;
        case HomeStatus_Freeze:
        {
            //扣款中 45状态
            statusString = data.currentPeriodBillAmt;
            _applyBtn.enabled = NO;
        }
            break;
            
        case HomeStatus_Repayment_Normal_Doing:
        {
            //正常账单  36
            statusString = data.currentPeriodBillAmt;
            _applyBtn.enabled = YES;
        }
            break;
        case HomeStatus_Repayment_Cloan_Doing:
        {
            //提前清贷  39
            statusString = @"扣款中";
            totalAmount = @"清贷中";
            _applyBtn.enabled = NO;
        }
            break;
        default:
            break;
    }
    //设置字体格式和大小
    if (type == HomeStatus_LoadAndNotRepay) {
        _totalAmountLabel.textColor = [UIColor colorWithHexString:@"0d88ff"];
        NSString *str = [NSString stringWithFormat:@"%@",totalAmount];
        //创建NSMutableAttributedString
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        if (ISIPHONE4||ISIPHONE5) {
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0f] range:NSMakeRange(0, str.length)];
        }else{
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28.0f] range:NSMakeRange(0, str.length)];
        }
        _totalAmountLabel.attributedText = attrStr;
    }
    else if (type == HomeStatus_Repayment_Cloan_Doing){
        _totalAmountLabel.textColor = [UIColor colorWithHexString:@"95aeec"];
        NSString *str = [NSString stringWithFormat:@"%@",totalAmount];
        //创建NSMutableAttributedString
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        if (ISIPHONE4||ISIPHONE5) {
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0f] range:NSMakeRange(0, str.length)];
        }else{
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28.0f] range:NSMakeRange(0, str.length)];
        }
        _totalAmountLabel.attributedText = attrStr;
    }
    else{
        NSString *str = [NSString stringWithFormat:@"￥%@",totalAmount];
        //创建NSMutableAttributedString
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        //设置字体和设置字体的范围
        if (ISIPHONE4||ISIPHONE5) {
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19.0f] range:NSMakeRange(0, 1)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINPro-Bold" size:38] range:NSMakeRange(1, str.length - 1)];
        }else{
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0f] range:NSMakeRange(0, 1)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINPro-Bold" size:48] range:NSMakeRange(1, str.length - 1)];
        }
        [attrStr addAttribute:NSBaselineOffsetAttributeName value:@(15) range:NSMakeRange(0, 1)];
        _totalAmountLabel.attributedText = attrStr;
    }
    
    
    //创建NSMutableAttributedString
//    NSString *tuijianfeiStr = [NSString stringWithFormat:@"平台推荐费: %@",pingtaiAmount];
    NSString *tuijianfeiStr = @"";
//    NSMutableAttributedString *tuijianfeiAttrStr = [[NSMutableAttributedString alloc]initWithString:tuijianfeiStr];
    //设置字体和设置字体的范围
//    [tuijianfeiAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"]  range:NSMakeRange(6,tuijianfeiStr.length-6)];
    UIFont *semiboldFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:13];//这个是9.0以后自带的平方字体
    if(semiboldFont == nil){
//        //这个是我手动导入的第三方平方字体
        semiboldFont = [UIFont fontWithName:@"PingFangSC-Medium"size:13];
    }

    UIFont *mediumFont = [UIFont fontWithName:@"PingFangSC-Medium"size:13];//这个是9.0以后自带的平方字体
    if(mediumFont == nil){
        //这个是我手动导入的第三方平方字体
        mediumFont = [UIFont fontWithName:@"PingFangSC-Medium"size:13];
    }
    
//    [tuijianfeiAttrStr addAttribute:NSFontAttributeName value:semiboldFont range:NSMakeRange(6, tuijianfeiStr.length-6)];
//    [tuijianfeiAttrStr addAttribute:NSFontAttributeName value:mediumFont range:NSMakeRange(0, 6)];
//    [tuijianfeiAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"929292"]  range:NSMakeRange(0,6)];
//    self.tuijianfeiLabel.attributedText = tuijianfeiAttrStr;
    
    //创建NSMutableAttributedString
    NSString *yuqiStr = [NSString stringWithFormat:@"已逾期账单: %@",[self isPureFloat:yuqiAmount]?[NSString stringWithFormat: @"￥%@",yuqiAmount]:yuqiAmount];
    NSMutableAttributedString *yuqiAttrStr = [[NSMutableAttributedString alloc]initWithString:yuqiStr];
    //设置字体和设置字体的范围
    [yuqiAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"]  range:NSMakeRange(6,yuqiStr.length-6)];
    [yuqiAttrStr addAttribute:NSFontAttributeName value:semiboldFont range:NSMakeRange(6, yuqiStr.length-6)];
    [yuqiAttrStr addAttribute:NSFontAttributeName value:mediumFont range:NSMakeRange(0, 6)];
    [yuqiAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"929292"]  range:NSMakeRange(0,6)];
    self.yuqiLabel.attributedText = yuqiAttrStr;
    
    //创建NSMutableAttributedString
    NSString *monthStr = [NSString stringWithFormat:@"%@月账单: %@",monthAmount,[self isPureFloat:statusString] ? [NSString stringWithFormat: @"￥%@",statusString] : statusString];
    NSMutableAttributedString *monthAttrStr = [[NSMutableAttributedString alloc]initWithString:monthStr];
    //设置字体和设置字体的范围
    [monthAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"]  range:NSMakeRange(8,monthStr.length-8)];
    
    [monthAttrStr addAttribute:NSFontAttributeName value:semiboldFont range:NSMakeRange(8, monthStr.length-8)];
    [monthAttrStr addAttribute:NSFontAttributeName value:mediumFont range:NSMakeRange(0, 8)];
    [monthAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"929292"]  range:NSMakeRange(0,8)];
    self.monthLabel.attributedText = monthAttrStr;
    
    //创建NSMutableAttributedString
    NSString *lastStr = [NSString stringWithFormat:@"最晚还款日: %@",dayAmount];
    NSMutableAttributedString *lastAttrStr = [[NSMutableAttributedString alloc]initWithString:lastStr];
    //设置字体和设置字体的范围
    [lastAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"]  range:NSMakeRange(6,lastStr.length-6)];
    [lastAttrStr addAttribute:NSFontAttributeName value:semiboldFont range:NSMakeRange(6, lastStr.length-6)];
    [lastAttrStr addAttribute:NSFontAttributeName value:mediumFont range:NSMakeRange(0, 6)];
    [lastAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"929292"]  range:NSMakeRange(0,6)];
    self.lastTimeLabel.attributedText = lastAttrStr;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 按钮事件
- (void)applyBtnClick
{
    if ([self.delegate respondsToSelector:@selector(clickBtnWithStatus:)]) {
        [self.delegate clickBtnWithStatus:self.type];
    }
}
@end
