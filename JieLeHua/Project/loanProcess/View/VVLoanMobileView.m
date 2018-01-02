//
//  VVLoanMobileView.m
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVLoanMobileView.h"
#import "VVCommonTextField.h"
#import "UIImage+GIF.h"
#import "OliveappCaptureDatabaseImageViewController.h"
#import "VVAVCaptureSessionViewController.h"
#import "JJIDCardModel.h"
#import "UITextView+Placeholder.h"
#import "UITextField+LimitLength.h"
#import "IQUIView+Hierarchy.h"
#import "JJGetZhimaUrlRequest.h"
#import "JJUpdateZhimaRequest.h"
#import "JJZhimaWebViewController.h"
#import "JJVersionSourceManager.h"
#import "UIImage+Extension.h"
#pragma mark - 活体检测
#import "OliveappLivenessDetectionViewController.h"
#import "OliveappLivenessDataType.h"
#import "NSData+Base64.h"
#import "JJAuthZhimaRequest.h"

//{
//    "applyId": 0,
//    "creditAuthorizationBase64": "string",
//    "customerId": 0,
//    "faceBase64": "string",
//    "householdAddr": "string",
//    "idcardImageBase64": "string",
//    "idcardImageObverseBase64": "string",
//    "idcardImageReverseBase64": "string",
//    "idcardNo": "string",
//    "mobile": "string",
//    "mobileAddress": "string",
//    "mobileBillId": "string",
//    "name": "string"
//}

#define kHorizenInset (([UIScreen mainScreen].bounds.size.width - 270)/2)
@interface VVLoanMobileView ()<UITextFieldDelegate,OliveappOnDatabaseImageCapturedEventListener,VVAVCaptureSessionViewControllerDelegate,OliveappLivenessResultDelegate>{
    UIView *_baseScrollView;//用来切换界面的 view
    UIView *_zhimaCoverView;//芝麻信用的界面
    
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
    
    JJIDCardModel *_idCardModel;

}

@property(nonatomic,strong) NSString *mobileNextProCode;// 判断用
@property(nonatomic,strong) NSString * mobileVerCode;// 判断用

@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *authenticationName;
@property(nonatomic,strong)NSString *authenticationIDcard;
@property(nonatomic,strong) NSString * mobilePassword;
@property(nonatomic,strong) NSString* mobileSMSCode;
@property(nonatomic,strong) NSString  *mobileImageCode;
@property(nonatomic,strong) NSString * mobileQueryCode;

@property (nonatomic, strong) UIAlertController *modifyAddressAlertController;
@property (nonatomic, strong) UIAlertAction *modifyAddressSureAction;
@property (nonatomic, strong) UITextField *modifyAddressField;

@property (nonatomic, strong) UIAlertController *modifyNameAlertController;
@property (nonatomic, strong) UIAlertAction *modifyNameSureAction;
@property (nonatomic, strong) UITextField *modifyNameField;

@property (nonatomic, strong) UIAlertController *modifyIDcardAlertController;
@property (nonatomic, strong) UIAlertAction *modifyIDcardSureAction;
@property (nonatomic, strong) UITextField *modifyIDcardField;

@property(nonatomic,strong) NSString * syncWay;
@property(nonatomic,strong) NSString * accessToken;
@property(nonatomic,strong) NSString * wechatCustomerId;
@property(nonatomic,strong) NSString * message;
@property(nonatomic,strong) NSString * mobileForAync;
@property(nonatomic,strong) NSString * customerIdForAync;

@property (nonatomic, copy) NSString *zhimaScore;
@property (nonatomic, strong) UIButton *zhimaNextBtn;
@property (nonatomic, strong) VVCommonTextField *zhimaField;
@property (nonatomic, strong)  UIButton *zhimaAuthbtn;
@property(nonatomic,strong) UIView * backView;
@property(nonatomic,strong) UIButton * modifyNameBtn;
@property(nonatomic,strong) UIButton * modifyIDcardBtn;

@property(nonatomic,strong) UIView * frontIdView;
@property(nonatomic,strong) UIView * backIdView;
@property(nonatomic,strong) UIView * handIdView;
@property(nonatomic,strong) UIImageView * resetFrontPhoto;
@property(nonatomic,strong) UIImageView * resetBackPhoto;
@property(nonatomic,strong) UIImageView * resetHandPhoto;
@property (nonatomic, strong) MBProgressHUD *hud;

@end


@implementation VVLoanMobileView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [VV_NC addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
        _mobile = VV_SHDAT.mobileInitModel.mobile;
        _allTxtFieldArr = [NSMutableArray arrayWithCapacity:1];
        //打开定时器
        [_timer setFireDate:[NSDate distantPast]];

    }
    return self;
}
- (void)dealloc{
    [VV_NC removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)showBackPreviewShowMobileNextView{
    
    if ([VV_SHDAT.orderInfo.applyStatusCode integerValue] >= applyTypeCredit) {
        [self showIdCardViewType:@"updataSuccess" view:_frontIdImageView lable:_frontLabel];
        [self showIdCardViewType:@"updataSuccess" view:_backIdImageView lable:_backLabel];
        [self showIdCardViewType:@"updataSuccess" view:_handImageView lable:_handLabel];

    }else{
        [self showIdCardViewType:@"updataDefault" view:_frontIdImageView lable:_frontLabel];
        [self showIdCardViewType:@"updataDefault" view:_backIdImageView lable:_backLabel];
        [self showIdCardViewType:@"updataDefault" view:_handImageView lable:_handLabel];
    }

}
 
#pragma mark subView

- (void)setupscrollView{
   if((enum ApplyType)[VV_SHDAT.orderInfo.applyStatusCode integerValue] == applyTypeZhimaScore ){
        [self setupZhimaView];
   }else{
       _baseScrollView = [[UIView alloc] initWithFrame:CGRectZero];
       _baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
       _baseScrollView.backgroundColor = VVWhiteColor;
       [self addSubview: _baseScrollView];
   }
}

-(void)setupZhimaView{
    _zhimaCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50-40)];
    _zhimaCoverView.userInteractionEnabled = YES;
    _zhimaCoverView.backgroundColor = VVWhiteColor;
    [self addSubview: _zhimaCoverView];

    self.zhimaField = [[VVCommonTextField alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-ktextFieldLeft, ktextFieldheight)];
    _zhimaField.delegate = self;
    _zhimaField.placeholder = @"未验证";
    _zhimaField.leftText = @"芝麻信用评分";
    _zhimaField.enabled = NO;
    _zhimaField.textColor = [UIColor globalThemeColor];
//    _zhimaField = zhimaField;
    _zhimaField.userInteractionEnabled = YES;
    
    self.zhimaAuthbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhimaAuthbtn.frame = self.zhimaField.frame;
    _zhimaAuthbtn.backgroundColor = [UIColor clearColor];
    [_zhimaAuthbtn addTarget:self action:@selector(gotoAuth:) forControlEvents:UIControlEventTouchUpInside];
    [_zhimaCoverView addSubview:_zhimaAuthbtn];

    UIImage* img = VV_GETIMG(@"arrow_right");
    UIImageView*rightAccessory = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-img.size.width, _zhimaField.top+(_zhimaField.height-img.size.width)/2, img.size.width, img.size.height)];
    rightAccessory.image = img;
    rightAccessory.hidden = NO;
    [_zhimaCoverView addSubview:rightAccessory];
    [_zhimaCoverView addSubview:_zhimaField];
    
//    self.zhimaNextBtn = [VVCommonButton solidButtonWithTitle:@"下一步"];
    self.zhimaNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zhimaNextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _zhimaNextBtn.frame = CGRectMake(VVleftMargin, _zhimaCoverView.bottom - 200, kScreenWidth-VVleftMargin*2, VVBtnHeight);
    [self.zhimaNextBtn addTarget:self action:@selector(zhimaAuthAction:) forControlEvents:UIControlEventTouchUpInside];
    [_zhimaNextBtn setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    [_zhimaNextBtn setBackgroundColor:[UIColor unableButtonThemeColor] forState:UIControlStateDisabled];
    _zhimaNextBtn.enabled = NO;
    [_zhimaCoverView addSubview:_zhimaNextBtn];
    _zhimaCoverView.frame = CGRectMake(0, 0, kScreenWidth, _zhimaNextBtn.y+150);

    //获取是否已验证
//#if DEBUG
//    NSDictionary *dict = @{@"Name":VV_SHDAT.orderInfo.applicantName,
//                           @"Identity":VV_SHDAT.orderInfo.applicantIdcard,
//                           @"BusType":@"test",
//                           @"Platform":@"app"};
//#else
    NSDictionary *dict = @{@"Name":VV_SHDAT.orderInfo.applicantName,
                           @"Identity":VV_SHDAT.orderInfo.applicantIdcard,
                           @"BusType":@"JIELEHUA",
                           @"Platform":@"app"};
//#endif
    JJAuthZhimaRequest *request = [[JJAuthZhimaRequest alloc] init];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        VVLog(@"%@",request.responseJSONObject);
        if ([[[request.responseJSONObject objectForKey:@"data"] objectForKey:@"StatusCode"] integerValue] == 0 && [request.responseJSONObject objectForKey:@"data"]!= nil) {
            strongSelf.zhimaField.text = @"已验证";
            strongSelf.zhimaScore = [[request.responseJSONObject objectForKey:@"data"] objectForKey:@"Result"];
//            if ([[JJVersionSourceManager versionSourceManager].versionSource isEqualToString:@"2"] || [[JJVersionSourceManager versionSourceManager].versionSource isEqualToString:@"1"]) {
                if ([strongSelf.zhimaScore integerValue] > 0) {
                    self.zhimaNextBtn.enabled = YES;
                    self.zhimaField.text = @"已验证";
                    self.zhimaAuthbtn.enabled = NO;
                }else{
                    self.zhimaScore = @"0";
                    self.zhimaField.text = @"已验证,芝麻分为0";
                    self.zhimaNextBtn.enabled = NO;
                    self.zhimaAuthbtn.enabled = NO;
                }
//            }else{
//                strongSelf.zhimaNextBtn.enabled = YES;
//                strongSelf.zhimaField.enabled = NO;
//                strongSelf.zhimaAuthbtn.enabled = NO;
//            }
        }
        else{
            strongSelf.zhimaField.placeholder = @"未验证";
            strongSelf.zhimaNextBtn.enabled = NO;
            strongSelf.zhimaAuthbtn.enabled = YES;
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.zhimaField.placeholder = @"未验证";
        strongSelf.zhimaNextBtn.enabled = NO;
    }];
}

