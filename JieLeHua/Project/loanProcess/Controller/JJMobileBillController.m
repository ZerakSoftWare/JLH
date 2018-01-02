//
//  JJMobileBillController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/3/24.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJMobileBillController.h"
#import "UITextField+LimitLength.h"


@interface JJMobileBillController ()<UITextFieldDelegate>{
    UIView *_baseScrollView;//用来切换界面的 view
    NSMutableArray *_allTxtFieldArr;
    //    VVCreditBaseInfoModel *_authenticationModle;
    JJAuthenticationModel * _authenticationModle;
    
    //身份认证
    VVCommonTextField * _authenNameField;
    VVCommonTextField * _authenIdCardField;
    //手机验证
    VVCommonTextField * _mobileNumField;
    VVCommonTextField * _mobileCodeField;
    VVCommonTextField * _mobilePasswordField;
    VVCommonTextField * _mobileSMSCodeField;
    VVCommonTextField *_mobileQueryCodeField;
    VVCommonButton *_getSMSCodeBtn;
    
    UIImageView *_imageMobileCodeView;
    NSInteger _mobGetCraStaCount;//请求次数
    NSInteger _mobileInitCount;//手机初始化次数
    
    UIImageView *_frontIdImageView;
    UIImageView *_backIdImageView;
    UIImageView *_handImageView;
    
    UILabel * _frontLabel;//正面
    UILabel * _backLabel;//反面
    UILabel * _handLabel;//手持身份证
    
    int      _currentTime;
    NSTimer  * _timer;
    int idCardType;
    BOOL _isFront;
    
    NSString *_idcardImageObverse;
    NSString *_idcardImageReverse;
    NSString *_handImage;
    
    BOOL _isPostNotifcation;
}

@property(nonatomic,strong) NSString *mobileNextProCode;// 判断用
@property(nonatomic,strong) NSString * mobileVerCode;// 判断用
@property(nonatomic,strong)VVCommonButton *nextBtn;

@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *authenticationName;
@property(nonatomic,strong)NSString *authenticationIDcard;
@property(nonatomic,strong) NSString * mobilePassword;
@property(nonatomic,strong) NSString* mobileSMSCode;
@property(nonatomic,strong) NSString  *mobileImageCode;
@property(nonatomic,strong) NSString * mobileQueryCode;

@property (nonatomic, strong) UIAlertController *modifyAddressAlertController;
@property (nonatomic, strong) UIAlertAction *sureAction;
@property (nonatomic, strong) UITextField *modifyAddressField;
@property(nonatomic,strong) NSString * mobileBillId;
@end

@implementation JJMobileBillController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *changeMobileNum =nil;
//    if (VV_IS_NIL(VV_SHDAT.changeMobileNum)) {
//        if (_isPostNotifcation) {
//            changeMobileNum = self.mobile;
//        }
//    }else{
//        changeMobileNum = VV_SHDAT.changeMobileNum;
//    }
    if (_isPostNotifcation) {
        changeMobileNum = self.mobile;
    }
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:changeMobileNum , @"mobileNumChange",_mobileBillId,@"mobileBillId" ,nil];
    NSNotification *notification = [NSNotification notificationWithName:JJMobieHasChange object:nil userInfo:dic];
    [VV_NC postNotification:notification];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPostNotifcation = NO;
    [self setNavigationBarTitle:@"手机认证"];
    [self addBackButton];
    self.view.backgroundColor = VVWhiteColor;
    _allTxtFieldArr = [NSMutableArray arrayWithCapacity:1];
    [self showMobileNextView:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)setupscrollView{
    _baseScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0,0)];
    _baseScrollView.backgroundColor = VVWhiteColor;
    [_scrollView addSubview: _baseScrollView];
}

