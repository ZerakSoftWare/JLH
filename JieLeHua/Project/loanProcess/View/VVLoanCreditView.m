//
//  VVLoanCreditView.m
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVLoanCreditView.h"
#import "VVCommonTextField.h"
#import "UIImage+GIF.h"
#import "VVWebAppViewController.h"
#import "VVFourthElementModel.h"
#import "VVVcreditSignWebViewController.h"
#import "VVPickerView.h"
#import "VVAVCaptureSessionViewController.h"
#import "IQUIView+Hierarchy.h"
#import "VVCustomSwitchBtn.h"
#import "JJFourElementbankRequest.h"
#import "JJAddBankCardRequest.h"
#import <FMDeviceManagerFramework/FMDeviceManager.h>
#import "JJTongdunRequest.h"
@interface VVLoanCreditView ()<UITextFieldDelegate,VVPickerViewDelegate,VVAVCaptureSessionViewControllerDelegate>{
    UIView *_baseScrollView;//用来切换界面的 view
    NSMutableArray *_allTxtFieldArr;
    UIImageView *_obImageView;
    NSString *_signBase64;
    
    //四要素
    VVCommonTextField * _bankCardTypeField;//银行卡类型(储蓄卡卡号)
    VVCommonTextField * _bankCardNameField;//银行名称
    VVCommonTextField * _bankCardMobileField; //预留手机号
    VVCommonTextField * _bankCardNumField; //尾号XXX为银行预留手机号
    VVCommonTextField * _bankCardMobileSMSField; //短信验证码
    VVCommonTextField * _isWithdrawOrRepaymentField;//默认设为提现、还款银行卡
    VVCommonTextField * _creditSignField;//签字

    UIButton * _changeBankNameBtn;
    int           _currentTime;
    NSTimer     * _timer;
    
    NSString * _faceCompareScore;//手持身份证 验证分数
    VVFourthElementModel * _fourthElementModel;//四要素
    NSString * _bankIDHandImageBase64;
    UIImageView *_handIdImageView;
    UILabel * _handLabel;//反面
    UIButton * _scanBankCard;
    VVPickerView * _vvPickerView;
    NSArray * _bankCardArr;//银行卡
    
    NSString *_signName;
    NSString *_seletedBtnName;
    UILabel *_showMessageLab;
    BOOL  _ispesonalImageBase64;
    NSString *_pesonalImageBase64;
    
    UILabel *_tipLab;
    NSString *_mobileBillId;
    NSString *_changeMobileNum;
}

@property (nonatomic, strong)   VVCustomSwitchBtn *customSwitch;
@property (nonatomic, strong)   VVCustomSwitchBtn *isWithdrawOrRepaymentFieldSwitch;
@property (nonatomic, strong)  NSMutableDictionary *infodic;
@property (nonatomic, strong) UIImageView *personSignImageView;
@property (nonatomic, copy) NSArray *cardArray;
@property (nonatomic, copy)NSMutableArray *dicTypeCodeArr;
@property(nonatomic,assign) BOOL isWithdrawOrRepaymentBankCard;
@property(nonatomic,strong) NSString * dicCode;
@property(nonatomic,strong) VVCommonButton * getSMSCodeBtn;
@end


@implementation VVLoanCreditView