- (void)gotoAuth:(id)sender
{
    JJZhimaWebViewController *testVC = [[JJZhimaWebViewController alloc] init];
    testVC.identity = VV_SHDAT.orderInfo.applicantIdcard;
    testVC.name = VV_SHDAT.orderInfo.applicantName;
    testVC.webTitle = @"芝麻授信";
    __weak __typeof(self)weakSelf = self;
    testVC.authorizationSuccessBlockSuccBlock = ^(NSString *score){
        VVLog(@"芝麻授信======%@",score);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showZhimaViewWithScore:score];
    };
    [_controller customPushViewController:testVC withType:nil subType:nil];
}

- (void)showZhimaViewWithScore:(NSString *)score
{
//    if ([[JJVersionSourceManager versionSourceManager].versionSource isEqualToString:@"2"] || [[JJVersionSourceManager versionSourceManager].versionSource isEqualToString:@"1"]) {
        if (nil == score) {
            self.zhimaScore = @"0";
            self.zhimaField.text = @"没有芝麻分";
            self.zhimaNextBtn.enabled = NO;
            self.zhimaAuthbtn.enabled = NO;
            return ;
        }
        else if ([score intValue] > 0) {
            self.zhimaScore = score;
            self.zhimaNextBtn.enabled = YES;
            self.zhimaField.text = @"已验证";
            self.zhimaAuthbtn.enabled = NO;
        }else{
            self.zhimaScore = @"0";
            self.zhimaField.text = @"已验证,芝麻分为0";
            self.zhimaNextBtn.enabled = NO;
            self.zhimaAuthbtn.enabled = NO;
            return ;
        }
//    }else{
//        if (nil == score) {
//            self.zhimaScore = @"0";
//            self.zhimaField.text = @"已验证";
//            self.zhimaNextBtn.enabled = YES;
//            self.zhimaAuthbtn.enabled = NO;
//            return ;
//        }
//        self.zhimaScore = score;
//        self.zhimaNextBtn.enabled = YES;
//        self.zhimaField.text = @"已验证";
//        self.zhimaAuthbtn.enabled = NO;
//    }
}

-(void)zhimaAuthAction:(id)button{
    //提交芝麻分
    NSDictionary *dict = @{@"customerId":[UserModel currentUser].customerId,
                           @"sesameCreditMoney":self.zhimaScore?self.zhimaScore:@"0"};
    JJUpdateZhimaRequest *request = [[JJUpdateZhimaRequest alloc] initWithParam:dict];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:_controller];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        NSDictionary *dict  = request.responseJSONObject;
        
        if ([[dict safeObjectForKey:@"success"] boolValue]) {
            
                VVOrderInfoModel *orderInfo = nil;
                NSDictionary *resultData = [dict safeObjectForKey:@"data"];
                
                orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
                VV_SHDAT.orderInfo = orderInfo;
                
                VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
                VV_SHDAT.creditBaseInfoModel = baseInfoModel;
                
                JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
                VV_SHDAT.authenticationModel = authenticationModel;
                VV_SHDAT.mobileInitModel.nextProCode = @"";

                if([VV_SHDAT.orderInfo.applyStatusCode integerValue] == applyTypeZhimaScore){
                    [self setupZhimaView];
                }else{
                    if ([_loanMobileViewDelagate respondsToSelector:@selector(postMobileNextStep:)]) {
                        [_loanMobileViewDelagate postMobileNextStep:VV_SHDAT.orderInfo.applyStatusCode];
                    }
                }
        }else{
            [MBProgressHUD showError:[dict objectForKey:@"message"]];
        }

    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

