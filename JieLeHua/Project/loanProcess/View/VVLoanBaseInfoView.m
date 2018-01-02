//
//  VVLoanBaseInfoView.m
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVLoanBaseInfoView.h"
#import "VVCommonTextField.h"
#import "VVCustomSwitchBtn.h"
#import "VVBasicDataModel.h"
#import "VVPickerView.h"
#import "VVSearchCityViewController.h"
#import "VVBasePreviewView.h"
#import "IQUIView+Hierarchy.h"

@interface VVLoanBaseInfoView ()<UITextFieldDelegate,VVPickerViewDelegate>{
    UIView *_baseScrollView;//用来切换界面的 view

    NSMutableArray *_allTxtFieldArr;
    //基本信息
    VVCommonTextField * _educatedField;//教育程度
    VVCommonTextField * _basicInfoMaritalStatusField;//婚姻状况
    VVCommonTextField * _basicInfoIndustriesField;//行业

    VVCommonTextField * _basicInfoAftertaxSalaryField;//打卡
    VVCommonTextField * _basicInfoCashSalaryField;//现金
    
    VVCommonTextField * _basicInfoProFundField;//是否缴纳公积金
    VVCommonTextField * _basicInfoProFundMoneyField;//公积金缴纳基数
    VVCommonTextField * _basicInfoCityField;//城市
    
    VVCommonTextField *  _basicInfoJobField;
    
    VVCustomSwitchBtn *_customSwitch;
    
    NSString * _educated;
    NSString * _maritalStatus;
    NSString *_industry;
    NSString *_professionType;

    
    UIButton * _moneybtn;
    NSString * _socialMonth;
    NSString * _accumulationFundMonth;
    NSString * _citySwitch;
    NSString * _revenueType;
    NSArray * _industriesArr; //行业
    VVPickerView * _vvPickerView;
    UIButton *_chooseBtn;

}
@property(nonatomic,strong) VVCreditBaseInfoModel *modelInfo;
@property (nonatomic, strong) VVCommonTextField * basicstoreIdField;//门店
@property (nonatomic, strong) VVCommonTextField * loanuseField;//贷款用途
@property (nonatomic, strong) VVBasicDataModel* basicModel;
@end
@implementation VVLoanBaseInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [VV_NC addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];

        _allTxtFieldArr = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