-(VVCommonButton*)getSMSCodeBtn{
    if (_getSMSCodeBtn == nil) {
        _getSMSCodeBtn = [VVCommonButton getSMSCodeButton];
        [_getSMSCodeBtn addTarget:self  action:@selector(getSMSCode:) forControlEvents:UIControlEventTouchUpInside];
        _getSMSCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _getSMSCodeBtn;
}


- (NSMutableDictionary *)infodic
{
    if (!_infodic) {
        _infodic = [[NSMutableDictionary alloc] init];
    }
    return _infodic;
}

- (VVCustomSwitchBtn *)isWithdrawOrRepaymentFieldSwitch
{
    if (!_isWithdrawOrRepaymentFieldSwitch) {
        UIImage *offImage = VV_GETIMG(@"btn_no");
        UIImage *onImage = VV_GETIMG(@"btn_yes");
        _isWithdrawOrRepaymentFieldSwitch = [VVCustomSwitchBtn switchButton];
        [_isWithdrawOrRepaymentFieldSwitch switchButton:onImage offImage:offImage];
        [_isWithdrawOrRepaymentFieldSwitch addTarget:self action:@selector(isWithdrawOrRepaymentFieldSwitchClick:) forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];
        _isWithdrawOrRepaymentFieldSwitch.tag = 400;
        _isWithdrawOrRepaymentFieldSwitch.on = YES;
    }
    return _isWithdrawOrRepaymentFieldSwitch;
}

- (VVCustomSwitchBtn *)customSwitch
{
    
    if (!_customSwitch) {
        UIImage *offImage = VV_GETIMG(@"btn_no");
        UIImage *onImage = VV_GETIMG(@"btn_yes");
        _customSwitch = [VVCustomSwitchBtn switchButton];
        [_customSwitch switchButton:onImage offImage:offImage];
        [_customSwitch addTarget:self action:@selector(switchFlipped:) forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];
        _customSwitch.tag = 200;
        _customSwitch.on = YES;
    }

    return _customSwitch;
}

- (UIImageView *)personSignImageView{
    if (!_personSignImageView) {
        _personSignImageView = [[UIImageView alloc] init];
        _personSignImageView.backgroundColor = VVWhiteColor;
    }
    return _personSignImageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [VV_NC addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
        [VV_NC addObserver:self selector:@selector(observerMobieNumHasChange:) name: JJMobieHasChange object:nil];
        _allTxtFieldArr = [NSMutableArray arrayWithCapacity:1];
        self.backgroundColor = VVWhiteColor;
        _ispesonalImageBase64 = NO;
        //打开定时器
        [_timer setFireDate:[NSDate distantPast]];
        _seletedBtnName = @"借记卡";   //进来的时候先给 借记卡 标识
    }
    return self;
}
- (void)dealloc{
    [VV_NC removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [VV_NC removeObserver:self name:JJMobieHasChange object:nil];

}
#pragma mark subView

- (void)setupscrollView{
    _baseScrollView = [[UIView alloc] initWithFrame:CGRectZero];
    _baseScrollView.backgroundColor = [UIColor whiteColor];
    _baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self addSubview: _baseScrollView];
}


#pragma mark 机构版征信
- (void)jigoubanVcreditViewIsShowSMS:(BOOL)showSMS andIsShowWithdrawOrRepayment:(BOOL)showWithdrawOrRepayment{
    
    [_allTxtFieldArr removeAllObjects];
    NSArray * textFieldArr = [NSArray array];
    textFieldArr =  @[
                      @{@"left":@"手机号码",@"placeholder":@"请输入银行预留手机号",@"right":@"",@"enabled":@"NO",@"type":@"mobileNum"},
                      @{@"left":@"       ",@"placeholder":@"",@"right":@"scan",@"enabled":@"YES",@"type":@"bankCardNum"},
                      @{@"left":@"电子签名",@"placeholder":@"点此签名",@"right":@"arrow",@"enabled":@"YES",@"type":@"signName"}
                      ];
    NSMutableArray *mutableArr = [textFieldArr mutableCopy];
    if (_changeBankNameBtn.isSelected) {
        NSDictionary *bankcardName = @{@"left":@"银行名称",@"placeholder":@"",@"right":@"",@"enabled":@"NO",@"type":@"bankCardName"};
        [mutableArr insertObject:bankcardName atIndex:0];
        NSDictionary *bankCardType =  @{@"left":@"信用卡卡号",@"placeholder":@"请输入您的信用卡卡号",@"right":@"",@"enabled":@"YES",@"type":@"bankCardType"};
        [mutableArr insertObject:bankCardType atIndex:0];
      
    }else{
        NSDictionary *bankCardType =  @{@"left":@"储蓄卡卡号",@"placeholder":@"请输入您的储蓄卡卡号",@"right":@"",@"enabled":@"YES",@"type":@"bankCardType"};
        [mutableArr insertObject:bankCardType atIndex:0];
        NSDictionary *bankcardName = @{@"left":@"银行名称",@"placeholder":@"",@"right":@"arrow",@"enabled":@"NO",@"type":@"bankCardName"};
        [mutableArr insertObject:bankcardName atIndex:0];
        if (showWithdrawOrRepayment) {
            NSDictionary *isWithdrawOrRepayment =  @{@"left":@"       ",@"placeholder":@"",@"right":@"scan",@"enabled":@"YES",@"type":@"isWithdrawOrRepayment"};
            [mutableArr insertObject:isWithdrawOrRepayment atIndex:mutableArr.count -1];
        }
        
    }
    if (!showSMS) {
        NSDictionary *bankMobileSMSDic = @{@"left":@"短信验证码",@"placeholder":@"请输入验证码",@"right":@"sendSmsMobileCode",@"enabled":@"YES",@"type":@"mobileSMSCode"};
        [mutableArr insertObject:bankMobileSMSDic atIndex:(textFieldArr.count +1)] ;
    }
    textFieldArr = [mutableArr copy];
    
    [_baseScrollView removeFromSuperview];
    [self setupscrollView];
    CGFloat topHeight = 0;

    __block CGFloat rectHeight;
    [textFieldArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVCommonTextField *textfield = [[VVCommonTextField alloc]initWithFrame:CGRectMake(ktextFieldLeft,  topHeight+ idx*44, kScreenWidth-ktextFieldLeft, ktextFieldheight)];
        textfield.delegate = self;
        textfield.placeholder = obj[@"placeholder"];
        textfield.leftText = obj[@"left"];
        NSString *type = obj[@"type"];
        NSString *enabled = obj[@"enabled"];
        NSString *right = obj[@"right"];
        [_baseScrollView addSubview:textfield];
        [_allTxtFieldArr addObject:textfield];
       
        if ([type isEqualToString:@"bankCardName"] && [_seletedBtnName isEqualToString:@"借记卡"] ){
            textfield.enabled = YES;
            textfield.text = [self.infodic safeObjectForKey:type];
        }else{
            textfield.enabled = [enabled boolValue];
        }
     
        if (![type isEqualToString:@"signName"])
        {
            NSString *text = [self.infodic safeObjectForKey:type];
            textfield.text = text;
        }

        if ([type isEqualToString:@"bankCardType"]) {
            _bankCardTypeField = textfield;
            _bankCardTypeField.keyboardType = UIKeyboardTypeNumberPad;
        }else if ([type isEqualToString:@"bankCardName"]){
            _bankCardNameField= textfield;
            
            
        }else if ([type isEqualToString:@"bankCardNum"]){
            textfield.frame =   CGRectMake(ktextFieldLeft,topHeight+ idx*44, kScreenWidth-ktextFieldLeft*2 , 46);
            _bankCardNumField = textfield;
            _bankCardNumField.userInteractionEnabled = NO;
            _bankCardNumField.text = @".";
            _bankCardNumField.textColor = [UIColor clearColor];
            UILabel *showMessageLab = [[UILabel alloc]init];
            showMessageLab.backgroundColor = [UIColor whiteColor];
            showMessageLab.frame =  CGRectMake(20, topHeight+ 2+ idx*44 +0, 200, 42);
            showMessageLab.font = [UIFont systemFontOfSize:15.f];
            [_baseScrollView addSubview:showMessageLab];
            _showMessageLab = showMessageLab;
            float k;
            if(ISIPHONE6Plus){
                k =1.476;
            }else{
                k = 1.00;
            }
            UIImage *onImage = VV_GETIMG(@"btn_yes");
            self.customSwitch.frame =  CGRectMake(kScreenWidth-onImage.size.width*k-ktextFieldLeft, topHeight+ idx*44 +(ktextFieldheight-onImage.size.height*k)/2, onImage.size.width*k, onImage.size.height*k);
            [_baseScrollView addSubview:self.customSwitch];
         
        }else if ([type isEqualToString:@"mobileNum"]){
            _bankCardMobileField= textfield;
            _bankCardMobileField.maxlength = 11;
            _bankCardMobileField.keyboardType = UIKeyboardTypeNumberPad;
            _bankCardMobileField.enabled = NO;

        }else if ([type isEqualToString:@"mobileSMSCode"]){
            textfield.userInteractionEnabled = YES;
            textfield.frame =   CGRectMake(ktextFieldLeft,topHeight+ idx*44, kScreenWidth-ktextFieldLeft*2-75 , ktextFieldheight);
            _bankCardMobileSMSField = textfield;
            _bankCardMobileSMSField.maxlength = MobSMSLength;
            _bankCardMobileSMSField.keyboardType = UIKeyboardTypeASCIICapable;
            [_bankCardMobileSMSField setAutocorrectionType:UITextAutocorrectionTypeNo];
            
            
            self.getSMSCodeBtn.frame = CGRectMake(kScreenWidth-95 -3 , idx*44, 80, 34);
            self.getSMSCodeBtn.centerY = textfield.centerY;
            [_baseScrollView addSubview:self.getSMSCodeBtn];

        }else if ([type isEqualToString:@"isWithdrawOrRepayment"]){
            textfield.frame =   CGRectMake(ktextFieldLeft,topHeight+ idx*44, kScreenWidth-ktextFieldLeft*2 , 46);
            _isWithdrawOrRepaymentField = textfield;
            _isWithdrawOrRepaymentField.userInteractionEnabled = NO;
            _isWithdrawOrRepaymentField.text = @".";
            _isWithdrawOrRepaymentField.textColor = [UIColor clearColor];
            UILabel *showMsgLab = [[UILabel alloc]init];
            showMsgLab.backgroundColor = [UIColor whiteColor];
            showMsgLab.text = @"默认设为提现、还款银行卡";
            showMsgLab.frame =  CGRectMake(20, topHeight+ 2+ idx*44 +0, 200, 42);
            showMsgLab.font = [UIFont systemFontOfSize:15.f];
            [_baseScrollView addSubview:showMsgLab];
            
            UIImage *onImage = VV_GETIMG(@"btn_yes");
            float k;
            if(ISIPHONE6Plus){
                k =1.476;
            }else{
                k = 1.00;
            }
             self.isWithdrawOrRepaymentFieldSwitch.frame =  CGRectMake(kScreenWidth-onImage.size.width*k-ktextFieldLeft, topHeight+ idx*44 +(ktextFieldheight-onImage.size.height*k)/2, onImage.size.width*k, onImage.size.height*k);
            [_baseScrollView addSubview:self.isWithdrawOrRepaymentFieldSwitch];
            
        }else if ([type isEqualToString:@"signName"]){
            _creditSignField= textfield;
            if ([self.infodic safeObjectForKey:@"signName"])
            {
                UIImage *pesonalImage = [self.infodic safeObjectForKey:@"signName"];
                self.personSignImageView.image = pesonalImage;
                CGFloat personalImageWight = (pesonalImage.size.width/pesonalImage.size.height)*(_creditSignField.height-10);
                self.personSignImageView.frame = CGRectMake(_creditSignField.width/2-personalImageWight/2 - 30, 5, personalImageWight , _creditSignField.height-10);
                [_creditSignField addSubview:self.personSignImageView];
            }
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
    
    UIButton * changeBankNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBankNameBtn.frame = CGRectMake(0.5*(kScreenWidth-200), rectHeight+15, 200, 44);
    changeBankNameBtn.backgroundColor = VVclearColor;
    [changeBankNameBtn setTitle:@"没有储蓄卡？请点击验证" forState:UIControlStateNormal];
    [changeBankNameBtn setTitle:@"如果您没有信用卡，请点击" forState: UIControlStateSelected];
    [changeBankNameBtn setTitleColor:[UIColor globalThemeColor] forState:UIControlStateSelected];
    [changeBankNameBtn setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    changeBankNameBtn.titleLabel.font  = [UIFont systemFontOfSize:14.0];
    [changeBankNameBtn addTarget:self action:@selector(changeBankTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    changeBankNameBtn.selected = NO;
    changeBankNameBtn.hidden = NO;
    _changeBankNameBtn = changeBankNameBtn;
    
    if ([_seletedBtnName isEqualToString:@"贷记卡"]) {
        changeBankNameBtn.selected = YES;
    }else{
        changeBankNameBtn.selected = NO;
    }
    
    VVLog(@"初始的_seletedBtnName%@",_seletedBtnName);

    [_baseScrollView addSubview:changeBankNameBtn];
    _bankCardMobileField.text = VV_SHDAT.orderInfo.mobile;  //预填手机号
    _showMessageLab.text = [NSString stringWithFormat:@"尾号%@为银行预留手机号",[VVCommonFunc getBankNumberForLast4:VV_SHDAT.orderInfo.mobile]];
    _bankCardNumField.font = [UIFont systemFontOfSize:12];
    
    _nextBtn = [VVCommonButton solidButtonWithTitle:@"提交"];
    _nextBtn.frame = CGRectMake(VVleftMargin, changeBankNameBtn.bottom+55, kScreenWidth-VVleftMargin*2, VVBtnHeight);
    [_nextBtn addTarget:self action:@selector(submitTongdunAction:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:_nextBtn];
    [_nextBtn setUserInteractionEnabled:NO];
    
    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.font = [UIFont systemFontOfSize:14.f];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = [UIColor redColor];
    tipLab.numberOfLines = 0;
    tipLab.text = @"＊银行卡身份验证是获取中国人民银行个人征信的必要授权步骤，请您如实填写";
    [_baseScrollView addSubview:tipLab];
    _tipLab = tipLab;
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_nextBtn.mas_top).offset(-20);
        make.left.mas_equalTo(_baseScrollView.mas_left).offset(20);
        make.right.mas_equalTo(_baseScrollView.mas_right).offset(-20);
    }];

    
    _baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, _nextBtn.bottom+10);
    self.height = _baseScrollView.height;
    _controller.scrollView.contentSize = CGSizeMake(vScreenWidth, self.bottom);
    
    _bankCardMobileField.text = VV_SHDAT.orderInfo.mobile;
    
    if (_customSwitch.on) {
        _bankCardMobileField.text = VV_SHDAT.orderInfo.mobile;
        _bankCardMobileField.enabled = NO;
    }else{
        _bankCardMobileField.text = _changeMobileNum;
    }
    
    [self showCreditBtnStatues];
}

-(void)isWithdrawOrRepaymentFieldSwitchClick:(VVCustomSwitchBtn*)customSwitch{
    [self endEditing:YES];
    customSwitch.on = !customSwitch.on;
    
    if (customSwitch.on) {
        _isWithdrawOrRepaymentBankCard = YES;
    }else{
        _isWithdrawOrRepaymentBankCard = NO;
    }
    VVLog(@"isWithdrawOrRepaymentFieldSwitchClick我是开关啊%d_isWithdrawOrRepaymentBankCard%d",customSwitch.on,_isWithdrawOrRepaymentBankCard);
}

-(void)switchFlipped:(VVCustomSwitchBtn*)switchView
{
    [self endEditing:YES];
    switchView.on = !switchView.on;
    VVLog(@"我是开关啊%d",switchView.on);
    
    if (switchView.on) {
        [self jigoubanVcreditViewIsShowSMS:NO andIsShowWithdrawOrRepayment:NO];
        _bankCardMobileField.text = VV_SHDAT.orderInfo.mobile;

    }else{
        
        [VVAlertUtils showAlertViewWithTitle:@"" message:@"为了让您申请到更高的授信金额，请验证您的银行预留手机号" customView:nil cancelButtonTitle:@"不去验证" otherButtonTitles:@[@"立即验证"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex  != kCancelButtonTag) {
                [alertView hideAlertViewAnimated:YES];
                if ([_loanCreditDelagate respondsToSelector:@selector(pushMobileBillController)]) {
                    [_loanCreditDelagate pushMobileBillController];
                    [self jigoubanVcreditViewIsShowSMS:YES andIsShowWithdrawOrRepayment:NO];
                }

            }else if (buttonIndex  == kCancelButtonTag){
                _bankCardMobileField.text = VV_SHDAT.orderInfo.mobile;
                self.customSwitch.on = YES;
            }
        }];
        
    }
}
#pragma ------network--------

-(void)getbankCardName:(void (^)( BOOL succ))success{
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]getCommonBankNameWithBankCardNum:_bankCardTypeField.text Success:^(id result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            NSDictionary *dataDic = [result safeObjectForKey:@"data"];
            _bankCardNameField.text = dataDic[@"bankName"];
            [self.infodic setObject:dataDic[@"bankName"] forKey:@"bankCardName"];
            if (success) {
                success(YES);
            }
            
        }else{
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
            if (success) {
                success(NO);
            }
        }
        
    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];
        if (success) {
            success(NO);
        }
    }];

}