#pragma mark       手机验证  扫描身份证 身份认证 UI
//   手机验证  首页 登录 ui
- (void)showMobileNextView:(BOOL)isModification{
    [_baseScrollView removeFromSuperview];
    
//    VV_SHDAT.orderInfo.applyStatusCode = @"15";
    [self setupscrollView];
    if ([VV_SHDAT.orderInfo.applyStatusCode integerValue] == applyTypeZhimaScore) {
        _baseScrollView.hidden = YES;
        return;
    }else{
        _baseScrollView.hidden = NO;
    }
    [_allTxtFieldArr removeAllObjects];
    
    _mobileVerCode = (VV_IS_NIL(VV_SHDAT.mobileInitModel.VerCodeBase64) || [VV_SHDAT.mobileInitModel.VerCodeBase64 isEqualToString:@"none"] )?@"":VV_SHDAT.mobileInitModel.VerCodeBase64;
    
    if (!_authenticationModle) {
        _authenticationModle = [[JJAuthenticationModel alloc]init];
    }
    
    //顺序不可变
    NSArray * textFieldArr = @[@{@"left":@"姓名",@"placeholder":@"拍摄身份证正面照自动识别",@"right":@"",@"enabled":@"YES",@"type":@"name"}, //index 0
                               @{@"left":@"身份证",@"placeholder":@"拍摄身份证正面照自动识别",@"right":@"recognizeIDCardNum",@"enabled":@"YES",@"type":@"idCard"},//index 1
                               @{@"left":@"手机号",@"placeholder":@"请输入实名制手机号",@"right":@"",@"enabled":@"YES",@"type":@"mobileNum"},//index 2
                               @{@"left":@"手机服务密码",@"placeholder":@"请输入手机服务密码",@"right":@"btn_忘记密码",@"enabled":@"YES",@"type":@"mobilePassword"},//index 3
                               @{@"left":@"短信验证码",@"placeholder":@"请输入验证码",@"right":@"smsCode",@"enabled":@"YES",@"type":@"mobileSMSCode"}, //index 4 //不带发送短信验证码按钮
                               @{@"left":@"查询码",@"placeholder":@"输入查询码",@"right":@"queryMobileCode",@"enabled":@"YES",@"type":@"mobileQueryCode"}, //index 5
                               @{@"left":@"手机验证码",@"placeholder":@"请输入验证码",@"right":@"sendSmsMobileCode",@"enabled":@"YES",@"type":@"mobileSMSCode"},//index 6
                               @{@"left":@"验证码",@"placeholder":@"输入验证码",@"right":@"imageview",@"enabled":@"YES",@"type":@"mobileImageVerCode"},//index 7
                               
                               ];
    
    NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:1];
    
    if ( VV_IS_NIL(_mobileNextProCode)) {
        [mutableArr addObjectsFromArray:@[textFieldArr[0],textFieldArr[1],textFieldArr[2]]];
    
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
    
    CGFloat idWeight = (kScreenWidth-24)/2;
    
    _frontIdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, idWeight-12, 96)];
    [_baseScrollView addSubview:_frontIdImageView];
    [_frontIdImageView setUserInteractionEnabled:YES];
    self.frontIdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _frontIdImageView.width, _frontIdImageView.height)];
    self.frontIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.0];
    UIImageView * resetFrontPhoto = [[UIImageView alloc]initWithImage:VV_GETIMG(@"btn_reset_photo")];
    resetFrontPhoto.centerX = self.frontIdView.centerX;
    resetFrontPhoto.centerY = self.frontIdView.centerY;
    resetFrontPhoto.hidden = YES;
    [self.frontIdView addSubview: resetFrontPhoto];
    self.resetFrontPhoto = resetFrontPhoto;
    _frontLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _frontIdImageView.height-22, _frontIdImageView.width, 22)];
    [_frontIdImageView addSubview:_frontLabel];
    [_frontIdImageView addSubview:self.frontIdView];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFrontIdPhotoImage)];
    [self.frontIdView addGestureRecognizer:tap1];

    _backIdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12,CGRectGetMaxY(_frontIdImageView.frame)+12, idWeight-12, 96)];
    [_baseScrollView addSubview:_backIdImageView];
    [_backIdImageView setUserInteractionEnabled:YES];
    self.backIdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _backIdImageView.width, _backIdImageView.height)];
    self.backIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.0];
    UIImageView * resetBackPhoto = [[UIImageView alloc]initWithImage:VV_GETIMG(@"btn_reset_photo")];
    resetBackPhoto.centerX = self.backIdView.centerX;
    resetBackPhoto.centerY = self.backIdView.centerY;
    resetBackPhoto.hidden = YES;
    [self.backIdView addSubview: resetBackPhoto];
    self.resetBackPhoto = resetBackPhoto;
    _backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _backIdImageView.height-22, _backIdImageView.width, 22)];
    [_backIdImageView addSubview:_backLabel];
    [_backIdImageView addSubview:self.backIdView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackIdPhotoImage)];
    [self.backIdView addGestureRecognizer:tap2];
    
    _handImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12+idWeight, 12, idWeight, 204)];
    [_baseScrollView addSubview:_handImageView];
    [_handImageView setUserInteractionEnabled:YES];
    self.handIdView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _handImageView.width, _handImageView.height)];
    self.handIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.0];
    UIImageView * resetHandPhoto = [[UIImageView alloc]initWithImage:VV_GETIMG(@"btn_reset_photo")];
    resetHandPhoto.centerX = self.handIdView.centerX;
    resetHandPhoto.centerY = self.handIdView.centerY;
    resetHandPhoto.hidden = YES;
    [self.handIdView addSubview: resetHandPhoto];
    self.resetHandPhoto = resetHandPhoto;
    _handLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _handImageView.height-22, _handImageView.width, 22)];
    [_handImageView addSubview:_handLabel];
    [_handImageView addSubview:self.handIdView];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandIdPhotoImage)];
    [self.handIdView addGestureRecognizer:tap3];
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, _backIdImageView.bottom+10, kScreenWidth, 20)];
    backView.backgroundColor = VV_COL_RGB(0xdddddd);
    [_baseScrollView addSubview:backView];
    self.backView = backView;
    
    __block CGFloat rectHeight = 0;
    __block CGFloat backViewBottom  = self.backView.bottom;
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
            
            UIButton *modifyNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            modifyNameBtn.frame =  CGRectMake(kScreenWidth-55,backViewBottom +idx*44 , 46, 46);
            modifyNameBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [modifyNameBtn setTitle:@"修改" forState:UIControlStateNormal];
            [modifyNameBtn setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
            [modifyNameBtn setTitleColor:[UIColor unableButtonThemeColor] forState:UIControlStateHighlighted];
            [modifyNameBtn addTarget:self  action:@selector(modifyName) forControlEvents:UIControlEventTouchUpInside];
            [_baseScrollView addSubview:modifyNameBtn];
            [_baseScrollView bringSubviewToFront:modifyNameBtn];
            self.modifyNameBtn = modifyNameBtn;
            
        }else if ([type isEqualToString:@"idCard"]){
            _authenIdCardField= textfield;
            
            UIButton *modifyIDcardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            modifyIDcardBtn.frame =  CGRectMake(kScreenWidth-55,backViewBottom +idx*44 , 46, 46);
            modifyIDcardBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [modifyIDcardBtn setTitle:@"修改" forState:UIControlStateNormal];
            [modifyIDcardBtn setTitleColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
            [modifyIDcardBtn setTitleColor:[UIColor unableButtonThemeColor] forState:UIControlStateHighlighted];
            [modifyIDcardBtn addTarget:self  action:@selector(takePhotoForIDcard) forControlEvents:UIControlEventTouchUpInside];
            [_baseScrollView addSubview:modifyIDcardBtn];
            [_baseScrollView bringSubviewToFront:modifyIDcardBtn];
            self.modifyIDcardBtn = modifyIDcardBtn;
            
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
    
    if (!VV_IS_NIL(_authenticationModle.idcardImageObverseBase64)) {
        [self showIdCardViewType:@"updataSuccess" view:_frontIdImageView lable:_frontLabel];
    }else{
        [self showIdCardViewType:@"updataDefault" view:_frontIdImageView lable:_frontLabel];
    }
    
    if (!VV_IS_NIL(_authenticationModle.idcardImageReverseBase64)) {
        [self showIdCardViewType:@"updataSuccess" view:_backIdImageView lable:_backLabel];
    }else{
        [self showIdCardViewType:@"updataDefault" view:_backIdImageView lable:_backLabel];
    }
    
    if (!VV_IS_NIL(_authenticationModle.faceBase64)){
        [self showIdCardViewType:@"updataSuccess" view:_handImageView lable:_handLabel];
    }else{
        [self showIdCardViewType:@"updataDefault" view:_handImageView lable:_handLabel];
    }
    
    _authenNameField.enabled = NO;
    _authenIdCardField.enabled = NO;
    _modifyNameBtn.hidden = YES;
    _modifyIDcardBtn.hidden = YES;

    if (isModification) {
        _authenNameField.text = @"";
        _authenIdCardField.text = @"";
        _mobileNumField.text = @"";
        [self showIdCardViewType:@"updataDefault" view:_frontIdImageView lable:_frontLabel];
        [self showIdCardViewType:@"updataDefault" view:_backIdImageView lable:_backLabel];
        [self showIdCardViewType:@"updataDefault" view:_handImageView lable:_handLabel];
    }else{
        _authenNameField.text = VV_IS_NIL(VV_SHDAT.orderInfo.applicantName) ? @"":VV_SHDAT.orderInfo.applicantName;
        _authenIdCardField.text = VV_IS_NIL(VV_SHDAT.orderInfo.applicantIdcard)?@"":VV_SHDAT.orderInfo.applicantIdcard;
        _mobileNumField.text = VV_IS_NIL(VV_SHDAT.orderInfo.mobile)?@"":VV_SHDAT.orderInfo.mobile;
    }
    
    _nextBtn = [VVCommonButton solidButtonWithTitle:@"下一步"];
    _nextBtn.frame = CGRectMake(VVleftMargin, rectHeight+60, kScreenWidth-VVleftMargin*2, VVBtnHeight);
    [_nextBtn addTarget:self action:@selector(mobileNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:_nextBtn];
    [_nextBtn setUserInteractionEnabled:NO];
    [_baseScrollView addSubview:_nextBtn];
    _baseScrollView.frame = CGRectMake(0, 0, kScreenWidth, _nextBtn.y+50);
    self.height = _baseScrollView.height;
    _controller.scrollView.contentSize = CGSizeMake(vScreenWidth, self.bottom);
    
    [self showMobileBtnStatues];
}

//修改姓名
-(void)modifyName{
    [self modifyNameAlertView];
}

//身份证重新拍照
-(void)takePhotoForIDcard{
    [self modifyIDcardAlertView];
}

/**
 * 3. 用户点击取消按钮后的响应事件 */
- (void)onCancelCapture {
    [_controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  身份证拍照
- (void)tapFrontIdPhotoImage{
    //正面拍照
    if (![VVCommonFunc isAVAuthorizationStatus]) {
        return;
    }
    idCardType = IDCARD_FRONT;
    [self showIdCradRemind:IDCARD_FRONT];
}

- (void)tapBackIdPhotoImage{
    //反面拍照
    if (![VVCommonFunc isAVAuthorizationStatus]) {
        return;
    }
    idCardType = IDCARD_BACK;
    [self showIdCradRemind:IDCARD_BACK];
}


 /**
  手持身份证
  */
 - (void)cardInHand
 {
     UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 206)];
     customView.backgroundColor = [UIColor clearColor];
     
     UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 24, 105, 112)];
     imageview.centerX = customView.centerX;
     imageview.image = [UIImage imageNamed:@"Bitmap"];
     [customView addSubview:imageview];
     
     UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), kScreenWidth, 94)];
     lab.textColor = VVColor(51, 51, 51);
     lab.font = [UIFont systemFontOfSize:14];
     lab.numberOfLines = 0;
     lab.attributedText = [self shootRichText];
     lab.textAlignment = NSTextAlignmentCenter;
     [customView addSubview:lab];
     
     [VVAlertUtils showAlertViewWithTitle:@"拍照示例" message:nil customView:customView cancelButtonTitle:@"确定" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
     VVAVCaptureSessionViewController  *avcapSesion = [[VVAVCaptureSessionViewController alloc]init];
     avcapSesion.delegate = self;
     avcapSesion.pictureKind = KKIDInHand;
     [_controller customPushViewController:avcapSesion withType:nil subType:nil];
     }];
 }

- (void)tapHandIdPhotoImage
{
    if(VV_IS_NIL(_authenticationModle.idcardImageObverseBase64))
    {
        [VVAlertUtils showAlertViewWithTitle:@"提示"
                                     message:@"请先拍摄身份证正面照"
                                  customView:nil
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil
                                         tag:0
                               completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex)
        {
            [alertView hideAnimated:YES];
        }];

        return;
    }
    
    if (![VVCommonFunc isAVAuthorizationStatus]) {
        return;
    }
    
    if ([self isSpeedVersion])
    {
        [self livenessDetection];
    }
    else
    {
        [self cardInHand];
    }
}

/**
 活体识别AlertCustomView
 */
- (UIView *)livenessAlertCustomView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 360)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 132, 132)];
    imageview.centerX = customView.centerX;
    imageview.image = [UIImage imageNamed:@"img_lmlgou"];
    [customView addSubview:imageview];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), kScreenWidth, 50)];
    lab.textColor = kColor_NormalColor;
    lab.font = kFont_TipTitle;
    
    NSString *string = @"头部外轮廓在虚线里面\n面部轮廓清晰可见";
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineHeightMultiple = 1.2;//行间距是多少倍
    [attriString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attriString.length)];
    
    lab.numberOfLines = 0;
    lab.attributedText = attriString;
    lab.textAlignment = NSTextAlignmentCenter;

    [customView addSubview:lab];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 196, kScreenWidth, 60)];
    lab1.textColor = VVColor(51, 51, 51);
    lab1.font = kFont_TipTitle;
    lab1.numberOfLines = 0;
    lab1.attributedText = [self shootRichText];
    lab1.textAlignment = NSTextAlignmentCenter;
    [customView addSubview:lab1];
    
    
    NSArray *titleAry = @[@"太近",@"太远",@"太亮"];
    NSArray *imgAry = @[@"img_lmltj",@"img_lmlty",@"img_lmltll"];
    
    float imgCenterX = self.centerX;
    
    //各个图片之间的空隙
    float space = (270-3*78)/4.0;
    
    for (int i = 0; i < imgAry.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(imgAry[i])];
        [customView addSubview:img];
        
        switch (i) {
            case 0:
            {
                img.frame = CGRectMake(imgCenterX-78/2.0-space-78, CGRectGetMaxY(lab.frame)+60, 78, 78);
            }
                break;
            case 1:
            {
                img.frame = CGRectMake(imgCenterX-78/2.0, CGRectGetMaxY(lab.frame)+60, 78, 78);
            }
                break;
            case 2:
            {
                img.frame = CGRectMake(imgCenterX+78/2.0+space, CGRectGetMaxY(lab.frame)+60, 78, 78);
            }
                break;
            default:
                break;
        }
        
        UILabel *tipLab = [[UILabel alloc] init];
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.text = titleAry[i];
        tipLab.frame = CGRectMake(CGRectGetMinX(img.frame), CGRectGetMaxY(img.frame), 78, 28);
        tipLab.textColor = kColor_NormalColor;
        tipLab.font = kFont_TipTitle;
        [customView addSubview:tipLab];
    }
    
    return customView;
}

/**
 活体识别
 */