- (void)showMobileNextView:(BOOL)isModification{
    [_baseScrollView removeFromSuperview];
    [self setupscrollView];
    [_allTxtFieldArr removeAllObjects];
    
    _mobileVerCode = (VV_IS_NIL(VV_SHDAT.mobileInitModel.VerCodeBase64) || [VV_SHDAT.mobileInitModel.VerCodeBase64 isEqualToString:@"none"] )?@"":VV_SHDAT.mobileInitModel.VerCodeBase64;
    
    if (!_authenticationModle) {
        _authenticationModle = [[JJAuthenticationModel alloc]init];
    }
    
    //顺序不可变
    NSArray * textFieldArr = @[@{@"left":@"姓名",@"placeholder":@"您的姓名",@"right":@"",@"enabled":@"YES",@"type":@"name"}, //index 0
                               @{@"left":@"身份证",@"placeholder":@"请输入身份证号",@"right":@"recognizeIDCardNum",@"enabled":@"YES",@"type":@"idCard"},//index 1
                               @{@"left":@"手机号",@"placeholder":@"请输入实名制手机号",@"right":@"",@"enabled":@"YES",@"type":@"mobileNum"},//index 2
                               @{@"left":@"手机服务密码",@"placeholder":@"请输入手机服务密码",@"right":@"btn_忘记密码",@"enabled":@"YES",@"type":@"mobilePassword"},//index 3
                               @{@"left":@"短信验证码",@"placeholder":@"请输入验证码",@"right":@"smsCode",@"enabled":@"YES",@"type":@"mobileSMSCode"}, //index 4 //不带发送短信验证码按钮
                               @{@"left":@"查询码",@"placeholder":@"输入查询码",@"right":@"queryMobileCode",@"enabled":@"YES",@"type":@"mobileQueryCode"}, //index 5
                               @{@"left":@"手机验证码",@"placeholder":@"请输入验证码",@"right":@"sendSmsMobileCode",@"enabled":@"YES",@"type":@"mobileSMSCode"},//index 6
                               @{@"left":@"验证码",@"placeholder":@"输入验证码",@"right":@"imageview",@"enabled":@"YES",@"type":@"mobileImageVerCode"},//index 7
                               
                               ];
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    
    if ( VV_IS_NIL(_mobileNextProCode)) {
//        [mutableArr addObjectsFromArray:@[textFieldArr[0],textFieldArr[1],textFieldArr[2]]];
       [mutableArr addObjectsFromArray:@[textFieldArr[2]]];

    }else if ([_mobileNextProCode isEqualToString:@"Login"]){
        if (VV_IS_NIL(_mobileVerCode)) {
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[3]]];
        }else{
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[3],textFieldArr[7]]];
        }
    }else if ([_mobileNextProCode isEqualToString:@"LoginWithSMS"]) {
        if (VV_IS_NIL(_mobileVerCode)) {
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[3],textFieldArr[4]]];
        }else{
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[3],textFieldArr[4],textFieldArr[7]]];
        }
        
    }else if ([_mobileNextProCode isEqualToString:@"SendSMS"]||[_mobileNextProCode isEqualToString:@"SendSMSAndVercode"]){
        if (VV_IS_NIL(_mobileVerCode)) {
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[6]]];
        }else{
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[6],textFieldArr[7]]];
        }
        
    }else if ([_mobileNextProCode isEqualToString:@"CheckSMS"]){
        
        if (VV_IS_NIL(_mobileVerCode)) {
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[4]]];
        }else{
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[4],textFieldArr[7]]];
        }
    } else if ([_mobileNextProCode isEqualToString:@"CheckQueryCode"]){
        
        if (VV_IS_NIL(_mobileVerCode)) {
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[5]]];
        }else{
            [mutableArr addObjectsFromArray:@[textFieldArr[2],textFieldArr[5],textFieldArr[7]]];
        }
    }
    
    textFieldArr = [mutableArr copy];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, kScreenWidth, 1)];
    backView.backgroundColor = VVclearColor;
    [_baseScrollView addSubview:backView];
    
    __block CGFloat rectHeight = 0;
    
    [textFieldArr enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVCommonTextField *textfield = [[VVCommonTextField alloc]initWithFrame:CGRectMake(ktextFieldLeft, backView.bottom + idx*44, kScreenWidth-ktextFieldLeft, ktextFieldheight)];
        textfield.delegate = self;
        textfield.placeholder = obj[@"placeholder"];
        textfield.leftText = obj[@"left"];
        textfield.type = obj[@"type"];
        NSString *right = obj[@"right"];
        NSString *type = obj[@"type"];
        NSString *enabled = obj[@"enabled"];
        [_baseScrollView addSubview:textfield];
        [_allTxtFieldArr addObject:textfield];
        
        if ([textfield.type isEqualToString:@"mobileNum"]) {
            if ([_mobileNextProCode isEqualToString:@"SendSMS"]||[_mobileNextProCode isEqualToString:@"SendSMSAndVercode"]||[_mobileNextProCode isEqualToString:@"CheckSMS"]||[_mobileNextProCode isEqualToString:@"CheckQueryCode"]) {
                textfield.enabled = NO;
            }else{
                textfield.enabled = [enabled boolValue];
            }
        }else{
            textfield.enabled = [enabled boolValue];
        }
        
        if ([type isEqualToString:@"name"]) {
            _authenNameField = textfield;
        }else if ([type isEqualToString:@"idCard"]){
            _authenIdCardField= textfield;
            
            //身份证限制输入18位
            [_authenIdCardField limitTextLength:18 block:^(NSString *text) {
                _authenIdCardField.text = text;
            }];
            
        }else if ([type isEqualToString:@"mobileNum"]){
            
            _mobileNumField= textfield;
            _mobileNumField.maxlength = 11;
            _mobileNumField.keyboardType = UIKeyboardTypeNumberPad;
            
        }else if ([type isEqualToString:@"mobilePassword"]){
            _mobilePasswordField = textfield;
            _mobilePasswordField.keyboardType = UIKeyboardTypeASCIICapable;
            _mobilePasswordField.secureTextEntry = YES;
            _mobilePasswordField.backgroundColor = [UIColor clearColor];
            [_mobilePasswordField setAutocorrectionType:UITextAutocorrectionTypeNo];
            _mobilePasswordField.returnKeyType = UIReturnKeyDone;
            _mobilePasswordField.maxlength = MobPassWordLength;
            textfield.clearButtonMode = UITextFieldViewModeNever;
            textfield.keyboardType = UIKeyboardTypeASCIICapable;
            textfield.secureTextEntry = YES;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(kScreenWidth-80, backView.bottom +idx*44, 80, 44);
            [btn setTitle:@"忘记密码？" forState:UIControlStateNormal];
            [btn setTitleColor:VVBASE_OLD_COLOR forState:UIControlStateNormal];
            [btn addTarget:self  action:@selector(clickMobileFuwuPassword:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [_baseScrollView addSubview:btn];
            
            
        }else if ([type isEqualToString:@"mobileSMSCode"]){
            textfield.userInteractionEnabled = YES;
            textfield.frame = CGRectMake(ktextFieldLeft, backView.bottom +idx*44, kScreenWidth-ktextFieldLeft*2, ktextFieldheight);
            
            _mobileSMSCodeField = textfield;
            _mobileSMSCodeField.maxlength = MobSMSLength;
            _mobileSMSCodeField.keyboardType = UIKeyboardTypeASCIICapable;
            [_mobileSMSCodeField setAutocorrectionType:UITextAutocorrectionTypeNo];
            
            if ([right isEqualToString:@"sendSmsMobileCode"]) {
                textfield.frame = CGRectMake(ktextFieldLeft, backView.bottom +idx*44, kScreenWidth-ktextFieldLeft*2-95, ktextFieldheight);
                _getSMSCodeBtn = [VVCommonButton getSMSCodeButton];
                _getSMSCodeBtn.frame = CGRectMake(kScreenWidth-105, idx*44, 90, 34);
                _getSMSCodeBtn.centerY = textfield.centerY;
                [_getSMSCodeBtn addTarget:self  action:@selector(getSMSCode:) forControlEvents:UIControlEventTouchUpInside];
                _getSMSCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
                [_baseScrollView addSubview:_getSMSCodeBtn];
                
            }
            
        }else if ([type isEqualToString:@"mobileImageVerCode"]){
            textfield.userInteractionEnabled = YES;
            textfield.frame = CGRectMake(ktextFieldLeft, backView.bottom +idx*44, kScreenWidth-110, ktextFieldheight);
            
            _imageMobileCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-90, backView.bottom +idx*44+2, 70, 40)];
            _imageMobileCodeView.backgroundColor = VV_COL_RGB(0xefeff4);
            _imageMobileCodeView.image = VV_GETIMG(@"nomalCode_Image");
            if (!VV_IS_NIL(VV_SHDAT.mobileInitModel.VerCodeBase64)) {
                _imageMobileCodeView.image = [UIImage base64ToImage:VV_SHDAT.mobileInitModel.VerCodeBase64];
            }
            [_baseScrollView addSubview:_imageMobileCodeView];
            _imageMobileCodeView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mobileTapUpdataImageCode:)];
            [_imageMobileCodeView addGestureRecognizer:tap];
            
            _mobileCodeField = textfield;
            _mobileCodeField.maxlength = 6;
            _mobileCodeField.keyboardType = UIKeyboardTypeASCIICapable;
            [_mobileCodeField setAutocorrectionType:UITextAutocorrectionTypeNo];
            
        }else if ([type isEqualToString:@"mobileQueryCode"]){
            textfield.frame = CGRectMake(ktextFieldLeft, backView.bottom +idx*44, kScreenWidth-ktextFieldLeft*2, ktextFieldheight);
            _mobileQueryCodeField = textfield;
            _mobileQueryCodeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        if ([right isEqualToString:@"imageview"]) {
            textfield.userInteractionEnabled = YES;
            textfield.frame = CGRectMake(ktextFieldLeft, backView.bottom +idx*44, kScreenWidth-110, ktextFieldheight);
            
            _imageMobileCodeView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-90,backView.bottom + idx*44+2, 70, 40)];
            _imageMobileCodeView.backgroundColor = VV_COL_RGB(0xefeff4);
            _imageMobileCodeView.image = VV_GETIMG(@"nomalCode_Image");
            if (!VV_IS_NIL(VV_SHDAT.mobileInitModel.VerCodeBase64)) {
                _imageMobileCodeView.image = [UIImage base64ToImage:VV_SHDAT.mobileInitModel.VerCodeBase64];
            }
            
            [_baseScrollView addSubview:_imageMobileCodeView];
            _imageMobileCodeView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mobileTapUpdataImageCode:)];
            [_imageMobileCodeView addGestureRecognizer:tap];
            
            _mobileCodeField = textfield;
            _mobileCodeField.maxlength = 6;
            _mobileCodeField.keyboardType = UIKeyboardTypeASCIICapable;
            [_mobileCodeField setAutocorrectionType:UITextAutocorrectionTypeNo];
        }
        
        rectHeight = textfield.bottom;
    }];
    
    if (self.mobile) {
        _mobileNumField.text = self.mobile;
        _mobileNumField.enabled = NO;
    }
   
    _nextBtn = [VVCommonButton solidButtonWithTitle:@"下一步"];
    _nextBtn.frame = CGRectMake(VVleftMargin, rectHeight+60, kScreenWidth-VVleftMargin*2, VVBtnHeight);
    [_nextBtn addTarget:self action:@selector(mobileNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:_nextBtn];
    [_nextBtn setUserInteractionEnabled:NO];
    [_baseScrollView addSubview:_nextBtn];
    _baseScrollView.frame = CGRectMake(0, 64, kScreenWidth,kScreenHeight);
    self.view.height = _baseScrollView.height;
   self.scrollView.contentSize = CGSizeMake(vScreenWidth, self.view.bottom);
    
    [self showMobileBtnStatues];
}