- (void)getBankCardList:(void (^)( BOOL succ))success
{
    JJFourElementbankRequest *request = [[JJFourElementbankRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]initWithShowView:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJFourElementBankCardModel *model = [(JJFourElementbankRequest *)request response];
        VVLog(@"%@",model.code);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.cardArray = model.data;
        if (model.success && strongSelf.cardArray.count != 0) {
            if (success) {
                success(YES);
            }
        }else{
            [MBProgressHUD bwm_showTitle:@"获取银行卡列表失败" toView:self.viewController.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD bwm_showTitle:@"获取银行卡列表失败" toView:self.viewController.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
    }];

}

- (void)submitTongdunAction:(id)sender
{
    //提交同盾信息
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    NSString *blackBox = manager->getDeviceInfo();
//    VVLog(@" : %@", blackBox);
//    NSUInteger characterLength = 0;
//    char *p = (char *)[blackBox cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (NSInteger i = 0, l = [blackBox lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i < l; i++) {
//        if (*p) {
//            characterLength++;
//        }
//        p++;
//    }
//    VVLog(@"%lu",(unsigned long)characterLength);
    [self uploadTongdun:blackBox];
}

-(void)postObtainingCreditLogin{
    __weak __typeof(self)weakSelf = self;
    if (_customSwitch.on) {

        if (_isWithdrawOrRepaymentBankCard &&  [_seletedBtnName isEqualToString:@"借记卡"]) {
            
            [self checkSMSCode:^(BOOL succ) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (succ) {
                    [strongSelf postRecordOrgSignImage:^(BOOL succ) {
                        if (succ) {
                            [strongSelf postOrdersVerificationBankcardParameter:^(BOOL succ) {
                                if (succ) {
                                    [self addRepayBankCard:^(BOOL succ) {
                                        if (succ) {
                                            if ([weakSelf.loanCreditDelagate respondsToSelector:@selector(enterHomeView)]) {
                                                [weakSelf.loanCreditDelagate enterHomeView];
                                            }
                                        }else{
                                            if ([weakSelf.loanCreditDelagate respondsToSelector:@selector(enterHomeView)]) {
                                                [weakSelf.loanCreditDelagate enterHomeView];
                                            }
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];

        }else{
            
            [self checkSMSCode:^(BOOL succ) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (succ) {
                    [strongSelf postRecordOrgSignImage:^(BOOL succ) {
                        if (succ) {
                            [strongSelf postOrdersVerificationBankcardParameter:^(BOOL succ) {
                                if (succ) {
                                    if ([weakSelf.loanCreditDelagate respondsToSelector:@selector(enterHomeView)]) {
                                        [weakSelf.loanCreditDelagate enterHomeView];
                                    }
                                }
                            }];
                        }
                    }];
                }
            }];
            
        }
        
    }else{

        if(VV_IS_NIL(_changeMobileNum)&&VV_IS_NIL(_mobileBillId)){
            [VLToast showWithText:@"更换手机号失败，请重新更换"];
            return;
        }
        
        if (_isWithdrawOrRepaymentBankCard &&  [_seletedBtnName isEqualToString:@"借记卡"]) {
                [self postjlhMobileBill:^(BOOL succ) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    if (succ) {
                        [strongSelf postRecordOrgSignImage:^(BOOL succ) {
                            if (succ) {
                                [strongSelf postOrdersVerificationBankcardParameter:^(BOOL succ) {
                                    if (succ) {
                                        [strongSelf addRepayBankCard:^(BOOL succ) {
                                            if (succ) {
                                                if ([weakSelf.loanCreditDelagate respondsToSelector:@selector(enterHomeView)]) {
                                                    [weakSelf.loanCreditDelagate enterHomeView];
                                                }
                                            }else{
                                                if ([weakSelf.loanCreditDelagate respondsToSelector:@selector(enterHomeView)]) {
                                                    [weakSelf.loanCreditDelagate enterHomeView];
                                                }
                                            }
                                        }];
                                    }
                                }];
                            }
                        }];
                    }
                }];
            
        }else{
            [self postjlhMobileBill:^(BOOL succ) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (succ) {
                    [strongSelf postRecordOrgSignImage:^(BOOL succ) {
                        if (succ) {
                            [strongSelf postOrdersVerificationBankcardParameter:^(BOOL succ) {
                                if (succ) {
                                    if ([weakSelf.loanCreditDelagate respondsToSelector:@selector(enterHomeView)]) {
                                        [weakSelf.loanCreditDelagate enterHomeView];
                                    }
                                }
                            }];
                        }
                    }];
                }
            }];
        }
        
    }
    
}

-(void)postjlhMobileBill:(void (^)( BOOL succ))success{

    NSDictionary *params = @{
                             @"customerId": [UserModel currentUser].customerId,
                             @"mobile":_changeMobileNum ,
                             @"mobileBillId": _mobileBillId
                             };

    [_controller showHud];
    __weak __typeof(self)weakSelf = self;

    [[VVNetWorkUtility netUtility] postUpdateMobileBillParameters:params success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            if (success) {
                success(YES);
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

-(void)postRecordOrgSignImage:(void (^)( BOOL succ))success{
    
    NSDictionary *params = @{
                            @"customerId": [UserModel currentUser].customerId,
                            @"imageBase64":@"" ,
                            @"signImageBase64": _pesonalImageBase64
                            };
    
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postRecordOrgSignImageParameters:params success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            if (success) {
                success(YES);
            }
        }else{
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
            if (success) {
                success(NO);
            }
        }
        
    } failure:^(NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];
        if (success) {
            success(NO);
        }
    }];
    
}

-(void)checkSMSCode:(void (^)( BOOL succ))success{

    NSDictionary *params = @{@"mobile":_bankCardMobileField.text,
                             @"smsCode":_bankCardMobileSMSField.text
                             };
    
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;

    [[VVNetWorkUtility netUtility]postCommonCheckSmsCode:params success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            if (success) {
                success(YES);
            }
        }else{
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
            if (success) {
                success(NO);
            }
        }
        
    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];

    }];
    
    
}

-(void)postOrdersVerificationBankcardParameter:(void (^)( BOOL succ))success{
    NSString *idcard ;
    if (VV_IS_NIL( VV_SHDAT.authenticationModel.idcardNo)) {
        if (VV_IS_NIL(VV_SHDAT.orderInfo.applicantIdcard)) {
            idcard = @"";
        }else{
            idcard = VV_SHDAT.orderInfo.applicantIdcard;
        }
    }else{
        idcard = VV_SHDAT.authenticationModel.idcardNo;
    }
    
    NSDictionary *par = @{
                          @"bankCardNo":_bankCardTypeField.text,
                          @"bankCardType":VV_IS_NIL(_seletedBtnName)?@"":_seletedBtnName,
                          @"bankName": VV_IS_NIL(_bankCardNameField.text)?@"":_bankCardNameField.text,
                          @"customerId": @([[UserModel currentUser].customerId integerValue]) ,
                          @"idcard":  idcard ,
                          @"mobile":VV_IS_NIL(_bankCardMobileField.text)?@"":_bankCardMobileField.text,
                          @"name": VV_IS_NIL(VV_SHDAT.orderInfo.applicantName)?@"":VV_SHDAT.orderInfo.applicantName
                          };
    
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]postOrdersVerificationBankcardParameters:par success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        if ([[result safeObjectForKey:@"success"] boolValue]) {
   
            if (_changeBankNameBtn.isSelected)
            {
                //信用卡
                [MobClick event:@"use_credit_card"];
            }
            else
            {
                //借记卡
                [MobClick event:@"use_debit_card"];
            }
            [MobClick event:@"submit_review"];
            
            if (success) {
                success(YES);
            }
           
        }else{
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
            if (success) {
                success(NO);
            }

        }
        
    } failure:^(NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];
        if (success) {
            success(NO);
        }

        
    }];
}