- (void)dealloc{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [VV_NC removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark subView

- (void)setupscrollView{
    _baseScrollView = [[UIView alloc] initWithFrame:CGRectZero];
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    _baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self addSubview: _baseScrollView];
}

#pragma mark  基本信息 ui
- (void)basicInformationView{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [_baseScrollView removeFromSuperview];
    [self setupscrollView];

    NSArray * textFieldArr = @[
                               @{@"left":@"教育程度",@"placeholder":@"请选择您的教育程度",@"right":@"arrow",@"enabled":@"YES",@"type":@"_educatedField"},
                               @{@"left":@"婚姻状况",@"placeholder":@"请选择您的婚姻状况",@"right":@"arrow",@"enabled":@"YES",@"type":@"_basicInfoMaritalStatusField"},
                               @{@"left":@"所属行业",@"placeholder":@"请选择您的工作所属行业",@"right":@"arrow",@"enabled":@"YES",@"type":@"_basicInfoIndustriesField"},
                                @{@"left":@"职业",@"placeholder":@"请选择您的职业",@"right":@"arrow",@"enabled":@"YES",@"type":@"_basicInfoJobField"},
                               @{@"left":@"月收入(打卡)",@"placeholder":@"请输入您的工资卡收入",@"right":@"btn_元",@"enabled":@"YES",@"type":@"_basicInfoAftertaxSalaryField"},
                               @{@"left":@"月收入(现金)",@"placeholder":@"请输入您的现金收入",@"right":@"btn_元",@"enabled":@"YES",@"type":@"_basicInfoCashSalaryField"},
                               @{@"left":@"缴纳公积金或社保",@"placeholder":@"  ",@"right":@"switch",@"enabled":@"NO",@"type":@"_basicInfoProFundField"},
                               @{@"left":@"贷款用途",@"placeholder":@"请选择您的贷款用途",@"right":@"arrow",@"enabled":@"YES",@"type":@"_loanuseField"},
                               @{@"left":@"所在城市",@"placeholder":@"请选择您的现居住地",@"right":@"arrow",@"enabled":@"YES",@"type":@"_basicstoreIdField"}
                               ];
    
    NSMutableArray *mutableArr = [textFieldArr mutableCopy];
    
    //    基本信息……
    textFieldArr = [mutableArr copy];
    
    __block CGFloat rectHeight = 0;
    __block CGFloat topHeight = 1;
    
    [textFieldArr enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVCommonTextField *textfield = [[VVCommonTextField alloc]initWithFrame:CGRectMake(ktextFieldLeft, topHeight, kScreenWidth-ktextFieldLeft, ktextFieldheight)];
        textfield.delegate = self;
        textfield.leftText = obj[@"left"];
        textfield.placeholder = obj[@"placeholder"];
        textfield.lineHeight = 0;
        textfield.tag = idx;
        NSString *right = obj[@"right"];
        NSString *enabled = obj[@"enabled"];
        NSString *type = obj[@"type"];
        
        UIView*lineView = [[UIView alloc]initWithFrame:CGRectMake(ktextFieldLeft, topHeight+46, kScreenWidth-ktextFieldLeft, 1)];
        lineView.backgroundColor = VV_COL_RGB(0xdddddd);
        [_baseScrollView addSubview:lineView];
        [_baseScrollView addSubview:textfield];
        [_allTxtFieldArr addObject:textfield];
        textfield.userInteractionEnabled = enabled.boolValue;
        
        if ([type isEqualToString:@"_educatedField"]) {
            _educatedField = textfield;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
        }else if ([type isEqualToString:@"_basicInfoMaritalStatusField"]){
            _basicInfoMaritalStatusField = textfield;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
        }else if ([type isEqualToString:@"_basicInfoIndustriesField"]){
            _basicInfoIndustriesField = textfield;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
        }else if ([type isEqualToString:@"_basicInfoJobField"]){
            _basicInfoJobField = textfield;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
        }else if ([type isEqualToString:@"_basicInfoAftertaxSalaryField"]){
            _basicInfoAftertaxSalaryField = textfield;
            _basicInfoAftertaxSalaryField.maxlength = 6;
            _basicInfoAftertaxSalaryField.keyboardType = UIKeyboardTypeNumberPad;
            _basicInfoAftertaxSalaryField.returnKeyType = UIReturnKeyDone;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
            textfield.frame =   CGRectMake(ktextFieldLeft, textfield.top, kScreenWidth-90, ktextFieldheight);
            
            UIButton *btn =  [self customWenHaoBtn:@"元"];
            btn.frame =  CGRectMake(kScreenWidth-35, textfield.top + 2, 80, ktextFieldheight);
            btn.tag = 100;
            [btn addTarget:self  action:@selector(clickWagesDetails:) forControlEvents:UIControlEventTouchUpInside];
            [_baseScrollView addSubview:btn];
            [_baseScrollView bringSubviewToFront:btn];

            
        }else if ([type isEqualToString:@"_basicInfoCashSalaryField"]){
            _basicInfoCashSalaryField = textfield;
            _basicInfoCashSalaryField.maxlength = 6;
            _basicInfoCashSalaryField.keyboardType = UIKeyboardTypeNumberPad;
            _basicInfoCashSalaryField.returnKeyType = UIReturnKeyDone;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
            textfield.frame =   CGRectMake(ktextFieldLeft, textfield.top , kScreenWidth-90, ktextFieldheight);
            
            UIButton *btn =  [self customWenHaoBtn:@"元"];
            btn.frame =  CGRectMake(kScreenWidth-35, textfield.top + 2, 80, ktextFieldheight);
            btn.tag = 110;
            [btn addTarget:self  action:@selector(clickWagesDetails:) forControlEvents:UIControlEventTouchUpInside];
            [_baseScrollView addSubview:btn];
            [_baseScrollView bringSubviewToFront:btn];
            
        }else if ([type isEqualToString:@"_basicInfoProFundField"]){
            _basicInfoProFundField = textfield;
            
            UIImage *offImage = VV_GETIMG(@"btn_round_grey");
            UIImage *onImage = VV_GETIMG(@"btn_round_check");
//            VVCustomSwitchBtn *customSwitch = [VVCustomSwitchBtn switchButton];
//            [customSwitch switchButton:onImage offImage:offImage];
//            customSwitch.frame =  CGRectMake(kScreenWidth-onImage.size.width-ktextFieldLeft, topHeight+(ktextFieldheight-onImage.size.height)/2, onImage.size.width, onImage.size.height);
//            [customSwitch addTarget:self action:@selector(switchFlipped:) forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];
//            customSwitch.tag = 200;
//            customSwitch.hidden = YES;
//            _customSwitch = customSwitch;
//            [_baseScrollView addSubview:customSwitch];
            for (int i = 0; i<2; i++) {
                
                NSArray * nameArr = @[@"已缴",@"未缴"];
                UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [chooseBtn setImage:offImage forState:UIControlStateNormal];
                [chooseBtn setImage:onImage forState:UIControlStateSelected];
                [chooseBtn addTarget:self action:@selector(styleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                chooseBtn.frame =  CGRectMake(kScreenWidth-onImage.size.width-ktextFieldLeft - i*65 - 40, topHeight+(ktextFieldheight-onImage.size.height)/2, onImage.size.width, onImage.size.height);
                chooseBtn.tag = 1000 + i;
                [_baseScrollView addSubview:chooseBtn];
                _chooseBtn = chooseBtn;
                
                UILabel *nameLab = [[UILabel alloc]init];
                nameLab.text = nameArr[i];
                nameLab.font = [UIFont systemFontOfSize:14.f];
                nameLab.textColor = VVColor999999;
                nameLab.frame =  CGRectMake(chooseBtn.frame.size.width + chooseBtn.frame.origin.x , topHeight+(ktextFieldheight-onImage.size.height)/2, 40,25);
                [_baseScrollView addSubview:nameLab];
                
                if (!(VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.educationCode))) {
                    
                    if (VV_SHDAT.creditBaseInfoModel.isPayFundSocial == 1) {
                        if (i == 0) {
                            chooseBtn.selected = YES;
                        }else if (i == 1){
                            chooseBtn.selected = NO;
                        }
                    }else if(VV_SHDAT.creditBaseInfoModel.isPayFundSocial == 0){
                        if (i == 0) {
                            chooseBtn.selected = NO;
                        }else if (i == 1){
                            chooseBtn.selected = YES;
                        }
                    }
                    
                }
                
            }
            if ([_modelInfo.socialMonth integerValue]>0||[_socialMonth integerValue]>0) {
//                customSwitch.on = YES;
                _socialMonth = [_modelInfo.socialMonth integerValue]==0?_socialMonth:_modelInfo.socialMonth;
                _accumulationFundMonth =  [_modelInfo.accumulationFundMonth integerValue]==0?_accumulationFundMonth:_modelInfo.accumulationFundMonth;
                if (VV_IS_NIL(_accumulationFundMonth)) {
                    _accumulationFundMonth = @"0";
                }
            }else{
//                customSwitch.on = NO;
                _socialMonth = @"0";
                _accumulationFundMonth = @"0";
            }
            topHeight = textfield.bottom+1;
            lineView.height = 1;
        }else if ([type isEqualToString:@"_loanuseField"]){
            _loanuseField =textfield;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
        }else if ([type isEqualToString:@"_basicstoreIdField"]){
            _basicstoreIdField = textfield;
            topHeight = textfield.bottom+1;
            lineView.height = 1;
        }
        
        if ([right isEqualToString:@"arrow"]) {
            UIImage* img = VV_GETIMG(@"arrow_right");
            UIImageView*rightAccessory = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-img.size.width, textfield.top+(textfield.height-img.size.width)/2, img.size.width, img.size.height)];
            rightAccessory.image = img;
            rightAccessory.hidden = NO;
            [_baseScrollView addSubview:rightAccessory];
        }
        [_baseScrollView bringSubviewToFront: textfield];
        
        
        rectHeight = textfield.bottom;
    }];
    
    
    if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.educationCode) ) {
        _educated =  VV_SHDAT.creditBaseInfoModel.educationCode;
        
        NSDictionary *educationDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
        NSArray *educationArr = educationDic[@"education"];
        [educationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
            if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.educationCode]) {
                _educatedField.text = basicModel.dicName;
                *stop = YES;
            }
        }];
        
    }else{
        if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.education)) {
            
            NSDictionary *educationDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
            NSArray *educationArr = educationDic[@"education"];
            [educationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
                if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.educationCode]) {
                    _educatedField.text = basicModel.dicName;
                    *stop = YES;
                }
            }];
        }
    }
    
    if (!VV_IS_NIL( VV_SHDAT.creditBaseInfoModel.marriageCode) ) {
        _maritalStatus =  VV_SHDAT.creditBaseInfoModel.marriageCode;
        
        NSDictionary *marriageDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
        NSArray *marriageArr = marriageDic[@"marriage"];
        [marriageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj];
            if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.marriageCode]) {
                _basicInfoMaritalStatusField.text = basicModel.dicName;
                *stop = YES;
            }
        }];
        
    }else{
        if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.marriage)) {
            NSDictionary *marriageDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
            NSArray *marriageArr = marriageDic[@"marriage"];
            [marriageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj];
                if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.marriage]) {
                    _basicInfoMaritalStatusField.text = basicModel.dicName;
                    *stop = YES;
                }
            }];
        }
    }
    
    if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.loanUseCode) ) {
        NSDictionary *loansUseDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
        NSArray *loansUseArr = loansUseDic[@"loansUse"];
        [loansUseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
            if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.loanUseCode]) {
                _loanuseField.text = basicModel.dicName;
                *stop = YES;
            }
        }];
        
    }else{
        if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.loansUse)) {
            NSDictionary *loansUseDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
            NSArray *loansUseArr = loansUseDic[@"loansUse"];
            [loansUseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
                if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.loansUse]) {
                    _loanuseField.text = basicModel.dicName;
                    *stop = YES;
                }
            }];
        }
    }
    
    if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.industryCode)) {
        _industry = VV_SHDAT.creditBaseInfoModel.industryCode;
        _basicInfoIndustriesField.text = VV_SHDAT.creditBaseInfoModel.industryCode;

    }else{
        if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.industry)) {
            _basicInfoIndustriesField.text = VV_SHDAT.creditBaseInfoModel.industry;
        }
    }

    if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.professionCode)) {
        _professionType = VV_SHDAT.creditBaseInfoModel.professionCode;
        NSDictionary *professionDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
        NSArray *professionArr = professionDic[@"customerType"];
        [professionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
            if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.professionCode]) {
                _basicInfoJobField.text = basicModel.dicName;
                *stop = YES;
            }
        }];
        
    }else{
        if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.profession)) {
            NSDictionary *professionDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
            NSArray *professionArr = professionDic[@"customerType"];
            [professionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
                if ([basicModel.dicCode isEqualToString: VV_SHDAT.creditBaseInfoModel.profession]) {
                    _basicInfoJobField.text = basicModel.dicName;
                    *stop = YES;
                }
            }];
        }
    }
    
    VVLog(@"VV_SHDAT.creditBaseInfoModel.......%@==%@----%p---%p",VV_SHDAT.creditBaseInfoModel.monthCardSalary,VV_SHDAT.creditBaseInfoModel.monthCashSalary,VV_SHDAT.creditBaseInfoModel,VV_SHDAT.creditBaseInfoModel.monthCashSalary);
    
    if ([VV_SHDAT.creditBaseInfoModel.monthCardSalary integerValue] >0||[VV_SHDAT.creditBaseInfoModel.monthCashSalary integerValue]>0 ) {
        _basicInfoAftertaxSalaryField.text = VV_SHDAT.creditBaseInfoModel.monthCardSalary;
        _basicInfoCashSalaryField.text = VV_SHDAT.creditBaseInfoModel.monthCashSalary;
    }else  if ([VV_SHDAT.creditBaseInfoModel.monthCardSalary integerValue] ==0&&[VV_SHDAT.creditBaseInfoModel.monthCashSalary integerValue]==0 ) {
        _basicInfoCashSalaryField.text = @"";
        _basicInfoAftertaxSalaryField.text = @"";
    }
    
    if (VV_SHDAT.creditBaseInfoModel.isPayFundSocial == 1) {
        _customSwitch.on = YES;
    }else if(VV_SHDAT.creditBaseInfoModel.isPayFundSocial == 0){
        _customSwitch.on = NO;
    }
    
    if (!VV_IS_NIL( VV_SHDAT.creditBaseInfoModel.liveCityName) ) {
        _basicstoreIdField.text =  VV_SHDAT.creditBaseInfoModel.liveCityName;
    }

    if ([VV_SHDAT.creditBaseInfoModel.revenueType isEqualToString:@"现金"]) {
        _revenueType = @"现金";
        VV_SHDAT.creditBaseInfoModel.revenueType = _revenueType;
    }else{
        _revenueType = @"打卡";
        VV_SHDAT.creditBaseInfoModel.revenueType = _revenueType;
    }
    
    _accumulationFundMonth =  VV_SHDAT.creditBaseInfoModel.accumulationFundMonth;
    _socialMonth =  VV_SHDAT.creditBaseInfoModel.socialMonth;
    
    if (VV_IS_NIL(_accumulationFundMonth)) {
        _accumulationFundMonth = @"0";
    }
    if (VV_IS_NIL(_socialMonth)) {
        _socialMonth = @"0";
    }
    
    _nextBtn = [VVCommonButton solidButtonWithTitle:@"下一步"];
    _nextBtn.frame = CGRectMake(VVleftMargin, rectHeight+20, kScreenWidth-VVleftMargin*2, VVBtnHeight);
    [_nextBtn addTarget:self action:@selector(baseInfoNext:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:_nextBtn];
    [_nextBtn setUserInteractionEnabled:NO];

    _baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, _nextBtn.y+50);
    self.height = _baseScrollView.height;
    _controller.scrollView.contentSize = CGSizeMake(vScreenWidth, self.bottom);

    [self showBaseInfoBtnStatues];
}