- (void)livenessDetection
{
    [VVAlertUtils showAlertViewWithTitle:@"人脸识别"
                                 message:nil
                              customView:[self livenessAlertCustomView]
                       cancelButtonTitle:@"我明白了"
                       otherButtonTitles:nil
                                     tag:0
                           completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex)
    {
        OliveappLivenessDetectionViewController *instance = (OliveappLivenessDetectionViewController *)[[UIStoryboard storyboardWithName:@"LivenessDetection" bundle:nil] instantiateViewControllerWithIdentifier:@"LivenessDetectionStoryboard"];
        [instance setConfigLivenessDetection:self withMode:FLUENT_CHANGE withError:nil];
        [self.controller presentViewController:instance animated:YES completion:nil];
    }];
}

#pragma mark - VVAVCaptureSessionViewController  delegate

- (void)useImageData:(NSData *)imageData withPictureKind:(PictureKind)pictureKind{
    UIImage *image = [UIImage imageWithData:imageData];
    if (pictureKind != KKIDInHand) {
        image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
    }
    
    NSString *base64ImageStr = [imageData base64EncodedStringWithOptions:0];
    
    if (VV_IS_NIL(base64ImageStr)) {
        [VLToast showWithText:@"上传图片为空，请重新选择"];
        _authenticationModle.faceBase64 = nil;
        [self showIdCardViewType:@"updataDefault" view:_handImageView lable:_handLabel];
        return;
    }
    if (pictureKind == KKIDInHand) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _handImageView.image = image;
            _handImage = base64ImageStr;
        });
        
        [self postScanIdCardNumWithBase64:base64ImageStr type:IDCARD_HAND success:^(id result)
        {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)showIdCradRemind:(DatabaseImageCaptureMode)pictureKind{
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 206)];
    customView.backgroundColor = [UIColor clearColor];

    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 34, 228, 112)];
    imageview.centerX = customView.centerX;
    [customView addSubview:imageview];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame)+28, kScreenWidth, 40)];
    lab.textColor = VVColor(51, 51, 51);
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"确保照片清晰\n以免影响您的额度审批";
    lab.numberOfLines = 2;
    [customView addSubview:lab];
    
    if (pictureKind == IDCARD_FRONT) {
        imageview.image = VV_GETIMG(@"frontIDcard");
    }else if (pictureKind == IDCARD_BACK){
        imageview.image = VV_GETIMG(@"backIDcard");
    }
    else if (pictureKind == IDCARD_HAND) {
        imageview.image = VV_GETIMG(@"Bitmap");
    }
    [VVAlertUtils showAlertViewWithTitle:@"拍照示例" message:nil customView:customView cancelButtonTitle:@"确定" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        OliveappCaptureDatabaseImageViewController * captureRecentPhotoViewController;
        
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"RegistrationPage" bundle: nil];
        captureRecentPhotoViewController = (OliveappCaptureDatabaseImageViewController *) [board instantiateViewControllerWithIdentifier: @"CaptureIDCardStoryboard"];
        //打开拍摄登记照页面
        __weak typeof(self) weakSelf = self;
        [captureRecentPhotoViewController startDatabaseImageCapture:weakSelf
                                                    withCaptureMode:pictureKind];
        [_controller presentViewController:captureRecentPhotoViewController animated:YES completion:nil];
    }];
}

/**
 *  捕获到合格的登记照片时的回调函数
 *
 *  @param imageContent 图片内容。如需网络传输，请调用UIImageJPEGRepresentation(imageContent, 0.7)
 *  @param face 检测到的人脸信息。如果为nil表示未检测到或检测到多张人脸
 *  @param error 错误信息
 */

- (void)onDatabaseImageTaken: (UIImage*) imageContent
             withDetectedFace: (OliveappFaceRect*) face
                    withError: (NSError *) error {
    //如果捕获到人脸(合格的照片)
    //       UIImage *  image = [UIImage imageWithCGImage:imageContent.CGImage scale:1 orientation:UIImageOrientationLeft];
    if (idCardType != 3) {
        imageContent = [imageContent compressWithWidth:500];
    }

    NSData *data = UIImageJPEGRepresentation(imageContent, .5f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
    
    if (VV_IS_NIL(encodedImageStr)) {
        [VLToast showWithText:@"上传图片为空，请重新选择"];
        return;
    }
    
    switch (idCardType) {
        case 1:
        {
            //身份证正面照片
            if (!face) {
                _authenticationModle.idcardImageObverseBase64 = nil;
                [self textFieldDidChangeNotification:nil];    //身份证本地校验监听
                [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"正面身份证解析失败，请重新拍摄" customView:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    [alertView hideAnimated:YES];
                }];
                _authenNameField.text = nil;
                _authenIdCardField.text = nil;
                _modifyNameBtn.hidden = YES;
                _modifyIDcardBtn.hidden = YES;
                [_controller dismissViewControllerAnimated:YES completion:nil];
                [self showIdCardViewType:@"updataDefault" view:_frontIdImageView lable:_frontLabel];
                return;

            }else{
                VVLog(@" 正面=image length=======%f kb",data.length/1024.0);
                UIImage *image = [UIImage imageWithData:data];
                VVLog(@"正面=image%@",image);
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    _frontIdImageView.image = imageContent;
                    _idcardImageObverse = encodedImageStr;
                });
                
                [self postScanIdCardNumWithBase64:encodedImageStr type:IDCARD_FRONT success:^(id result) {
                    VVLog(@" 正面=image length=======%f kb",data.length/1024.0);
                    

                } failure:^(NSError *error) {
                    
                }];
            }
        }
            break;
        case 2:
        {
            //身份证背面照片
            VVLog(@" 反面=image length=======%f kb",data.length/1024.0);
            UIImage *image = [UIImage imageWithData:data];
            VVLog(@"反面=image%@",image);
            //反面拍照
            dispatch_async(dispatch_get_main_queue(), ^{
                _backIdImageView.image = imageContent;
                _idcardImageReverse = encodedImageStr;
            });
            [self showIdCardViewType:@"updataLoading" view:_backIdImageView lable:_backLabel];
            
            [self postScanIdCardNumWithBase64:encodedImageStr type:IDCARD_BACK success:^(id result) {
                
                VVLog(@" 反面=image length=======%f kb",data.length/1024.0);
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case 3:
        {

        }
            break;
        default:
            break;
    }
    
    [_controller dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  身份证地址确认弹窗
 */
- (void)showAddressAlertViewWithTitle:(NSString *)title
{
//    [VVAlertUtils showAlertViewWithTitle:@"您身份证地址为：" message:_idCardModel.address
//                              customView:nil
//                       cancelButtonTitle:nil
//                       otherButtonTitles:@[@"修改",@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                           if (buttonIndex == 0) {
//                               [self modifyAddressAlertView];
//                           }
//                           [alertView hideAnimated:YES];
//                       }];
//    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title
                                                                              message:_idCardModel.address
                                                                       preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self modifyAddressAlertView];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [self.controller presentViewController:alertController animated:YES completion:nil];
    
}

/**
 *  姓名身份证确认弹窗
 */
-(void)confirmNameAndIDNumAlertWithTitle:(NSString*)title Message:(NSString*)message handler:(void(^)())handler{
    
    NSMutableAttributedString *titleAttributed = [[NSMutableAttributedString alloc]initWithString:title];
    [titleAttributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:NSMakeRange(0,title.length)];
    NSMutableAttributedString *messageAttributed = [[NSMutableAttributedString alloc]initWithString:message];
    [messageAttributed addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, message.length )];
    
    UIAlertController *altCon = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [altCon setValue:titleAttributed forKey:@"attributedTitle"];
    [altCon setValue:messageAttributed forKey:@"attributedMessage"];
    
    [altCon addAction:[UIAlertAction actionWithTitle:@"立即修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [altCon addAction:[UIAlertAction actionWithTitle:@"确认无误" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }]];
    [self.controller presentViewController:altCon animated:YES completion:nil];
    
}

/**
 *  修改身份证弹窗
 */
- (void)modifyIDcardAlertView
{
    NSString *IDcardStr = _authenIdCardField.text;
    self.modifyIDcardAlertController = [UIAlertController alertControllerWithTitle:@"身份证修改"
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    [self.modifyIDcardAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = IDcardStr;
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:14];
        _modifyIDcardField = textField;
    }];
    __weak __typeof(self)weakSelf = self;
    self.modifyIDcardSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *textfields = self.modifyIDcardAlertController.textFields;
            UITextField *IDcardTextfild = textfields[0];
            _authenIdCardField.text = IDcardTextfild.text;
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showMobileBtnStatues];
      
    }];
    [_modifyIDcardField addTarget:self action:@selector(listenIDcardTextFieldMethod:) forControlEvents:UIControlEventEditingChanged];
    
    [self.modifyIDcardAlertController addAction:self.modifyIDcardSureAction];
    [self.controller presentViewController:self.modifyIDcardAlertController animated:YES completion:nil];
    
}

/**
 *  修改姓名弹窗
 */
- (void)modifyNameAlertView
{
    NSString *nameStr = _authenNameField.text;
    self.modifyNameAlertController = [UIAlertController alertControllerWithTitle:@"姓名修改"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    [self.modifyNameAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = nameStr;
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:14];
        _modifyNameField = textField;
    }];
    
    __weak __typeof(self)weakSelf = self;
    self.modifyNameSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textfields = self.modifyNameAlertController.textFields;
        UITextField *nameTextfild = textfields[0];
        _authenNameField.text = nameTextfild.text;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showMobileBtnStatues];
    }];
    [_modifyNameField addTarget:self action:@selector(listenNameTextFieldMethod:) forControlEvents:UIControlEventEditingChanged];

    [self.modifyNameAlertController addAction:self.modifyNameSureAction];
    [self.controller presentViewController:self.modifyNameAlertController animated:YES completion:nil];
}


/**
 *  修改身份证地址弹窗
 */