#pragma mark  手机验证  按钮

//  手机验证 按钮点击事件  点击下一步
//  手机验证 按钮点击事件  点击下一步
- (void)mobileNextBtn:(UIButton *)sender
{
    
    VVLog(@"VV_SHDAT.mobileInitModel ==========:%@",[VV_SHDAT.mobileInitModel mj_JSONObject]);
    
    [self.view endEditing:YES];
    if (![self checkoutPhoneNum:_mobile])
    {
        return;
    }
    
    
    if (VV_IS_NIL(_mobileNextProCode)) {
        
        [self initMobileInfo];

    }else if ([_mobileNextProCode isEqualToString:@"Login"]||[_mobileNextProCode isEqualToString:@"LoginWithSMS"]) {//这两个的处理 是一样的  只是界面不一样
        [self mobilLogin:^(BOOL succ) {
            if (succ) {
                
                if ([_mobileNextProCode isEqualToString:@"Query"]) {
                    [self postApplyUpdateServesMobile];
                    
                }else{
                    [self showMobileNextView:NO];
                }
                
            }else{
                [self initMobileInfo];
            }
            
            
        }];
        
        
    }else if ([_mobileNextProCode isEqualToString:@"CheckSMS"]){
        VVLog(@"mVV_SHDAT.CheckSMS:%@",[VV_SHDAT.mobileInitModel mj_JSONObject]);
        
        [self  sendMobilCheckSMS:^(BOOL succ) {
            if(succ){
                if ( [_mobileNextProCode isEqualToString:@"Query"]) {
                    [self postApplyUpdateServesMobile];
                    
                }
            }else{
                
                //登录成功后 有可能 nextProCode 直接是 CheckSMS , 这个时候失败 需要把短信验证码按钮显示出来
                if (!_getSMSCodeBtn) {
                    _mobileNextProCode = @"SendSMS";
                    [self showMobileNextView:NO];
                    
                }
                //不作处理。因为能继续点击获取验证码
            }
            
        }];
        
    } else if ([_mobileNextProCode isEqualToString:@"CheckQueryCode"]){
        VVLog(@"mVV_SHDAT.CheckQueryCode:%@",[VV_SHDAT.mobileInitModel mj_JSONObject]);
        
        [self  sendMobilCheckSMS:^(BOOL succ) {
            if(succ){
                if ( [_mobileNextProCode isEqualToString:@"Query"]) {
                    [self postApplyUpdateServesMobile];
                    
                }else{
                    //调上一步界面,即返回登录界面
                    [self initMobileInfo];
                }
            }else{
                //调上一步界面,即返回登录界面
                [self initMobileInfo];
            }
        }];
        
    }else if ([_mobileNextProCode isEqualToString:@"Query"]){  //好像用不到 都在login 和check的返回成功里面处理了
        //上传所有信息 去获取征信页面
        [self postApplyUpdateServesMobile];
        
    }
    
}