- (void)styleBtnClick:(UIButton *)button{
    if (button.tag == 1000) {
        UIButton * btn = [self viewWithTag:1001];
        btn.selected = NO;
        button.selected = YES;
        VV_SHDAT.creditBaseInfoModel.isPayFundSocial = 1;
        VVLog(@"已缴%ld",VV_SHDAT.creditBaseInfoModel.isPayFundSocial);
        
    }else{
        UIButton * btn = [self viewWithTag:1000];
        btn.selected = NO;
        button.selected = YES;
        VV_SHDAT.creditBaseInfoModel.isPayFundSocial =0;
        VVLog(@"未缴%ld",VV_SHDAT.creditBaseInfoModel.isPayFundSocial);
    }
}

- (UIButton *)customWenHaoBtn:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 30)];
    [btn setImage:VV_GETIMG(@"wenhao") forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 40, 0, 2)];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:VV_COL_RGB(0x000000) forState:UIControlStateNormal];
    return btn;
    
}


- (void)baseInfoNext:(id)sender{
    
    if ([VV_SHDAT.orderInfo.applyStatusCode integerValue] == applyTypeBase) {
       
        [VVAlertUtils showAlertViewWithTitle:@"提示" message:[ NSString stringWithFormat:@"您当前工作所在的城市为%@，确认信息后，所在城市将无法修改", VV_SHDAT.creditBaseInfoModel.liveCityName] customView:nil cancelButtonTitle:@"修改" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex != kCancelButtonTag) {
                [alertView hideAnimated:YES];
                [self showPreview];
                
            }
        }];

    }else{
        [self showPreview];
    }
}