- (void)modifyAddressAlertView
{
    NSString *addressStr = _idCardModel.address;
    self.modifyAddressAlertController = [UIAlertController alertControllerWithTitle:@"修改身份证地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self.modifyAddressAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = addressStr;
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:14];
        _modifyAddressField = textField;
    }];
    
    __weak __typeof(self)weakSelf = self;
    self.modifyAddressSureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * textfields = self.modifyAddressAlertController.textFields;
        UITextField * addressfield = textfields[0];
        _idCardModel.address = addressfield.text;
        [self showAddressAlertViewWithTitle:@"您身份证地址修改为："];
        _authenticationModle.householdAddr = _idCardModel.address;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showMobileBtnStatues];
    }];
    
    //capturing 'self'strong in this block is likely to lead to a retain cycle
    [_modifyAddressField addTarget:self action:@selector(listenTextFieldMethod:) forControlEvents:UIControlEventEditingChanged];
    
    [self.modifyAddressAlertController addAction:self.modifyAddressSureAction];
    [self.controller presentViewController:self.modifyAddressAlertController animated:YES completion:nil];
}

-(void)listenIDcardTextFieldMethod:(UITextField*)field{

}

- (void)listenNameTextFieldMethod:(UITextField*)field{
    if(field.text.length){
        self.modifyNameAlertController.view.tintColor = VVColor(0, 118, 255);
        self.modifyNameSureAction.enabled = YES;
    }else{
        self.modifyNameAlertController.view.tintColor = VVColor(153, 153, 153);
        self.modifyNameSureAction.enabled = NO;
    }
}

- (void)listenTextFieldMethod:(UITextField *)field
{
    if (field.text.length)
    {
        self.modifyAddressAlertController.view.tintColor = VVColor(0, 118, 255);
        self.modifyAddressSureAction.enabled = YES;
    }
    else
    {
        self.modifyAddressAlertController.view.tintColor = VVColor(153, 153, 153);
        self.modifyAddressSureAction.enabled = NO;
    }
}

#pragma mark 拍照前后 imageview  显示状态
- (void)showIdCardViewType:(NSString *)type  view:(UIImageView *)imageView lable:(UILabel *)lable{
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = VVWhiteColor;
    imageView.layer.borderColor = VVclearColor.CGColor;
    imageView.layer.cornerRadius = 10;
    imageView.layer.borderWidth = 1.0;
    imageView.layer.masksToBounds = YES;
    
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:14.0];
    
    if ([type isEqualToString:@"updataSuccess"]||[type isEqualToString:@"updataLoading"]) {
        imageView.layer.borderColor = VVBASE_OLD_COLOR.CGColor;
        imageView.contentMode =  UIViewContentModeScaleToFill;
        imageView.clipsToBounds = YES;
        lable.top = imageView.height-22;
        lable.backgroundColor = VV_COL_RGB(0x000000);
        lable.alpha = 0.5;
        lable.textColor = VVWhiteColor;
        if ([type isEqualToString:@"updataSuccess"]){
            
            if (imageView == _frontIdImageView) {
                lable.text = @"正面上传成功";
                if (VV_IS_NIL(_authenticationModle.idcardImageObverseBase64)) {
                    imageView.contentMode =  UIViewContentModeCenter;
                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                          
                            imageView.image = VV_GETIMG(@"img_obverse_ok");
                            imageView.contentMode = UIViewContentModeScaleAspectFill;
                        });
                    
                }else  {
                        self.resetFrontPhoto.hidden = NO;
                        self.frontIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.2];
                        imageView.image = [UIImage imageWithData:[NSData base64DataFromString:_authenticationModle.idcardImageObverseBase64]];
                }
                [self textFieldDidChangeNotification:nil];

            }else if(imageView == _backIdImageView){
                lable.text = @"反面上传成功";
                if (VV_IS_NIL(_authenticationModle.idcardImageReverseBase64)){
                    imageView.contentMode =  UIViewContentModeCenter;
              
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            imageView.image = VV_GETIMG(@"img_reverse_ok");
                            imageView.contentMode = UIViewContentModeScaleAspectFill;
                        });

                }else  {
                        self.resetBackPhoto.hidden = NO;
                        self.backIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.2];
                        imageView.image = [UIImage imageWithData:[NSData base64DataFromString:_authenticationModle.idcardImageReverseBase64]];
                }
                [self textFieldDidChangeNotification:nil];
                
            }else if (imageView == _handImageView) {
                
                if ([self isSpeedVersion])
                {
                    lable.text = @"活体识别成功";
                }
                else
                {
                    lable.text = @"手持身份照上传成功";
                }
                
                if (VV_IS_NIL(_authenticationModle.faceBase64)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        
                        if ([self isSpeedVersion])
                        {
                            imageView.image = VV_GETIMG(@"img_huotishibie_ok");
                        }
                        else
                        {
                            imageView.image = VV_GETIMG(@"img_handon_ok");
                        }
                        
                        });

                }else  {
                        self.resetHandPhoto.hidden = NO;
                        self.handIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.2];
                        imageView.image = [UIImage imageWithData:[NSData base64DataFromString:_authenticationModle.faceBase64]];
                }
                [self textFieldDidChangeNotification:nil];

            }
        }
        
        [self setByRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight view:lable];
        
    }else if([type isEqualToString:@"updataDefault"]){
        imageView.contentMode =  UIViewContentModeScaleToFill;

        lable.top = imageView.height-22;
        
        if (imageView == _frontIdImageView) {
            lable.text = @"请拍摄身份证正面";
            imageView.image = [UIImage imageNamed:@"imgIDcardPositive"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.resetFrontPhoto.hidden = YES;
            self.frontIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.0];

        }else if(imageView == _backIdImageView){
            lable.text = @"请拍摄身份证反面";
            imageView.image = [UIImage imageNamed:@"imgIDcardReverse"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.resetBackPhoto.hidden = YES;
            self.backIdView.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.0];
        }
        else if (imageView == _handImageView)
        {
            if ([self isSpeedVersion])
            {
                lable.text = @"活体识别";
                imageView.image = [UIImage imageNamed:@"img_huotishibie"];
            }
            else
            {
                lable.text = @"请拍摄手持身份证照";
                imageView.image = [UIImage imageNamed:@"imgHandIDcard"];
            }
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.resetHandPhoto.hidden = YES;
            self.resetHandPhoto.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:0.0];
        }
        
        [self textFieldDidChangeNotification:nil];
        [self setByRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight view:lable];
        
        lable.alpha = 1;
        lable.backgroundColor = VVclearColor;
        lable.textColor = VVWhiteColor;

    }
    
}

- (void)setByRoundingCorners:(UIRectCorner)rectCorner view:(UIView *)view{
    UIBezierPath *maskPath = nil;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners: rectCorner cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

-(void)postScanIdCardNumWithBase64:(NSString*)base64
                              type:(DatabaseImageCaptureMode)pictureKind
                           success:(void (^)(id))success
                           failure:(void (^)(NSError *))failure
{
    
    NSDictionary *parma  = @{@"IdcardImageBase64":VV_IS_NIL(base64)?@"":base64};
    __weak __typeof(self)weakSelf = self;
    switch (pictureKind) {
        case IDCARD_FRONT:
        {
            [_controller showHud];
            [[VVNetWorkUtility netUtility]postOrdersScanIdObverseWithOrderId:nil parameters:parma success:^(id result) {
                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.controller hideHud];
                
                [strongSelf resultSuccesstype:IDCARD_FRONT Base64:base64 result:result];
                
            } failure:^(NSError *error) {
                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.controller hideHud];
                _authenticationModle.idcardImageObverseBase64 = nil;
                [strongSelf showIdCardViewType:@"updataDefault" view:_frontIdImageView lable:_frontLabel];
                [strongSelf resultFailuer:error];
                
            }];
        }
            break;
        case IDCARD_BACK:
        {
            [_controller showHud];
            [[VVNetWorkUtility netUtility]postOrdersScanIdReverseWithOrderId:nil parameters:parma success:^(id result) {
                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.controller hideHud];
                
                [strongSelf resultSuccesstype:IDCARD_BACK Base64:base64 result:result];
                
            } failure:^(NSError *error) {
                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.controller hideHud];
                _authenticationModle.idcardImageReverseBase64 = nil;
                [strongSelf showIdCardViewType:@"updataDefault" view:_backIdImageView lable:_backLabel];
                [strongSelf resultFailuer:error];
            }];
        }
            break;
        case IDCARD_HAND:
        {
            //手持身份证
            NSDictionary *handParma = @{
                                        @"customerId":[UserModel currentUser].customerId,
                                        @"facebase64":base64,
                                        @"idcardImageObverseBase64":_authenticationModle.idcardImageObverseBase64,
                                        @"type":@(200)
                                        };
            
            [_controller showHud];
            
            [[VVNetWorkUtility netUtility] postApplySpeedFaceRecognitionWithparameters:handParma
                                                                               success:^(id result)
            {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.controller hideHud];
                
                [strongSelf resultSuccesstype:IDCARD_HAND Base64:base64 result:result];
            } failure:^(NSError *error)
            {
                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                 [strongSelf.controller hideHud];
                 _authenticationModle.faceBase64 = nil;
                 [strongSelf showIdCardViewType:@"updataDefault" view:_handImageView lable:_handLabel];
                 [strongSelf resultFailuer:error];
                
            }];
            
        }
            break;
        default:
            break;
    }
    
}