- (void)changeBankTypeBtn:(UIButton *)btn{
    VVLog(@"%d",btn.isSelected);
    btn.selected = !btn.selected;
    if (btn.selected) {
        _seletedBtnName = @"贷记卡";
        _isWithdrawOrRepaymentBankCard = YES;
    }else{
        _seletedBtnName = @"借记卡";
    }
    VVLog(@"changeBankTypeBtn：_seletedBtnName%@",_seletedBtnName);
   
    [self jigoubanVcreditViewIsShowSMS: !_customSwitch.on andIsShowWithdrawOrRepayment:NO];
    [self resetReveciveSMSCode];
    _bankCardTypeField.text = @"";
    _bankCardNameField.text = @"";
    [self.infodic setObject:@"" forKey:@"bankCardName"];
    [self.infodic setObject:@"" forKey:@"bankCardType"];
    [self showCreditBtnStatues];
}

- (void)showCreditBtnStatues{
    
    if (_ispesonalImageBase64) {
        _creditSignField.text = @"已签名";
        _creditSignField.textColor = [UIColor clearColor];
    }else{
        _creditSignField.text = @"";
    }

     BOOL isEmpty = NO;
    
    for (VVCommonTextField *textfield in _allTxtFieldArr) {
        if (VV_IS_NIL(textfield.text)) {
            isEmpty = YES;
        }
    }
    
    if (!isEmpty && _ispesonalImageBase64) {
        [_nextBtn setUserInteractionEnabled:YES];
        _nextBtn.selected = YES;

    }else{
        [_nextBtn setUserInteractionEnabled:NO];
        _nextBtn.selected = NO;
    }


}