- (void)showPreview{
    
    VV_SHDAT.creditBaseInfoModel.education = _educatedField.text;
    VV_SHDAT.creditBaseInfoModel.loansUse = _loanuseField.text;
    VV_SHDAT.creditBaseInfoModel.industry = _basicInfoIndustriesField.text;
    VV_SHDAT.creditBaseInfoModel.marriage = _basicInfoMaritalStatusField.text;
    VV_SHDAT.creditBaseInfoModel.monthCardSalary =  _basicInfoAftertaxSalaryField.text;
    VV_SHDAT.creditBaseInfoModel.monthCashSalary =  _basicInfoCashSalaryField.text;
    VV_SHDAT.creditBaseInfoModel.profession = _basicInfoJobField.text;
    UIView *customView = [VVBasePreviewView basePreview:nil];

    [VVAlertUtils showAlertViewWithTitle:@"请核对您的基本信息" message:nil customView:customView cancelButtonTitle:@"修改" otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != kCancelButtonTag) {
            [alertView hideAlertViewAnimated:YES];
                [self postBaseInfoToServer];
     
        }
    }];

}

- (void)postBaseInfoToServer{
    
  
    __block NSString *englishEducationCode ;
    NSDictionary *educationDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    NSArray *educationArr = educationDic[@"education"];
    
    [educationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
        if ([basicModel.dicName isEqualToString: VV_SHDAT.creditBaseInfoModel.education]) {
            englishEducationCode = basicModel.dicCode;
            *stop = YES;
        }
    }];
    
    __block NSString *englishMarriageCode ;
    NSDictionary *marriageDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    NSArray *marriageArr = marriageDic[@"marriage"];
    [marriageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
        if ([basicModel.dicName isEqualToString: VV_SHDAT.creditBaseInfoModel.marriage]) {
            englishMarriageCode = basicModel.dicCode;
            *stop = YES;
        }
    }];
    
    __block NSString *englishProfessionCode ;
    NSDictionary *professionDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    NSArray *professionArr = professionDic[@"customerType"];
    [professionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
        if ([basicModel.dicName isEqualToString: VV_SHDAT.creditBaseInfoModel.profession]) {
            englishProfessionCode = basicModel.dicCode;
            *stop = YES;
        }
    }];
    
    __block NSString *loansUseCode ;
    NSDictionary *loansUseDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    NSArray *loansUseArr = loansUseDic[@"loansUse"];
    [loansUseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
        if ([basicModel.dicName isEqualToString: VV_SHDAT.creditBaseInfoModel.loansUse]) {
            loansUseCode = basicModel.dicCode;
            *stop = YES;
        }
    }];

    NSString *cityCode ;
    if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.liveCity)) {
        cityCode = VV_SHDAT.creditBaseInfoModel.liveCity;
    }else{
        if (!VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.cityCode)) {
            cityCode = VV_SHDAT.creditBaseInfoModel.cityCode;
        }else{
            cityCode = @"";
        }
    }
   
    NSDictionary *dic = @{
                          @"customerId": [UserModel currentUser].customerId,
                          @"educationCode": englishEducationCode,
                          @"industryCode":VV_SHDAT.creditBaseInfoModel.industry,
                          @"cityCode": cityCode ,
                          @"liveCityName": VV_SHDAT.creditBaseInfoModel.liveCityName,
                          @"marriageCode": englishMarriageCode,
                          @"monthCardSalary": VV_SHDAT.creditBaseInfoModel.monthCardSalary,
                          @"monthCashSalary": VV_SHDAT.creditBaseInfoModel.monthCashSalary,
                          @"paySocial": @(VV_SHDAT.creditBaseInfoModel.isPayFundSocial),
                          @"professionCode":englishProfessionCode,
                          @"loansUse":loansUseCode
                          };
    
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postApplyUpdateCustomerBaseInfoParameters:dic success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if (VV_SHDAT.creditBaseInfoModel.isPayFundSocial == 1)
        {
            //已缴纳社保公积金数
            [MobClick event:@"is_pay_fundSocial"];
        }
        else
        {
            //没有缴纳社保公积金数
            [MobClick event:@"no_pay_fundSocial"];
        }
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            
                VVOrderInfoModel *orderInfo = nil;
                NSDictionary *resultData = [result safeObjectForKey:@"data"];
                
                orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
                VV_SHDAT.orderInfo = orderInfo;
                
                VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
                VV_SHDAT.creditBaseInfoModel = baseInfoModel;
                
                JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
                VV_SHDAT.authenticationModel = authenticationModel;
                
                if ([strongSelf.loanBaseInfoDelagate respondsToSelector:@selector(postBaseInfoNextStep:)]) {
                    [strongSelf.loanBaseInfoDelagate postBaseInfoNextStep:VV_SHDAT.orderInfo.applyStatusCode];
                }
            
        }else{
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
        }
        

    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];

    }];
   
}