- (void)resultSuccesstype:(DatabaseImageCaptureMode)pictureKind
                   Base64:(NSString*)base64
                   result:(NSDictionary *)result{
    
    [_controller hideHud];
    if ([[result safeObjectForKey:@"success"] boolValue]) {
        
            NSDictionary *dic = [result safeObjectForKey:@"data"];
            if (pictureKind == IDCARD_FRONT) {
                
                if (dic.count >0 ) {
                    JJIDCardModel *idCardModel = [JJIDCardModel mj_objectWithKeyValues:dic];
                    _idCardModel = idCardModel;
                    _authenticationModle.idcardImageObverseBase64 = nil;
//                    [self textFieldDidChangeNotification:nil];   //身份证正面结果解析成功但数据不完全

                    [self showIdCardViewType:@"updataDefault" view:_frontIdImageView lable:_frontLabel];
                    if (VV_IS_NIL(idCardModel.address) || VV_IS_NIL(idCardModel.cardNo) || VV_IS_NIL(idCardModel.name)) {
                        [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"正面身份证解析不完全，请重新拍摄" customView:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                            [alertView hideAnimated:YES];
                        }];
                    }else{
                        
                        [self showAddressAlertViewWithTitle:@"您身份证地址为："];
                        
                        NSString *householdAddr = [dic safeObjectForKey:@"address"];
                        NSString *idCardNo = [dic safeObjectForKey:@"cardNo"];
                        NSString *name = [dic safeObjectForKey:@"name"];
                        _authenticationModle.householdAddr = householdAddr;
                        _authenticationModle.idcardNo = idCardNo;
                        _authenIdCardField.text = idCardNo;
                        _authenNameField.text = name;
                        _modifyNameBtn.hidden = NO;
                        _modifyIDcardBtn.hidden = NO;
                        _authenIdCardField.enabled = NO;
                        _authenNameField.enabled = NO;
                        _mobileNextProCode = @"";
                        _authenticationModle.idcardImageObverseBase64 = base64;
                        [self showIdCardViewType:@"updataSuccess" view:_frontIdImageView lable:_frontLabel];
//                        [self textFieldDidChangeNotification:nil];   //身份证返回结果正面成功
                    }
                }

            }else if (pictureKind == IDCARD_BACK){
                
                     _mobileNextProCode = @"";
                    _authenticationModle.idcardImageReverseBase64 = base64;
                    [self showIdCardViewType:@"updataSuccess" view:_backIdImageView lable:_backLabel];
                
//                    [self textFieldDidChangeNotification:nil];      //身份证返回结果反面监听
            }
        else if (pictureKind == IDCARD_HAND)
        {
            _mobileNextProCode = @"";
            
            if ([self isSpeedVersion])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _handImageView.image = [UIImage base64ToImage:[result safeObjectForKey:@"data"]];
                    _handImage = [result safeObjectForKey:@"data"];
                });
                _authenticationModle.faceBase64 = [result safeObjectForKey:@"data"];
            }
            else
            {
                _authenticationModle.faceBase64 = base64;
            }
            
            [self showIdCardViewType:@"updataSuccess" view:_handImageView lable:_handLabel];
        }
        
    }else{
            if (!VV_IS_NIL(result[@"message"])) {
                [VVAlertUtils showAlertViewWithTitle:@"提示" message:result[@"message"] customView:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    [alertView hideAnimated:YES];
                }];
                
                if (pictureKind == IDCARD_FRONT){
                    _authenticationModle.idcardImageObverseBase64 = nil;
                    [self showIdCardViewType:@"updataDefault" view:_frontIdImageView lable:_frontLabel];
                }else if(pictureKind == IDCARD_BACK){
                   _authenticationModle.idcardImageReverseBase64 = nil;
                    [self showIdCardViewType:@"updataDefault" view:_backIdImageView lable:_backLabel];
                }
                else if (pictureKind == IDCARD_HAND)
                {
                    _authenticationModle.faceBase64 = nil;
                    [self showIdCardViewType:@"updataDefault" view:_handImageView lable:_handLabel];
                }
//                [self textFieldDidChangeNotification:nil];   //身份证正反面失败监听

            }
    }
}


- (void)resultFailuer:(NSError *)error{
    [_controller hideHud];
    [_controller dismissViewControllerAnimated:YES completion:nil];
    [VLToast showWithText:[_controller strFromErrCode:error]];
}
#pragma mark  手机验证  按钮

//   手机验证  忘记服务密码
- (void)clickMobileFuwuPassword:(UIButton *)sender{
    [self endEditing:YES];
    
    [VVAlertUtils showAlertViewWithTitle:@"" message:nil
                              customView:[self customAlertViewSMS]
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                           
                       }];
    
}

#pragma mark - 拍摄的富文本提示

- (NSMutableAttributedString *)shootRichText
{
    NSString *string = [NSString stringWithFormat:@"拍摄时，请保持衣冠整洁，赤\n裸上身或露肩将会影响您的额\n度审批"];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:string];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7, 4)];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12, 5)];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(18,2)];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineHeightMultiple = 1.2;//行间距是多少倍
    [attriString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attriString.length)];
    
    return attriString;
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

//  手机验证 按钮点击事件  点击下一步
- (void)mobileNextBtn:(UIButton *)sender
{
    
    VVLog(@"VV_SHDAT.mobileInitModel ==========:%@",[VV_SHDAT.mobileInitModel mj_JSONObject]);

    [self endEditing:YES];
    if (![self checkoutPhoneNum:_mobile])
    {
        [VLToast showWithText:@"您输入的手机号不正确，请查验重新输入"];
        return;
    }
   
    if (VV_IS_NIL(_mobileNextProCode)) {

        if(![VVCommonFunc checkPaperId:_authenIdCardField.text]){
            [VLToast showWithText:@"身份证不合法，请重新修改"];
            return ;
        }
        
        NSString *title = @"身份证认证信息准确性直接关系到您的额度申请，请确认信息是否准确";
        NSString *message = [NSString stringWithFormat:@"%@\n%@",_authenNameField.text,_authenIdCardField.text];
        [self confirmNameAndIDNumAlertWithTitle:title Message:message handler:^{
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            __block BOOL ageIsRight = NO;
            
            __weak __typeof(self)weakSelf = self;
            [_controller showHud];
            [[VVNetWorkUtility netUtility] getUserIsAgeWithIdCardNo:_authenIdCardField.text
                                                            Success:^(id result)
             {
                     dispatch_group_leave(group);
                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                     [strongSelf.controller hideHud];
                 
                     if ([result[@"success"] integerValue] == 1)
                     {
                         ageIsRight = YES;
                     }
                     else
                     {
                         [self showBtithdayAlertView];
                     }
                 
                 } failure:^(NSError *error) {
                     dispatch_group_leave(group);
                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                     [strongSelf.controller hideHud];
                     [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];
                 }];
            
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    
                    if (!ageIsRight)
                    {
                        return ;
                    }
                    
    //                [self getAppCustInfoByWechat:^(BOOL succ) {
    //
    //                    if (succ) {
    //                        [MobClick event:@"home_conform_sync"];
    //                        if ([_syncWay isEqualToString:@"syncOver"]) {// "syncOver"代表后台已强制同步
    //
    //                            [MobClick event:@"home_allsame_over"];
    //                            [VVAlertUtils showAlertViewWithTitle:@"提示" message: _message customView:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
    //                                if ([_loanMobileViewDelagate respondsToSelector:@selector(returnToHomeViewController)]) {
    //                                    [_loanMobileViewDelagate returnToHomeViewController];
    //                                }
    //                            }];
    //
    //                        }else if ([_syncWay isEqualToString:@"syncCheck"]){//syncCheck"代表需要用户选择是否同步,并且返回微信端customerId,
    //
    //                            [VVAlertUtils showAlertViewWithTitle:@"" message:_message customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"取消",@"同步"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
    //                                if (buttonIndex  == 0) {//继续请求流程
    //                                    [alertView hideAlertViewAnimated:YES];
    //
    //                                    [MobClick event:@"home_idCardSame_no_sync"];
    ////                                    if (![self isSpeedVersion]) {
    ////                                        //支付宝实名
    ////                                        [self verificationAlipay:^(BOOL succ) {
    ////                                            if (succ) {
    ////                                                //身份证是否黑名单
    ////                                                [self verificationIdcard:^(BOOL succ) {
    ////                                                    if (succ) {
    ////                                                        [self initMobileInfo];
    ////                                                    }else{
    ////
    ////                                                    }
    ////                                                }];
    ////
    ////                                            }else{
    ////
    ////                                            }
    ////                                        }];
    ////                                    }else{
    //                                        [self verificationIdcard:^(BOOL succ) {
    //                                            if (succ) {
    //                                                [self initMobileInfo];
    //                                            }else{
    //
    //                                            }
    //                                        }];
    ////                                    }
    //
    //                                }else if (buttonIndex == 1){
    //                                    [self syncWechatCustInfoAppCustomerId:^(BOOL succ) {//用户去主动同步
    //                                        if (succ){
    //                                            [MobClick event:@"home_idCardSame_sync"];
    //                                            [alertView hideAlertViewAnimated:YES];
    //                                            if ([_loanMobileViewDelagate respondsToSelector:@selector(returnToHomeViewController)]) {
    //                                                [_loanMobileViewDelagate returnToHomeViewController];
    //
    //                                            }else{
    ////                                                if (![self isSpeedVersion]) {
    ////                                                    //支付宝实名
    ////                                                    [self verificationAlipay:^(BOOL succ) {
    ////                                                        if (succ) {
    ////                                                            //身份证是否黑名单
    ////                                                            [self verificationIdcard:^(BOOL succ) {
    ////                                                                if (succ) {
    ////                                                                    [self initMobileInfo];
    ////                                                                }else{
    ////
    ////                                                                }
    ////                                                            }];
    ////
    ////                                                        }else{
    ////
    ////                                                        }
    ////                                                    }];
    ////                                                }else{
    //                                                    //身份证是否黑名单
    //                                                    [self verificationIdcard:^(BOOL succ) {
    //                                                        if (succ) {
    //                                                            [self initMobileInfo];
    //                                                        }else{
    //
    //                                                        }
    //                                                    }];
    ////                                                }
    //                                            }
    //                                        }
    //                                    }];
    //                                }
    //                            }];
    //
    //                        }else{
    //
    //                        }
    //
    //                    }else{   //如果更新接口失败继续流程
    //
    ////                         if (![self isSpeedVersion]) {
    ////                             //支付宝实名
    ////                             [self verificationAlipay:^(BOOL succ) {
    ////                                 if (succ) {
    ////                                     //身份证是否黑名单
    ////                                     [self verificationIdcard:^(BOOL succ) {
    ////                                         if (succ) {
    ////                                             [self initMobileInfo];
    ////                                         }else{
    ////
    ////                                         }
    ////                                     }];
    ////
    ////                                 }
    ////                             }];
    ////                         }else{
    //                             //身份证是否黑名单
    //                             [self verificationIdcard:^(BOOL succ) {
    //                                 if (succ) {
    //                                     [self initMobileInfo];
    //                                 }else{
    //
    //                                 }
    //                             }];
    ////                         }
    //                    }
    //
    //                }];
                    if (![self isSpeedVersion]) {
                        //支付宝实名
                        [self verificationAlipay:^(BOOL succ) {
                            if (succ) {
                                //身份证是否黑名单
                                [self verificationIdcard:^(BOOL succ) {
                                    if (succ) {
                                        [self initMobileInfo];
                                    }else{
                                        
                                    }
                                }];
                                
                            }
                        }];
                    }else{
                        //身份证是否黑名单
                        [self verificationIdcard:^(BOOL succ) {
                            if (succ) {
                                [self initMobileInfo];
                            }else{
                                
                            }
                        }];
                    }
                });

        }];
        
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