-(void)mobileLogin{
    [self mobilLogin:^(BOOL succ) {
        if (succ) {
            [self showMobileNextView:NO];
            
        }else{
            [self initMobileInfo];//登录失败自动初始化
        }
        
    }];
    
}

#pragma mark    手机验证 网络  初始化

//  手机  点击图片重新初始化 刷新一下暂时直接用initMobileInfo
- (void)mobileTapUpdataImageCode:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    //    [self initMobileInfo:_mobileNumField.text];
}


//获取短信验证码
- (void)getSMSCode:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if ([self checkoutPhoneNum:_mobileNumField.text])
    {
        
        _getSMSCodeBtn.enabled = NO;
        _currentTime = 60;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        [_getSMSCodeBtn setBackgroundColor:[ UIColor  colorWithWholeRed:167 green:197 blue:242]  forState:UIControlStateDisabled];
        
        //        if ([_mobileNextProCode isEqualToString:@"SendSMSAndVercode"]) { //如果当前步骤为SendSMSAndVercode ，失败的话重新初始化，在登录界面
        //            [self initMobileInfo];
        //        }else{
        
        // SendSMS，失败的话一直调这个接口
        [self sendMobilSMSCode:^(BOOL succ) {
            
            VVLog(@"sendMobilSMSCode%d",succ);
            
            if(succ){
                [self showMobileNextView:NO];
            }else{
                //_mobileNextProCode 为空 重新初始化
                [self initMobileInfo];
            }
        }];
        //        }
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


- (void)initMobileInfo{ //初始化并进入登录界面
    
    [self showHud];
    [VVNetInit mobileNetInitPhoneNum:self.mobile  Name: VV_SHDAT.orderInfo.applicantName IdCard:VV_SHDAT.orderInfo.applicantIdcard success:^(BOOL result) {
        [self hideHud];
        
        if (result) {
            _mobileNextProCode = VV_SHDAT.mobileInitModel.nextProCode;   //初始化成功接口存储
            [self showMobileNextView:NO];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [VLToast showWithText:[self strFromErrCode:error]];
    }];
    
}


//    手机验证 网络  手机登录
- (void)mobilLogin:(void (^)( BOOL succ))success{
    
    if (![self checkoutPhoneNum:_mobileNumField.text])
    {
        [VLToast showWithText:@"手机号输入不正确，请重新填写"];
        return;
    }
    
    NSDictionary *dic = @{@"token":VV_IS_NIL(VV_SHDAT.mobileInitModel.Token)?@"":VV_SHDAT.mobileInitModel.Token,
                          @"mobile":self.mobile,
                          @"password":self.mobilePassword,
                          @"vercode":VV_IS_NIL(self.mobileImageCode)?@"":self.mobileImageCode ,
                          @"IdentityCard":VV_IS_NIL(VV_SHDAT.orderInfo.applicantIdcard)?@"":VV_SHDAT.orderInfo.applicantIdcard,
                          @"Website":VV_IS_NIL(VV_SHDAT.mobileInitModel.Website)?@"":VV_SHDAT.mobileInitModel.Website,
                          @"Name":VV_IS_NIL(VV_SHDAT.orderInfo.applicantName)?@"":VV_SHDAT.orderInfo.applicantName,
                          @"bustype":@"JIELEHUA",
                          @"busid":@"",
                          @"smscode":VV_IS_NIL(self.mobileSMSCode)?@"":self.mobileSMSCode,
                          };
    
    NSString *str = [dic mj_JSONString];
    NSString *base64 = [str base64EncodedString];
    VVLog(@"base64 ==%@",base64);
    [self showHud];
    [[VVNetWorkUtility netUtility]postMobileLoginSoapMessage:base64 success:^(id result)
     {
         [self hideHud];
         NSDictionary *rsultDic = (NSDictionary *)result;
         if ([rsultDic[@"StatusCode"]integerValue] == 0)  {
             
             if (VV_IS_NIL(rsultDic[@"nextProCode"]) ) {
                 if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                     [VLToast showWithText: rsultDic[@"StatusDescription"]];
                 }
                 if (success) {
                     success(NO);
                 }
             }else{
                 _mobileNextProCode = rsultDic[@"nextProCode"];
                 VV_SHDAT.mobileInitModel.VerCodeBase64 = rsultDic[@"VerCodeBase64"];
                 
                 NSString * resultIdStr = rsultDic[@"Result"];
                 VVLog(@"login resultIdStr===%@",resultIdStr);
                 NSDictionary *idDic = [resultIdStr mj_JSONObject];
                 if (idDic) {
                     NSString *mobileId = idDic[@"Id"];
                     _mobileBillId = mobileId;
                 }
                 if (success) {
                     success(YES);
                 }
             }
             
         }else{
             [self hideHud];
             if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                 [VLToast showWithText: rsultDic[@"StatusDescription"]];
             }
             if (success) {
                 success(NO);
             }
             
         }
         
     } failure:^(NSError *error) {
         [self hideHud];
         [VLToast showWithText:[self strFromErrCode:error]];
         
     }];
    
}