//   基本信息  点击打卡工资
- (void)clickWagesDetails:(UIButton *)sender{

}

//   基本信息  公积金社保  是否居住城市switch
-(void)switchFlipped:(VVCustomSwitchBtn*)switchView
{
    [self endEditing:YES];
    switchView.on = !switchView.on;
//    VV_SHDAT.creditBaseInfoModel.payFundSocial = [NSString stringWithFormat:@"%d",switchView.on];
    
}

- (void)didFinishPickViewWithTextField:(UITextField *)myTextField text:(NSString *)text row:(NSInteger)row{
    if (myTextField == _educatedField) {
        _educatedField.text = text;
        VV_SHDAT.creditBaseInfoModel.education = _educatedField.text;
        [self showBaseInfoBtnStatues];

    }else if (myTextField == _loanuseField){
        _loanuseField.text = text;
        VV_SHDAT.creditBaseInfoModel.loansUse = _loanuseField.text;
        [self showBaseInfoBtnStatues];
        
    }else if (myTextField == _basicInfoMaritalStatusField) {
        _basicInfoMaritalStatusField.text = text;
        VV_SHDAT.creditBaseInfoModel.marriage = _basicInfoMaritalStatusField.text;
        [self showBaseInfoBtnStatues];
        
    }else if (myTextField == _basicInfoIndustriesField) {
        _basicInfoIndustriesField.text = text;
        VV_SHDAT.creditBaseInfoModel.industry = _basicInfoIndustriesField.text;
        [self showBaseInfoBtnStatues];
        
    }else if (myTextField == _basicInfoJobField) {
        _basicInfoJobField.text = text;
        VV_SHDAT.creditBaseInfoModel.profession = _basicInfoJobField.text;
        [self showBaseInfoBtnStatues];
    }
}