/**
 *  年龄超出范围提示
 */
- (void)showBtithdayAlertView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""
                                                                              message:@"您未在20~55周岁可申请年龄段内"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [self.controller presentViewController:alertController animated:YES completion:nil];
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
    [self endEditing:YES];
    //    [self initMobileInfo:_mobileNumField.text];
}


//获取短信验证码
- (void)getSMSCode:(UIButton *)sender{
    [self endEditing:YES];
    
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
    
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;

    [VVNetInit mobileNetInitPhoneNum:self.mobile  Name:self.authenticationName IdCard:self.authenticationIDcard success:^(BOOL result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if (result) {
            VV_SHDAT.orderInfo.mobile = self.mobile;     // 初始化成功 保存下mobile 下步刷新页面 仍保留手机号
            VV_SHDAT.orderInfo.applicantIdcard = self.authenticationIDcard;
            VV_SHDAT.orderInfo.applicantName = self.authenticationName;
            _mobileNextProCode = VV_SHDAT.mobileInitModel.nextProCode;   //初始化成功接口存储
            [self showMobileNextView:NO];
        }

    } failure:^(NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];
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
                          @"IdentityCard":self.authenticationIDcard,
                          @"Website":VV_IS_NIL(VV_SHDAT.mobileInitModel.Website)?@"":VV_SHDAT.mobileInitModel.Website,
                          @"Name":self.authenticationName,
                          @"bustype":@"JIELEHUA",
                          @"busid":@"",
                          @"smscode":VV_IS_NIL(self.mobileSMSCode)?@"":self.mobileSMSCode,
                          };
    
    NSString *str = [dic mj_JSONString];
    NSString *base64 = [str base64EncodedString];
    VVLog(@"base64 ==%@",base64);
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]postMobileLoginSoapMessage:base64 success:^(id result)
     {
          __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf.controller hideHud];
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

                 VV_SHDAT.authenticationModel.mobile = self.mobile; // 手机登录成功存以下信息  用于征信上传四要素
                 VV_SHDAT.authenticationModel.name = self.authenticationName;
                 VV_SHDAT.authenticationModel.idcardNo = self.authenticationIDcard;
                 
                 NSString * resultIdStr = rsultDic[@"Result"];
                 VVLog(@"login resultIdStr===%@",resultIdStr);
                 NSDictionary *idDic = [resultIdStr mj_JSONObject];
                 if (idDic) {
                     NSString *mobileId = idDic[@"Id"];
                     VVMobileInitModel *mobileInitModel = [VVMobileInitModel mj_objectWithKeyValues:[VV_SHDAT.mobileInitModel mj_JSONObject]];
                     mobileInitModel.mobileBillId = mobileId;
                     VV_SHDAT.mobileInitModel = mobileInitModel;
                    
                 }
                 
                 if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                     [VLToast showWithText: rsultDic[@"StatusDescription"]];
                 }
                 if (success) {
                     success(YES);
                 }
             }
             
         }else{
             [strongSelf.controller hideHud];
             if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                 [VLToast showWithText: rsultDic[@"StatusDescription"]];
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
    __weak __typeof(self)weakSelf = self;
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
         
          __strong __typeof(weakSelf)strongSelf = weakSelf;
         [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];
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
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]postMobileChecksmsSoapMessage:base64 success:^(id result)
     {
          __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf.controller hideHud];
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
                     VV_SHDAT.mobileInitModel.mobileBillId = mobileId;
                     VV_SHDAT.mobileInitModel.nextProCode = nextPro;
                     _mobileNextProCode = VV_IS_NIL(rsultDic[@"nextProCode"])?@"":rsultDic[@"nextProCode"]  ;
                     VVLog(@"mobileId :%@",mobileId);
                 }
                 if (!VV_IS_NIL(rsultDic[@"StatusDescription"])) {
                     [VLToast showWithText: rsultDic[@"StatusDescription"]];
                 }
                 if (success) {
                     success(YES);
                 }
             }
         }else{
             if (success) {
                 success(NO);
             }
             [VLToast showWithText: [NSString stringWithFormat:@"%@,%@",rsultDic[@"StatusDescription"],@"请点击获取验证码按钮"]];
             [wself resetGetSMSCodeButton];

         }
         
     } failure:^(NSError *error) {
          __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf.controller hideHud];
         [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];
     }];
     
}


- (void)postApplyUpdateServesMobile{
    if (![self checkoutPhoneNum:_mobileNumField.text])
    {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //上传服务器 mobile token
        
        NSDictionary *dic = @{  @"applyId": @"",
                                @"creditAuthorizationBase64": @"",
                                @"customerId":[UserModel currentUser].customerId,
                                @"faceBase64": @"",
                                @"householdAddr":_authenticationModle.householdAddr,
                                @"idcardImageBase64":@"",
                                @"idcardImageObverseBase64":@"",
                                @"idcardImageReverseBase64": _authenticationModle.idcardImageReverseBase64,
                                @"idcardNo":_authenticationIDcard,
                                @"mobile": _mobile,
                                @"mobileAddress":@"",
                                @"mobileBillId": VV_SHDAT.mobileInitModel.mobileBillId,
                                @"name": _authenticationName
                                };

        [_controller showHud];
        __weak __typeof(self)weakSelf = self;
        [[VVNetWorkUtility netUtility] postApplyUpdateCustomerCreditInfoParameters:dic success:^(id result) {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.controller hideHud];
            
                if ([[result safeObjectForKey:@"success"] boolValue]) {
                    VVOrderInfoModel *orderInfo = nil;
                    NSDictionary *resultData = [result safeObjectForKey:@"data"];
                    
                    orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.orderInfo = orderInfo;
                    
                    VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.creditBaseInfoModel = baseInfoModel;
                    
                    JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.authenticationModel = authenticationModel;

                    VV_SHDAT.mobileInitModel.nextProCode = @"";
                    
                      if([VV_SHDAT.orderInfo.applyStatusCode integerValue] == applyTypeZhimaScore){
                            [_baseScrollView removeFromSuperview];
                            [self setupscrollView];
                      }else{
                          if ([_loanMobileViewDelagate respondsToSelector:@selector(postMobileNextStep:)])  {
                              [_loanMobileViewDelagate postMobileNextStep:VV_SHDAT.orderInfo.applyStatusCode ];
                          }
                      }
                    
                    
                }
                
        } failure:^(NSError *error) {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.controller hideHud];
            [VLToast showWithText:[strongSelf.controller strFromErrCode:error]];

        }];
        
    });
}


#pragma mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
        return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if ([textField isKindOfClass:[_zhimaField class]] ) {
//        if (textField.canBecomeFirstResponder == NO) {
            [self endEditing:YES];
            return NO;
//        }
    }
    return YES;
    
}