//    手机验证 网络 发送手机验证吗
- (void)sendMobilSMSCode:(void (^)( BOOL succ))success{
    __weak typeof(self) wself = self;
    if (![self checkoutPhoneNum:_mobileNumField.text]){
        return;
    }
    NSDictionary *dic = @{@"token":VV_IS_NIL(VV_SHDAT.mobileInitModel.Token)?@"":VV_SHDAT.mobileInitModel.Token,
                          @"mobile":_mobileNumField.text,
                          @"Website":VV_IS_NIL(VV_SHDAT.mobileInitModel.Website)?@"":VV_SHDAT.mobileInitModel.Website
                          };
    
    NSString *str = [dic mj_JSONString];
    NSString *base64 = [str base64EncodedString];
    VVLog(@"base64 ==%@",base64);
    [[VVNetWorkUtility netUtility]postMobileSendsmsSoapMessage:base64 success:^(id result)
     {
         NSDictionary *rsultDic = (NSDictionary *)result;
         if ([rsultDic[@"StatusCode"]integerValue] == 0)  {
             //nextProCode 为空的处理  刷新获取验证码界面不变
             if (VV_IS_NIL(rsultDic[@"nextProCode"])) {
                 
                 _mobileNextProCode = @"";
                 [wself resetGetSMSCodeButton];
                 if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                     [VLToast showWithText:rsultDic[@"StatusDescription"]];
                 }
                 
             }else{
                 //                 {
                 //                     "EndTime": "2017\/3\/14 16:34:51",
                 //                     "Result": null,
                 //                     "StartTime": "2017\/3\/14 16:34:51",
                 //                     "StatusCode": 0,
                 //                     "StatusDescription": "浙江移动验证码发送成功",
                 //                     "Token": "a91175825f1440f8bf2616bf5c2d2255",
                 //                     "Website": "ChinaMobile_ZJ",
                 //                     "nextProCode": "CheckSMS",
                 //                     "VerCodeBase64": "none"
                 //                 }
                 
                 VV_SHDAT.mobileInitModel.VerCodeBase64 = rsultDic[@"VerCodeBase64"];
                 _mobileNextProCode = rsultDic[@"nextProCode"];
                 //如果有图形验证码 否则一只停留在发送验证码页面  nextProCode已经是check了
                 if (success&&!VV_IS_NIL(rsultDic[@"VerCodeBase64"])&&![rsultDic[@"VerCodeBase64"] isEqualToString:@"none"])  {
                     success(YES);
                 }
             }
             //             VVLog(@"mVV_SHDAT.sendMobile:%@",[VV_SHDAT.mobileInitModel mj_JSONObject]);
             
         }else{
             
             [wself resetGetSMSCodeButton];
             if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                 [VLToast showWithText: rsultDic[@"StatusDescription"]];
             }
         }
         
     } failure:^(NSError *error) {
         
         [VLToast showWithText:[self strFromErrCode:error]];
         if(success){
             success(NO);
         }
     }];
    
}