#pragma mark  下一步  btn显示状态
- (void)showBaseInfoBtnStatues{
    VVLog(@"**************************%d,===%@",VV_IS_NIL(_basicInfoAftertaxSalaryField.text),_basicInfoAftertaxSalaryField.text);
    if (!VV_IS_NIL(_educatedField.text)&&
        !VV_IS_NIL(_basicInfoMaritalStatusField.text)&&
        !VV_IS_NIL(_basicInfoIndustriesField.text)&&
        !VV_IS_NIL(_basicInfoJobField.text)&&
        !VV_IS_NIL(_basicstoreIdField.text)&&
        !VV_IS_NIL(_loanuseField.text)&&
        (!VV_IS_NIL(_basicInfoAftertaxSalaryField.text)||
         !VV_IS_NIL(_basicInfoCashSalaryField.text))) {
        [_nextBtn setUserInteractionEnabled:YES];
        _nextBtn.selected = YES;
    }else{
        [_nextBtn setUserInteractionEnabled:NO];
        _nextBtn.selected = NO;
    }
    
}

//请求基础数据
- (void)getBasicDicSuccess:(void (^)(id result))success{
    
    NSString *plistPath = [VVPathUtils basicPlistPath];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]getCommonDictionariesSuccess:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            NSDictionary *dataDic = [result safeObjectForKey:@"data"];
            [fileMgr removeItemAtPath:plistPath error:nil];
            [dataDic writeToFile:plistPath atomically:YES];
            if (success) {
                success(dataDic);
            }
        }

    } failure:^(NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf.controller hideHud];
    }];
    
}