#pragma mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSString *name ;
    if(VV_IS_NIL(VV_SHDAT.authenticationModel.name)){
        if (VV_IS_NIL(VV_SHDAT.orderInfo.applicantName)) {
            [VLToast showWithText:@"网络签名出错，请重新再试"];
            return NO;
        }else{
            name = VV_SHDAT.orderInfo.applicantName;
        }
    }else{
        name = VV_SHDAT.authenticationModel.name;
    }
    
    NSString *idcard;
    if(VV_IS_NIL(VV_SHDAT.authenticationModel.idcardNo)){
        if (VV_IS_NIL(VV_SHDAT.orderInfo.applicantIdcard)) {
            [VLToast showWithText:@"网络签名出错，请重新再试"];
            return NO;
        }else{
            idcard = VV_SHDAT.orderInfo.applicantIdcard;
        }
    }else{
        idcard = VV_SHDAT.authenticationModel.idcardNo;
    }
    
     if (textField == _creditSignField){
         
//         if (textField.canBecomeFirstResponder == NO){
         
                [self endEditing:YES];
                VVVcreditSignWebViewController *credictVc = [[VVVcreditSignWebViewController alloc]init];
                credictVc.webTitle = @"电子签名";
                NSString *url = [WEB_BASE_URL stringByAppendingString:@"/sign.html"];
                NSString *urlStarPage = [NSString stringWithFormat:@"%@?name=%@&idcard=%@&customerId=%@&token=%@",url,name,idcard,[UserModel currentUser].customerId,[UserModel currentUser].token];
                 urlStarPage = [urlStarPage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                 credictVc.startPage = urlStarPage;
             __weak __typeof(self)weakSelf = self;
                credictVc.signSuccBlock = ^(NSString *pesonalImageBase64){
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    _pesonalImageBase64 = pesonalImageBase64;
                    if (VV_IS_NIL(pesonalImageBase64)) {
                        _ispesonalImageBase64 = NO;
                    }else{
                        _ispesonalImageBase64 = YES;
                    }
                    
                        UIImage *pesonalImage = [UIImage imageWithData:[NSData base64DataFromString:pesonalImageBase64]];
                        self.personSignImageView.image = pesonalImage;
                        CGFloat personalImageWight = (pesonalImage.size.width/pesonalImage.size.height)*(textField.height-10);
                        self.personSignImageView.frame = CGRectMake(textField.width/2-personalImageWight/2 - 30, 5, personalImageWight , textField.height-10);
                        [textField addSubview:self.personSignImageView];
                        textField.placeholder = @"";
                    
                    [self.infodic setObject:pesonalImage forKey:@"signName"];
                    
                        [strongSelf textFieldDidChangeNotification:nil];
                    
                };
                [self.controller customPushViewController:credictVc withType:nil subType:nil];
//         }
         
        return NO;
    }
    
    if (textField == _bankCardNameField) {
//        if (textField.canBecomeFirstResponder == NO) {
            [self endEditing:YES];
            
            __weak __typeof(self)weakSelf = self;
            [self getBankCardList:^(BOOL succ) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (succ) {
                    NSMutableArray *titleArray = [NSMutableArray array];
                    NSMutableArray *dicTypeCodeArr = [NSMutableArray array];
                    for (int i = 0; i<strongSelf.cardArray.count; i++) {
                        NSString *bankName = [[strongSelf.cardArray objectAtIndex:i] dicName];
                        [titleArray addObject:bankName];
                        if ([[[strongSelf.cardArray objectAtIndex:i] dicTypeCode] integerValue] == 2) {
                            [dicTypeCodeArr addObject:[NSNumber numberWithInt:i]];
                        }
                    }
                    if (!(titleArray.count > 0)) {
                        [VLToast showWithText:@"未加载到银行卡列表"];
                        return ;
                    }
                    
                    strongSelf.dicTypeCodeArr = dicTypeCodeArr;
                    textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
                    _vvPickerView = [[VVPickerView alloc]initWithFrame:_controller.view.bounds];
                    _vvPickerView.showDataArr = titleArray;
                    _vvPickerView.myTextField = textField;
                    _vvPickerView.delegate = self;
                    [_controller.view addSubview:_vvPickerView];
                }
            }];
//        }
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textField == _bankCardTypeField) {
        if (![_seletedBtnName isEqualToString:@"借记卡"]) {
            if (VV_IS_NIL(_bankCardTypeField.text)) {
                [VLToast showWithText:@"银行卡号不能为空"];
                _bankCardNameField.text = @"";
                return;
            }
            
            if ([VVCommonFunc checkCardNo:_bankCardTypeField.text]) {
                [self getbankCardName:^(BOOL succ) {
                    
                }];
            }else{
                [VLToast showWithText:@"请输入有效银行卡号"];
            }
        }
    }
    
    if ([textField isKindOfClass:[_bankCardTypeField class]]) {
        [self.infodic setObject:_bankCardTypeField.text forKey:@"bankCardType"];
    }
   
    if ([textField isKindOfClass:[_bankCardMobileField class]]) {
        [self.infodic setObject:_bankCardMobileField.text forKey:@"mobileNum"];
    }