- (void)textFieldDidChangeNotification:(NSNotification *)notification
{

    if (_modifyIDcardField.text.length >= 18) {
        _modifyIDcardField.text = [_modifyIDcardField.text substringToIndex:18];
        self.modifyIDcardAlertController.view.tintColor = VVColor(0, 118, 255);
        self.modifyIDcardSureAction.enabled = YES;
    }else{
        self.modifyIDcardAlertController.view.tintColor = VVColor(153, 153, 153);
        self.modifyIDcardSureAction.enabled = NO;
    }
    
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
    
    BOOL isNoImg = NO;
    
    if (  (!VV_IS_NIL(_authenticationModle.idcardImageReverseBase64)) && (!VV_IS_NIL(_authenticationModle.idcardImageObverseBase64)) && (!VV_IS_NIL(_authenticationModle.faceBase64))  ) {
        isNoImg = YES;
    }
    
    __block BOOL isEmpty = YES;
    [_allTxtFieldArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVCommonTextField *textfield = obj;
        
        if (VV_IS_NIL(textfield.text)) {
            isEmpty = NO;
        }
        if ([textfield.leftText isEqualToString:@"姓名"]) {
            self.authenticationName = _authenNameField.text;
            
        }else if ([textfield.leftText isEqualToString:@"身份证"]){
            self.authenticationIDcard = _authenIdCardField.text;
            
        }else if ([textfield.leftText isEqualToString:@"手机号"]){
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

    if (isEmpty && isNoImg) {
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
    }else if (_zhimaField == textField){
        
        
        
    }
    
    return YES;
}

#pragma mark 业务逻辑接口
//验证 身份证是否黑名单
- (void)verificationIdcard:(void (^)( BOOL succ))success{
    
//    __block BOOL isHanzi = YES;
//    [_authenNameField.text enumerateSubstringsInRange:NSMakeRange(0, _authenNameField.text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
//        unichar c = [substring characterAtIndex:0];
//        if (c >=0x4E00 && c <=0x9FFF)
//        {
//            isHanzi = YES;
//        }else{
//            isHanzi = NO;
//            *stop = YES;
//        }
//    }];
//    
//    if (!isHanzi) {
//        [VLToast showWithText:@"请输入中文名字"];
//        return;
//    }else if (_authenNameField.text.length<2||_authenNameField.text.length>6){
//        [VLToast showWithText:@"请输入2到6个字的正确的姓名"];
//        return;
//    }
    
    
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;

    [[VVNetWorkUtility netUtility]getOrdersVerificationIdcardWithIDcard:_authenIdCardField.text andName:_authenNameField.text success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            NSDictionary *dataDic = [result safeObjectForKey:@"data"];
                if (dataDic.count > 0) {
                    
                        if ([dataDic[@"isSuccess"] boolValue]) {
                            [VVAlertUtils showAlertViewWithTitle:nil message:dataDic[@"message"] customView:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                                if (success) {
                                    success(NO);
                                }
                            }];
                        }else{
                            if (success) {
                                success(YES);
                            }
                        }
                    
                }else{
                    if (! VV_IS_NIL(result[@"message"])) {
                        [VLToast showWithText:result[@"message"]];
                    }
                    if (success) {
                        success(NO);
                    }
                }
            
        }else{
            if (! VV_IS_NIL(result[@"message"])) {
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

//验证 花被姓名和身份证号
- (void)verificationAlipay:(void (^)( BOOL succ))success{
    
    [self getAntsTokenVerificationAlipay:^(BOOL succ) {
        if (succ) {
            [self queryAlipa:success];
        }else{
            success(NO);
        }
    }];
  
}

- (void)queryAlipa:(void (^)( BOOL succ))success
{
    NSDictionary *dic = @{
                          @"Token":VV_SHDAT.antsToken,
                          @"Name":_authenNameField.text,
                          @"IdentityCard":_authenIdCardField.text
                          };
    
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]postQueryAlipaySummaryWithParameters:dic success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        NSDictionary *rsultDic = (NSDictionary *)result;
        if ([rsultDic[@"StatusCode"]integerValue] == 0)  {
            
            if([[rsultDic[@"Result"] mj_JSONObject][@"IsRealName"] isEqualToString:@"否"]){
                [strongSelf.hud hide:YES];
                [VVAlertUtils showAlertViewWithTitle:@"" message:@"您的身份信息与支付宝账号信息不一致，请更换支付宝账号或重新上传身份证" customView:nil cancelButtonTitle:@"重新上传" otherButtonTitles:@[@"更换支付宝"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex  != kCancelButtonTag) {
                        [alertView hideAlertViewAnimated:YES];
                        [VLToast showWithText:@"身份认证过期，请重新认证"];
                        [[JCRouter shareRouter]pushURL:@"huabei/1"];   //去支付宝登录授权界面
                    }
                }];
                
                if (success) {
                    success(NO);
                }
            }
            else if([[rsultDic[@"Result"] mj_JSONObject][@"IsRealName"] isEqualToString:@"是"]){
                [strongSelf.hud hide:YES];
                if (success) {
                    success(YES);
                }
            }
            else{
                //result 返回null
                if (_hud == nil) {
                    _hud = [MBProgressHUD showAnimationWithtitle:@"正在获取数据，请勿离开！！" toView:self];
                }
                //10s后再次调用
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf queryAlipa:success];
                });
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

- (void)retryAlipayQuery:(void (^)( BOOL succ))success
{
    if (_hud == nil) {
        _hud = [MBProgressHUD showAnimationWithtitle:@"正在获取数据，请勿离开！！" toView:self];
    }
    //30s后再试尝试，直至成功
    [self performSelector:@selector(queryAlipa:) withObject:success afterDelay:30];
}

- (void)getAntsTokenVerificationAlipay:(void (^)( BOOL succ))success{
    [self getAntsToken:^(BOOL succ) {
        if (succ) {
            if (success) {
                success(YES);
            }
        }
    }];
}

- (void)getAntsToken:(void (^)( BOOL succ))success{
    UserModel *userModel = [UserModel currentUser];
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;

    [[VVNetWorkUtility netUtility] getHuebeiTokenWithCustomerId:userModel.customerId success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        VVLog(@"%@",result);
        [strongSelf.controller hideHud];
        if ([[result safeObjectForKey:@"success"] boolValue]) {
                if (VV_IS_NIL([result safeObjectForKey:@"data"])) {
                    
                    [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"支付宝认证超时，请重新扫描" customView:nil cancelButtonTitle:@"重新登录支付宝" otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                        [alertView removeAllAlert];
                        [[JCRouter shareRouter]pushURL:@"huabei/1"];   //去支付宝登录授权界面
                    }];
                    
                }else{
                VV_SHDAT.antsToken = [result safeObjectForKey:@"data"];
                    if (success) {
                        success(YES);
                    }
                }
            
        }else{
            [MBProgressHUD showError:@"获取数据错误"];
        }
    } failure:^(NSError *error) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
    }];
}

- (void)getAppCustInfoByWechat:(void (^)( BOOL succ))success{
    [_controller showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getAppCustInfoByWechatCustomerId:[UserModel currentUser].customerId idCardNo:self.authenticationIDcard mobile:self.mobile success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        BOOL successValue = [[result safeObjectForKey:@"success"] boolValue];
        if (successValue) {
            NSDictionary *dic = [result safeObjectForKey:@"data"];
            
            _syncWay = [dic safeObjectForKey:@"syncWay"];
            if ([_syncWay isEqualToString:@"syncOver"])
            {
                // "syncOver"代表后台已强制同步
//                save token id
                [[UserModel currentUser] clear];
                UserModel *user = [[UserModel alloc] init];
                user.token = dic[@"accessToken"];
                user.customerId = dic[@"customerId"];
                user.phone = dic[@"mobile"];
                [user persist];
                _message = VV_IS_NIL(dic[@"message"])?@"":dic[@"message"];

                 if (success) {
                     success(YES);
                 }
            }
            else if ([_syncWay isEqualToString:@"syncCheck"])
            {
                //syncCheck"代表需要用户选择是否同步,并且返回微信端customerId
//                _syncWay =   VV_IS_NIL(dic[@"syncWay"])?@"":dic[@"syncWay"] ;
                 _wechatCustomerId = [NSString stringWithFormat:@"%@",dic[@"wechatCustomerId"]];
                 _message = VV_IS_NIL(dic[@"message"])?@"":dic[@"message"];
                
                if (success) {
                    success(YES);
                }
            }
            else
            {
                //error
                if (success) {
                    success(NO);
                }
            }
        
        }else{
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

-(void)syncWechatCustInfoAppCustomerId:(void(^)(BOOL succ))success{

    [_controller showHud];
    __weak __typeof(self)weakSelf = self;

    [[VVNetWorkUtility netUtility]syncWechatCustInfoAppCustomerId:[UserModel currentUser].customerId wechatCustomerId:_wechatCustomerId success:^(id result) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.controller hideHud];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            NSDictionary *dic = result[@"data"];
            if (dic.count > 0) {

                [[UserModel currentUser] clear];
                UserModel *user = [[UserModel alloc] init];
                user.token = dic[@"accessToken"];
                user.customerId = dic[@"customerId"];
                user.phone = dic[@"mobile"];
                [user persist];
              
                if (success) {
                    success(YES);
                }
            }
        }else{
            
           if( !VV_IS_NIL(result[@"message"])){
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

#pragma mark - 活体检测代理
/**
 *  活体检测成功的回调
 *
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessSuccess: (OliveappDetectedFrame*) detectedFrame
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    
    /*
     verificationData后台用的是这个属性
     */
    [VVAlertUtils showAlertViewWithTitle:@"人脸识别"
                                 message:nil
                              customView:[self onLivenessSuccessView]
                       cancelButtonTitle:@"确认"
                       otherButtonTitles:nil
                                     tag:0
                           completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex)
     {
         
         [self onLivenessRequestImageWithData:detectedFrame.verificationDataFull];
         
     }];
}

/**
 *  活体检测失败的回调
 *
 *  @param sessionState  session状态，用于区别超时还是动作不过关
 *  @param detectedFrame 活体检测抓取的图片
 */
- (void) onLivenessFail: (int)sessionState withDetectedFrame: (OliveappDetectedFrame*) detectedFrame
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  取消活体检测的回调
 */
- (void) onLivenessCancel
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}


/**
 活体检测请求
 */
- (void)onLivenessRequestImageWithData:(NSData *)data
{
    NSString *base64ImageStr = [data base64EncodedStringWithOptions:0];

    //活体检测
    NSDictionary *handParma = @{
                                @"customerId":[UserModel currentUser].customerId,
                                @"facebase64":base64ImageStr,
                                @"idcardImageObverseBase64":_authenticationModle.idcardImageObverseBase64,
                                @"type":@(100)
                                };
    
    [_controller showHud];
    
    __weak __typeof(self)weakSelf = self;
    
    [[VVNetWorkUtility netUtility] postApplySpeedFaceRecognitionWithparameters:handParma
                                                                       success:^(id result)
     {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf.controller hideHud];
         
         [strongSelf resultSuccesstype:IDCARD_HAND Base64:base64ImageStr result:result];
         
     } failure:^(NSError *error)
     {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         [strongSelf.controller hideHud];
         _authenticationModle.faceBase64 = nil;
         [strongSelf showIdCardViewType:@"updataDefault" view:_handImageView lable:_handLabel];
         [strongSelf resultFailuer:error];
         
     }];
}

/**
 活体检测成功弹窗
 */
- (UIView *)onLivenessSuccessView
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 265)];
    customView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 131, 131)];
    imageview.centerX = customView.centerX;
    imageview.image = [UIImage imageNamed:@"icon_OK"];
    [customView addSubview:imageview];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame), kScreenWidth, 100)];
    lab.textColor = kColor_TitleColor;
    lab.font = kFont_Title;
    lab.text = @"人脸识别成功";
    lab.textAlignment = NSTextAlignmentCenter;
    
    [customView addSubview:lab];
    
    return customView;
}


/**
 判断是否是极速版
 1、2、是极速
 0是完整
 4是未知
 */
- (BOOL)isSpeedVersion
{
    NSString *versionStr = [JJVersionSourceManager versionSourceManager].versionSource;
    if ([versionStr isEqualToString:@"1"] || [versionStr isEqualToString:@"2"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