#pragma mark textfield delegate

- (void)hiddenKeyboard
{
    [self endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField != _basicInfoCashSalaryField) {
        [_basicInfoCashSalaryField resignFirstResponder];
    }
    if (textField == _educatedField) {
//        if (textField.canBecomeFirstResponder == NO) {
            [self endEditing:YES];
            [self getBasicDicWithTypeName:@"education" textField:_educatedField];
//        }
        return NO;
        
    }else if (textField == _loanuseField){
        [self endEditing:YES];
        [self getBasicDicWithTypeName:@"loansUse" textField:_loanuseField];
        return NO;
    
    }else if (textField == _basicInfoMaritalStatusField){
//       if (textField.canBecomeFirstResponder == NO) {
           [self endEditing:YES];
           [self getBasicDicWithTypeName:@"marriage" textField:_basicInfoMaritalStatusField];
           
//       }
        return NO;
    }else if (textField == _basicInfoCashSalaryField||_basicInfoAftertaxSalaryField == textField){
//        if (textField.canBecomeFirstResponder == NO) {
            [self endEditing:YES];
            [self showBaseInfoBtnStatues];
            
//        }
    }else if (textField == _basicstoreIdField){
//        if (textField.canBecomeFirstResponder == NO) {
            [self endEditing:YES];
            
//            if (VV_IS_NIL(VV_SHDAT.orderInfo.liveCityName) && [VV_SHDAT.orderInfo.applyStatusCode integerValue] == applyTypeBase) {
            if (VV_IS_NIL(VV_SHDAT.orderInfo.liveCityName) ){
                __weak __typeof(self)weakSelf = self;

                [VVAlertUtils showAlertViewWithMessage:@"请如实选择工作所有在城市，信息一经修改确认将无法修改" cancelButtonTitle:@"确定" tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                    VVSearchCityViewController *searchCityVc = [[VVSearchCityViewController alloc]init];
                    searchCityVc.loanViewController = strongSelf.controller;
                    searchCityVc.selectedRowInfo = ^(NSString*rowInfo , NSString *cityCode ,id result){
//                        _modelInfo.city = rowInfo;
//                        _modelInfo.cityCode = cityCode;
                        
                        VV_SHDAT.creditBaseInfoModel.liveCityName = rowInfo;
                        VV_SHDAT.creditBaseInfoModel.liveCity = cityCode;
                        
                        strongSelf.basicstoreIdField.text = rowInfo;
//                        _modelInfo.storeName = rowInfo;
                        [strongSelf showBaseInfoBtnStatues];//button状态
                    };
                    [strongSelf.controller customPushViewController:searchCityVc withType:nil subType:nil];
                }];

//            }
        }
        
        return NO;

    }else if (textField == _basicInfoIndustriesField){
//           if (textField.canBecomeFirstResponder == NO) {
               [self endEditing:YES];
               [self getBasicDicWithTypeName:@"industryType" textField:_basicInfoIndustriesField];
//           }
        return NO;

    }else if (textField == _basicInfoJobField){
//        if (textField.canBecomeFirstResponder == NO) {
            [self endEditing:YES];
            [self getBasicDicWithTypeName:@"customerType" textField:_basicInfoJobField];

//        }
        return NO;
    }
    
    return YES;
}