//    if ([textField isKindOfClass:[_bankCardMobileSMSField class]]) {
//        [self.infodic setObject:_bankCardMobileSMSField.text forKey:@"mobileSMSCode"];
//    }
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

- (void)textFieldDidChangeNotification:(NSNotification *)notification
{
    if (_bankCardNumField.text.length > 0) {
        _scanBankCard.hidden = YES;
        _bankCardNumField.clearButtonMode =  UITextFieldViewModeWhileEditing;
    }else{
        _scanBankCard.hidden = NO;
        _bankCardNumField.clearButtonMode =  UITextFieldViewModeNever;
    }
    
    if (_bankCardMobileField.text.length > 11) {
        _bankCardMobileField.text = [_bankCardMobileField.text substringToIndex:11];
    }
    
    [self showCreditBtnStatues];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //允许删除字符输出
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return YES;
}

- (void)hideKeyboard
{
    [self endEditing:YES];
}



- (void)showCreditSubView{
    [self jigoubanVcreditViewIsShowSMS:NO andIsShowWithdrawOrRepayment:NO];

}

- (void)getSMSCode:(UIButton *)sender{
    [self endEditing:YES];
    
    if ([self checkoutPhoneNum:_bankCardMobileField.text])
    {
        _getSMSCodeBtn.enabled = NO;
        _currentTime = 90;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        [_getSMSCodeBtn setBackgroundColor:[ UIColor  colorWithWholeRed:167 green:197 blue:242]  forState:UIControlStateDisabled];
        [self checkoutPhoneNum:_bankCardMobileField.text];
        [self getVerficationCode];
    }
    
}