//    手机验证 网络 验证手机验证码
- (void)sendMobilCheckSMS:(void (^)( BOOL succ))success{
    
    if (![self checkoutPhoneNum:_mobileNumField.text])
    {
        return;
    }
    __weak typeof(self) wself = self;
    
    NSDictionary *dic =
    @{@"token":VV_IS_NIL(VV_SHDAT.mobileInitModel.Token)?@"":VV_SHDAT.mobileInitModel.Token,
      @"mobile":_mobile,
      @"smscode":VV_IS_NIL(_mobileSMSCode)?@"":_mobileSMSCode,
      @"QueryCode":VV_IS_NIL(_mobileQueryCode)?@"":_mobileQueryCode,
      @"Website":VV_IS_NIL(VV_SHDAT.mobileInitModel.Website)?@"":VV_SHDAT.mobileInitModel.Website,
      @"IdentityCard":_authenticationIDcard,
      @"vercode":VV_IS_NIL(_mobileImageCode)?@"":_mobileImageCode,
      @"bustype":@"JIELEHUA",
      @"busid":@""
      };
    
    
    NSString *str = [dic mj_JSONString];
    NSString *base64 = [str base64EncodedString];
    [self showHud];
    [[VVNetWorkUtility netUtility]postMobileChecksmsSoapMessage:base64 success:^(id result)
     {
         [self hideHud];
         NSDictionary *rsultDic = (NSDictionary *)result;
         if ([rsultDic[@"StatusCode"]integerValue] == 0)  {
             NSString *nextPro = rsultDic[@"nextProCode"];
             
             if (VV_IS_NIL(nextPro)) {
                 if (success) {
                     success(NO);
                 }
                 [VLToast showWithText: [NSString stringWithFormat:@"%@,%@",rsultDic[@"StatusDescription"],@"请点击获取验证码按钮"]];
                 [wself resetGetSMSCodeButton];
             }else{
                 NSString * resultIdStr = rsultDic[@"Result"];
                 NSDictionary *idDic = [resultIdStr mj_JSONObject];
                 if (idDic) {
                     NSString *mobileId = idDic[@"Id"];
                     _mobileBillId = mobileId;
                     VV_SHDAT.mobileInitModel.nextProCode = nextPro;
                     _mobileNextProCode = VV_IS_NIL(rsultDic[@"nextProCode"])?@"":rsultDic[@"nextProCode"]  ;
                     VVLog(@"mobileId :%@",mobileId);
                 }
                 
                 if (success) {
                     success(YES);
                 }
             }
         }else{
             if (success) {
                 success(NO);
             }
             [wself resetGetSMSCodeButton];
             if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                 [VLToast showWithText: rsultDic[@"StatusDescription"]];
             }
         }
         
     } failure:^(NSError *error) {
         [self hideHud];
         [VLToast showWithText:[self strFromErrCode:error]];
     }];
    
}