- (void)getBasicDicWithTypeName:(NSString *)typeName textField:(VVCommonTextField *)textField
{
    textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    NSDictionary *basicDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    if (basicDic.count==0) {
        __weak __typeof(self)weakSelf = self;
        [self getBasicDicSuccess:^(id result) {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSDictionary *basicDic = (NSDictionary *)result;
            NSArray * arr = basicDic[typeName];
            [strongSelf showPickView:arr textField:textField];
        }];
    }else{
        NSArray *arr = basicDic[typeName];
        [self showPickView:arr textField:textField];
    }
    
//    //每次拉取，实际情况中用户很少进入该界面
//    [self getBasicDicSuccess:^(id result) {
//        NSDictionary *basicDic = (NSDictionary *)result;
//        NSArray * arr = basicDic[typeName];
//        [self showPickView:arr textField:textField];
//    }];
}

- (void)showPickView:(NSArray *)arr textField:(VVCommonTextField *)textField{
    [self endEditing:YES];
    NSMutableArray *showEduArr = [NSMutableArray arrayWithCapacity:1];
    __weak __typeof(self)weakSelf = self;
    [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        weakSelf.basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj];
        [showEduArr addObject:weakSelf.basicModel.dicName];
    }];
    if (_vvPickerView != nil) {
        _vvPickerView = nil;
    }
    _vvPickerView = [[VVPickerView alloc]initWithFrame:_controller.view.bounds];
    _vvPickerView.showDataArr = showEduArr;
    _vvPickerView.myTextField = textField;
    _vvPickerView.title = textField.placeholder;
    _vvPickerView.delegate = self;
    [_controller.view addSubview:_vvPickerView];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self endEditing:YES];
//    return YES;
//}
//
- (void)textFieldDidChangeNotification:(NSNotification *)notification
{
    [self showBaseInfoBtnStatues];
  
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //允许删除字符输出
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (_basicInfoAftertaxSalaryField == textField||_basicInfoCashSalaryField == textField) {

        NSString * aftertaxSalary ;
        NSString * cashSalary ;

        if (_basicInfoAftertaxSalaryField == textField) {
            aftertaxSalary = [_basicInfoAftertaxSalaryField.text stringByAppendingString:string];
            if ([aftertaxSalary integerValue]>0&&VV_IS_NIL(_basicInfoCashSalaryField.text)) {
                _basicInfoCashSalaryField.text = @"0";
            }
           
            cashSalary = _basicInfoCashSalaryField.text;
            NSString *firstStr = [aftertaxSalary substringToIndex:1];
            if ([firstStr integerValue] == 0&&aftertaxSalary.length>=2) {
                return NO;
            }
        }
        
        if (_basicInfoCashSalaryField == textField) {
            cashSalary = [_basicInfoCashSalaryField.text stringByAppendingString:string];
            if ([cashSalary integerValue]>0&&VV_IS_NIL(_basicInfoAftertaxSalaryField.text)) {
                _basicInfoAftertaxSalaryField.text = @"0";
            }
            
            aftertaxSalary = _basicInfoAftertaxSalaryField.text;
            NSString *firstStr = [cashSalary substringToIndex:1];
            if ([firstStr integerValue] == 0&&cashSalary.length>=2) {
                return NO;
            }
        }
        
        NSString *salary = [NSString stringWithFormat:@"%ld",[aftertaxSalary integerValue]+[cashSalary integerValue]];

        if (salary.length<=6&&[salary integerValue]<=100000)
        {
            if (VV_REGEXP(string, kAllCharacterIsNumber))
            {
                return YES;
            }else{
                return NO;
            }
        }else {
            
            [VLToast showWithText:@"最多为10万"];
            if (_basicInfoAftertaxSalaryField == textField) {
                textField.text = [NSString stringWithFormat:@"%ld",100000-[cashSalary integerValue]];
            }
            if (_basicInfoCashSalaryField == textField) {
                textField.text = [NSString stringWithFormat:@"%ld",100000-[aftertaxSalary integerValue]];
            }
            
            return NO;
        }


    }
    return YES;
}


-(void)refreshCustomerOrderDetals:(void (^)( BOOL succ))success{
    UserModel *userModel = [UserModel currentUser];
    VVLog(@"用户id：%@",userModel.customerId);
    
    [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:userModel.customerId success:^(id result) {
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            VVOrderInfoModel *orderInfo = nil;
            NSDictionary *resultData = [result safeObjectForKey:@"data"];
            
            orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.orderInfo = orderInfo;
            
            VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.creditBaseInfoModel = baseInfoModel;
            
            JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.authenticationModel = authenticationModel;
            if (success) {
                success(YES);
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