-(void)countDown{
    
    [_getSMSCodeBtn setTitle:[NSString stringWithFormat:@"%ds",_currentTime] forState:UIControlStateNormal];
    [_getSMSCodeBtn setNeedsLayout];
    _currentTime --;
    if (_currentTime == -1) {
        [self resetReveciveSMSCode];
    }
}

-(void)resetReveciveSMSCode{
    [_getSMSCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_timer invalidate];
    _getSMSCodeBtn.enabled = YES;
    
}


- (void)resetGetSMSCodeButton
{
    [_getSMSCodeBtn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    [_getSMSCodeBtn setTitle:VV_STR(@"获取验证码") forState:UIControlStateNormal];
    _getSMSCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_getSMSCodeBtn setTitleColor:VVWhiteColor forState:UIControlStateNormal];
    _getSMSCodeBtn.layer.borderWidth = 0;
    _getSMSCodeBtn.layer.borderColor = VV_COL_RGB(0x999999).CGColor;
    [_timer invalidate];
    _getSMSCodeBtn.enabled = YES;
}

-(void)getVerficationCode{
    VVLog(@"[UserModel currentUser].token]%@",[UserModel currentUser].token );
    NSString *password = [VVCommonFunc md5:[NSString stringWithFormat:@"%@%@",@"JLHSSSXS_78__",[UserModel currentUser].token]];
    NSDictionary *parmas = @{@"mobile":VV_IS_NIL(_bankCardMobileField.text)?@"":_bankCardMobileField.text,
                             @"passWd":password
                             };
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postCommonVerificationMobile:parmas success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (![[result safeObjectForKey:@"success"] boolValue]) {
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
            [strongSelf resetGetSMSCodeButton];
        }else{
            [VLToast showWithText:@"验证码已发送"];
        }
        
    } failure:^(NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
    }];
}