- (void)postApplyUpdateServesMobile{
    _isPostNotifcation = YES;
    [self customPopViewController];
}


#pragma mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidChangeNotification:(NSNotification *)notification
{
    
    if (_mobileNumField.text.length > 11) {
        _mobileNumField.text = [_mobileNumField.text substringToIndex:11];
    }
    if (_mobilePasswordField.text.length > MobPassWordLength) {
        _mobilePasswordField.text = [_mobilePasswordField.text substringToIndex:MobPassWordLength];
    }
    if (_mobileCodeField.text.length > 10) {
        _mobileCodeField.text = [_mobileCodeField.text substringToIndex:10];
    }
    if (_mobileSMSCodeField.text.length > MobSMSLength) {
        _mobileSMSCodeField.text = [_mobileSMSCodeField.text substringToIndex:MobSMSLength];
    }
    if (_mobileQueryCodeField.text.length > 6) {
        _mobileQueryCodeField.text = [_mobileQueryCodeField.text substringToIndex:6];
    }
    if(_authenIdCardField.text.length > 18){
        _authenIdCardField.text = [_authenIdCardField.text substringFromIndex:18];
    }
    
    [self showMobileBtnStatues];
}

- (void)showMobileBtnStatues{
    
    
    
    __block BOOL isEmpty = YES;
    [_allTxtFieldArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVCommonTextField *textfield = obj;
        if (VV_IS_NIL(textfield.text)) {
            isEmpty = NO;
        }
        
        if ([textfield.leftText isEqualToString:@"手机号"]){
            self.mobile= _mobileNumField.text;
            
        }else if ([textfield.leftText isEqualToString:@"手机服务密码"]){
            self.mobilePassword = _mobilePasswordField.text;
            
        }else if ([textfield.leftText isEqualToString:@"短信验证码"]){
            self.mobileSMSCode =  _mobileSMSCodeField.text;
            
        }else if ([textfield.leftText isEqualToString:@"查询码"]){
            self.mobileQueryCode =  _mobileQueryCodeField.text;
            
        }else if ([textfield.leftText isEqualToString:@"手机验证码"]){
            self.mobileSMSCode =  _mobileSMSCodeField.text;
            
        }else if ([textfield.leftText isEqualToString:@"验证码"]){
            self.mobileImageCode =  _mobileCodeField.text;
            
        }
        
    }];
    
    if (isEmpty) {
        [_nextBtn setUserInteractionEnabled:YES];
        _nextBtn.selected = YES;
    }else{
        
        [_nextBtn setUserInteractionEnabled:NO];
        _nextBtn.selected = NO;
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //允许删除字符输出
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (_authenNameField == textField) {
        NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
        if ([lang isEqualToString:@"emoji"]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
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

//   手机验证  忘记服务密码
- (void)clickMobileFuwuPassword:(UIButton *)sender{
    [self.view endEditing:YES];
    
    [VVAlertUtils showAlertViewWithTitle:@"" message:nil
                              customView:[self customAlertViewSMS]
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                           
                       }];
    
}

- (UIView *)customAlertViewSMS
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    
    NSArray *titleAry = @[
                          @"中国联通用户可编辑短\n信MMCZ至10010即可重置\n运营商服务密码",
                          @"中国移动用户可编辑短信CZMM至\n10086即可重置运营商服务密码",
                          @"中国电信用户可编辑短\n信MMCZ至10001即可重置运营商\n服务密码"
                          ];
    
    for (int i =  0; i < titleAry.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+60*i, kScreenWidth,60)];
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:15];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleAry[i]];
        
        NSUInteger loc;
        
        if (i == 1)
        {
            loc = 11;
        }
        else
        {
            loc = 12;
        }
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:VVBASE_OLD_COLOR range:NSMakeRange(loc, 4)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:VVBASE_OLD_COLOR range:NSMakeRange(17, 5)];
        
        lab.attributedText = attrStr;
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
    }
    
    return view;
}

@end