- (BOOL)checkoutPhoneNum:(NSString *)mobile
{
    if (VV_REGEXP(mobile, kRegisterPhoneNumberPredicate))
    {
        return YES;
    }
    else
    {
        [VVAlertUtils showAlertViewWithMessage:VV_STR(@"请输入合法的手机号")
                             cancelButtonTitle:VV_STR(@"确定")
                                           tag:0
                                 completeBlock:nil];
        return NO;
    }
}

-(void)observerMobieNumHasChange:(NSNotification*)noti{
    _changeMobileNum = noti.userInfo[@"mobileNumChange"];
    _mobileBillId = noti.userInfo[@"mobileBillId"];
    
    if (VV_IS_NIL(_changeMobileNum)) {
        _customSwitch.on = YES;
        _bankCardMobileField.text = VV_SHDAT.orderInfo.mobile;
        _bankCardMobileField.enabled = NO;
        [self jigoubanVcreditViewIsShowSMS:NO andIsShowWithdrawOrRepayment:_isWithdrawOrRepaymentBankCard];
    }else{
        _customSwitch.on = NO;
        _bankCardMobileField.text = _changeMobileNum;
        [self jigoubanVcreditViewIsShowSMS:YES andIsShowWithdrawOrRepayment:_isWithdrawOrRepaymentBankCard];
        [MobClick event:@"modify_bank_phoneNum"];

    }

}

//添加还款银行卡请求
- (void)addRepayBankCard:(void (^)( BOOL succ))success{
    
    NSString * applicationName  = VV_SHDAT.orderInfo.applicantName;
    if (VV_IS_NIL(applicationName)) {
        [VLToast showWithText:@"未识别出您的姓名，请退出申请流程重新进入"];
        return;
    }
     __block NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.dicCode forKey:@"bankCode"];
    [param setObject:_bankCardTypeField.text forKey:@"bankPersonAccount"];
    [param setObject:_bankCardMobileField.text forKey:@"bankPersonMobile"];
    [param setObject:applicationName forKey:@"bankPersonName"];
    [param setObject:[UserModel currentUser].customerId forKey:@"customerId"];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postAddCreditBankCardParameters:param success:^(id result) {
        if ([result[@"success"] integerValue] == 1) {
            if (success) {
                success(YES);
            }
        }
        else
        {
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
            if (success) {
                success(NO);
            }
        }

    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        if (success) {
            success(NO);
        }
    }];
}


#pragma ---VVPickerViewDelegate
-(void)didFinishPickViewWithTextField:(UITextField *)myTextField text:(NSString *)text row:(NSInteger)row{
    if (myTextField == _bankCardNameField){
        BOOL isShowWithdrawOrRepayment = NO;
        for (int i = 0; i < self.dicTypeCodeArr.count; i++) {
            if ([self.dicTypeCodeArr[i] integerValue] == row) {
                isShowWithdrawOrRepayment = YES;
                break;
            }
        }
        _isWithdrawOrRepaymentBankCard = isShowWithdrawOrRepayment;
        [self jigoubanVcreditViewIsShowSMS: !_customSwitch.on andIsShowWithdrawOrRepayment:isShowWithdrawOrRepayment];
        _bankCardNameField.text = text;
        [self.infodic setObject:text forKey:@"bankCardName"];
        VVLog(@"名字%@",VV_SHDAT.orderInfo.applicantName);
        for (int i = 0 ; i < self.cardArray.count; i++) {
            if ([[self.cardArray[i] dicName] isEqualToString:text]) {
                self.dicCode = [self.cardArray[i] dicCode];
                VVLog(@"dicCode%@",self.dicCode);
                break;
            }
        }
        
    }
}
#pragma mark - 同盾上传
- (void)uploadTongdun:(NSString *)deviceInfo
{
    NSDictionary *dict = @{@"fingerPrint":deviceInfo,@"system":@"app",@"customerId":[UserModel currentUser].customerId};
    JJTongdunRequest *request = [[JJTongdunRequest alloc] initWithParam:dict];
//    __weak __typeof(self)weakSelf = self;

    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJBaseResponseModel *model = [(JJTongdunRequest *)request response];
        if (model.success) {
            [self postObtainingCreditLogin];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"请确认网络正常！！"];
    }];
    
}
@end
