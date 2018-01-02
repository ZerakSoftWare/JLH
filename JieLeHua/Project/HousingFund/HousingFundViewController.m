//
//  HousingFundViewController.m
//  JieLeHua
//
//  Created by admin2 on 2017/8/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "HousingFundViewController.h"
#import "HousingCityListViewController.h"
#import "HouseCityModel.h"
#import "HouseLoginModel.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface HousingFundViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *fieldView;

//--图形验证码
@property (nonatomic, strong) UIButton *imageCodeBtn;

//--城市Lab
@property (nonatomic, strong) UILabel *cityLab;

//--城市列表
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HouseCityModel *selectCityModel;

//--后台返回的数据
@property (nonatomic, strong) NSMutableArray *formSettingAry;

@property (nonatomic, assign) int loginType;

@property (nonatomic, copy) NSString *gjjToken;

@property (nonatomic, strong) VVCommonButton *sureBtn;

//--身份证
@property (nonatomic, copy) NSString *cardId;

//--姓名
@property (nonatomic, copy) NSString *name;

//--ParameterType为select时，选择的第几项
@property (nonatomic, assign) int parameterExtSelectType;

/**
 *  短信验证码
 */
@property (nonatomic, strong) UIButton *receiveSMSCode;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation HousingFundViewController

#pragma mark - Properties

- (UIButton *)receiveSMSCode {
    if (!_receiveSMSCode) {
        _receiveSMSCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveSMSCode.titleLabel.font = kFont_TipTitle;
        [_receiveSMSCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_receiveSMSCode setBackgroundColor:kColor_Main_Color forState:UIControlStateNormal];
        [_receiveSMSCode addTarget:self action:@selector(receiveSMSCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveSMSCode;
}

- (VVCommonButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [VVCommonButton solidButtonWithTitle:@"提交"];
        _sureBtn.titleLabel.font  = [UIFont systemFontOfSize:16.0];
        _sureBtn.layer.cornerRadius = 6.f;
        [_sureBtn addTarget:self action:@selector(sureBntClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (NSMutableArray *)formSettingAry {
    if (!_formSettingAry) {
        _formSettingAry = [[NSMutableArray alloc] init];
    }
    return _formSettingAry;
}

- (UILabel *)cityLab {
    if (!_cityLab) {
        _cityLab = [[UILabel alloc] init];
        _cityLab.textAlignment = NSTextAlignmentRight;
        _cityLab.font = kFont_Title;
        _cityLab.textColor = kColor_TipColor;
        _cityLab.text = @"请选择城市";
    }
    return _cityLab;
}

- (UIView *)fieldView {
    if (!_fieldView) {
        _fieldView = [[UIView alloc] init];
        _fieldView.backgroundColor = [UIColor whiteColor];
    }
    return _fieldView;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    HousingFundViewController *instance = [[HousingFundViewController alloc] init];
    return instance;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showSelect:textField];
    return NO;
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.view.backgroundColor = RGB(237, 241, 244);
    
    [self setNavigationBarTitle:@"公积金提额"];
    [self addBackButton];
    
    [self getCustomersOrderDetailsWithAccountId];
    
    [self getGjjProvinceFromService];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)getCustomersOrderDetailsWithAccountId
{
    [[VVNetWorkUtility netUtility] getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId
                                                                 success:^(id result)
    {
        if ([[result safeObjectForKey:@"success"] boolValue])
        {
            self.cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
            self.name = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantName"];
            
//            self.name = @"戴建龙";
//            self.cardId = @"320281199210260295";
        }
        else
        {
            [MBProgressHUD bwm_showTitle:result[@"message"]
                                  toView:self.view
                               hideAfter:1.2f];
        }
        
    } failure:^(NSError *error)
    {
        [MBProgressHUD bwm_showTitle:@"获取身份证姓名错误"
                              toView:self.view
                           hideAfter:1.2f];
    }];
}

- (void)initAndLayoutUI
{
    UIView *topView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 12+64, vScreenWidth, 42)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 42)];
        leftLab.font = [UIFont systemFontOfSize:15];
        leftLab.textColor = VVColor(51, 51, 15);
        leftLab.text = @"选择缴纳城市";
        [view addSubview:leftLab];
        
        self.cityLab.frame = CGRectMake(vScreenWidth-170-6, 0, 150, 42);
        [view addSubview:self.cityLab];
        
        UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(vScreenWidth-20, 14.5f, 8, 13)];
        rightImg.image = kGetImage(@"icon_next");
        [view addSubview:rightImg];
        
        view;
    });
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCityAction)];
    [topView addGestureRecognizer:tapGes];
    
    [self.view addSubview:topView];

    self.sureBtn.hidden = YES;
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
        make.height.equalTo(@44);
    }];
}

//--对field布局
- (void)resetInitFieldUIWithIndex:(int)index
{
    NSArray *subviews = [[NSArray alloc]initWithArray:self.fieldView.subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:@YES];
    
    HouseLoginModel *obj = self.formSettingAry[index];
    
    self.fieldView.frame = CGRectMake(0, 118, vScreenWidth, 42*obj.FormParams.count);
    [self.view addSubview:self.fieldView];
    
    int selectTextfiledTag = -1;
    
    for (int i = 0; i < obj.FormParams.count; i++)
    {
        HouseFormparams *item = obj.FormParams[i];
        
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(12, i*42, 100, 42)];
        leftLab.font = [UIFont systemFontOfSize:15];
        leftLab.textColor = VVColor(51, 51, 15);
        leftLab.text = item.ParameterName;
        [self.fieldView addSubview:leftLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 42*i, vScreenWidth, 0.5f)];
        line.backgroundColor = RGB(204, 204, 204);
        [self.fieldView addSubview:line];
        
        //--ParameterType目前已知有四种，select，text，password，number
        
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(118, i*42, vScreenWidth-125, 42)];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.font = kFont_Title;
        field.textColor = kColor_TitleColor;
        field.placeholder = item.ParameterMessage;
        field.tag = 2226+i;
        [self.fieldView addSubview:field];
        
        //--判断是否有图片验证码，并设置img frame
        if ([item.ParameterCode isEqualToString:@"LOGIN_VERIFY_CODE"])
        {
            field.frame = CGRectMake(118, i*42, vScreenWidth-82-120, 42);
            
            if (!self.imageCodeBtn)
            {
                self.imageCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.imageCodeBtn.backgroundColor = RGB(216, 216, 216);
                [self.imageCodeBtn addTarget:self action:@selector(getImageCode) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.imageCodeBtn];
                //--获取图形验证码
                [self getImageCode];
            }
            
            self.imageCodeBtn.frame = CGRectMake(vScreenWidth-82, 118+6+i*42, 70, 30);
            
            [self.view bringSubviewToFront:self.imageCodeBtn];
        }

        //--判断短信验证码
        if ([item.ParameterCode isEqualToString:@"SMS_CODE"])
        {
            //--获取短信验证码
            if ([self.selectCityModel.CityCode isEqualToString:@"GD_ZHUHAI"])
            {
                //--珠海这个城市比较特殊
                self.receiveSMSCode.frame = CGRectMake(vScreenWidth-82, 6+i*42, 70, 30);
                [self.fieldView addSubview:self.receiveSMSCode];
                
                field.frame = CGRectMake(118, i*42, vScreenWidth-82-120, 42);
            }
            else
            {
                [self getSMSCode];
            }
        }
        
        //--判断textfield是否是密码输入框
        if ([item.ParameterType isEqualToString:@"password"])
        {
            field.secureTextEntry = YES;
        }
        
        //--如果输入框是select
        if ([item.ParameterType isEqualToString:@"select"])
        {
            field.delegate = self;
            
            //--用来记录select的位置
            selectTextfiledTag = i;
            
            UIImageView *downImg = [[UIImageView alloc] initWithImage:kGetImage(@"icon_down")];
            downImg.contentMode = UIViewContentModeScaleAspectFit;
            downImg.frame = CGRectMake(vScreenWidth-25, i*42+17, 13, 8);
            [self.fieldView addSubview:downImg];
        }
        
        //--判断输入框是否身份证
        if ([item.ParameterName containsString:@"身份证"] || [item.ParameterMessage containsString:@"身份证"])
        {
            field.text = self.cardId;
            field.userInteractionEnabled = NO;
        }
        //--判断输入框是否是姓名
        if ([item.ParameterName containsString:@"姓名"])
        {
            field.text = self.name;
            field.userInteractionEnabled = NO;
        }
        
        //--判断是否有多个登录方式
        if (self.formSettingAry.count > 1 && selectTextfiledTag != 0 && i == 0)
        {
            field.frame = CGRectMake(118, i*42, vScreenWidth-155, 42);
        }
    }
    
    //--判断是否有多个登录方式，设置btn位置
    if (self.formSettingAry.count > 1)
    {
        UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downBtn.frame = CGRectMake(vScreenWidth-37, 0, 37, 42);
        [downBtn setImage:kGetImage(@"icon_down") forState:UIControlStateNormal];
        [downBtn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        [self.fieldView addSubview:downBtn];
        
        if (selectTextfiledTag != 0)
        {
            downBtn.frame = CGRectMake(vScreenWidth-37, 0, 37, 42);
        }
        else
        {
            downBtn.frame = CGRectMake(vScreenWidth-37, 42, 37, 42);
        }
    }
}

- (void)showAction
{
    [self.view endEditing:YES];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];;
    
    for (int i = 0; i < self.formSettingAry.count; i++)
    {
        HouseLoginModel *item = self.formSettingAry[i];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:item.LoginTypeName
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
        {
            self.loginType = i;
            [self resetInitFieldUIWithIndex:self.loginType];
        }]];
    }
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)selectCityAction
{
    __weak typeof(self) weakSelf = self;
    
    HousingCityListViewController *searchCityVc = [[HousingCityListViewController alloc] init];
    
    searchCityVc.dataSource = self.dataSource;
    
    searchCityVc.selectBlock = ^(HouseCityModel *selectModel) {
        
        weakSelf.cityLab.text = selectModel.CityName;
        weakSelf.selectCityModel = selectModel;
        
        [weakSelf getGjjLoginFormSettingFromService];
    };
    [searchCityVc customPushViewController:searchCityVc withType:nil subType:nil];
}


//--获取登录方式
- (void)getGjjLoginFormSettingFromService
{
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] getGjjLoginFormSettingyCityCode:self.selectCityModel.CityCode
                                                           success:^(id result)
    {
        if ([[result safeObjectForKey:@"success"] boolValue])
        {
            [HUD hide:YES];
            
            NSString *jsonStr = [[result safeObjectForKey:@"data"] safeObjectForKey:@"result"];
            
            NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            
            NSArray *ary = [dic safeObjectForKey:@"FormSettings"];
            
            self.formSettingAry = [HouseLoginModel mj_objectArrayWithKeyValuesArray:ary];
            
            self.loginType = 0;
            
            if (self.imageCodeBtn)
            {
                [self.imageCodeBtn removeFromSuperview];
                self.imageCodeBtn = nil;
            }
            
            self.gjjToken = nil;
            
            //--是否显示提交按钮
            if (ary.count > 0)
            {
                self.sureBtn.hidden = NO;
                
                //--防止ary为空
                [self resetInitFieldUIWithIndex:self.loginType];
            }
            else
            {
                self.sureBtn.hidden = YES;
            }
        }
        else
        {
            [self.fieldView removeFromSuperview];
            self.fieldView = nil;
            [self.imageCodeBtn removeFromSuperview];
            self.imageCodeBtn = nil;
            
            self.sureBtn.hidden = YES;
            
            [HUD bwm_hideWithTitle:result[@"message"]
                         hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }
    } failure:^(NSError *error) {
        
        [self.fieldView removeFromSuperview];
        self.fieldView = nil;
        [self.imageCodeBtn removeFromSuperview];
        self.imageCodeBtn = nil;
        
        self.sureBtn.hidden = YES;
        [HUD bwm_hideWithTitle:@"连接不上服务器，请稍后再试!"
                     hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }];
}

//--获取公积金城市列表
- (void)getGjjProvinceFromService
{
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] getGjjProvinceSuccess:^(id result)
    {
        if ([[result safeObjectForKey:@"success"] boolValue])
        {
            [HUD hide:YES];
            
            NSString *jsonStr = [[result safeObjectForKey:@"data"] safeObjectForKey:@"result"];
            
            NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
            
            if (resultArr.count == 0) {
                [MBProgressHUD bwm_showTitle:@"对不起，暂不支持城市"
                                      toView:self.view
                                   hideAfter:1.2f];
                return ;
            }
            
            self.dataSource = [NSMutableArray arrayWithArray:[HouseCityModel mj_objectArrayWithKeyValuesArray:resultArr]];
            
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sortWords" ascending:YES]];
            [self.dataSource sortUsingDescriptors:sortDescriptors];
            
            [self initAndLayoutUI];
        }
        else
        {
            [HUD bwm_hideWithTitle:result[@"message"]
                         hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }
    } failure:^(NSError *error) {
        [HUD bwm_hideWithTitle:@"连接不上服务器，请稍后再试!"
                     hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }];
}

//--提交
- (void)sureBntClick
{
    [self.view endEditing:YES];
    
    HouseLoginModel *obj = self.formSettingAry[self.loginType];
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    NSMutableArray *childAry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < obj.FormParams.count; i++)
    {
        NSMutableDictionary *childDic = [[NSMutableDictionary alloc] init];

        HouseFormparams *item = obj.FormParams[i];
        
        UITextField *field = (UITextField *)[self.fieldView viewWithTag:2226+i];
        
        NSString *content = field.text;
        
        //--判断是否为空
        if (!content.length)
        {
            error = YES;
            errorStr = [NSString stringWithFormat:@"%@不能为空",item.ParameterName];
            [MBProgressHUD bwm_showTitle:errorStr
                                  toView:self.view
                               hideAfter:1.2f];
            break;
        }
        
        //--正则校验
        for (int j = 0; j < item.ParameterExt.count; j++)
        {
            HouseParameterext *regexItem = item.ParameterExt[j];
            
            if (![self validateContent:regexItem.Regex withContent:content] && regexItem.Regex.length)
            {
                error = YES;
                errorStr = regexItem.Msg;
                break;
            }
        }
        
        if (error)
        {
            [MBProgressHUD bwm_showTitle:errorStr
                                  toView:self.view
                               hideAfter:1.2f];
            break;
        }
        
        [childDic setObject:item.ParameterCode forKey:@"ParameterCode"];
        [childDic setObject:item.ParameterType forKey:@"ParameterType"];
        
        if ([item.ParameterType isEqualToString:@"select"])
        {
            HouseParameterext *ext = item.ParameterExt[self.parameterExtSelectType];
            content = ext.Value;
        }
        
        [childDic setObject:content forKey:@"ParameterValue"];
        
        [childAry addObject:childDic];
    }
    
    //--检验数据是否完整
    if (childAry.count == obj.FormParams.count)
    {
        [self getGjjLoginWithChileDic:childAry];
    }
}

//--正则检验输入数据是否合法
- (BOOL)validateContent:(NSString *)regexStr withContent:(NSString *)content
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [resultPredicate evaluateWithObject:content];
}

//--公积金登录
- (void)getGjjLoginWithChileDic:(NSArray *)childAry
{
    HouseLoginModel *obj = self.formSettingAry[self.loginType];
    
    NSDictionary *params = @{
                             @"cityCode":self.selectCityModel.CityCode,
                             @"token":self.gjjToken,
                             @"busName":self.name,
                             @"busIdentityCard":self.cardId,
                             @"loginTypeCode":obj.LoginTypeCode,
                             @"formParams":childAry,
                             @"customerId":[UserModel currentUser].customerId
                             };
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] postGjjLoginParameters:params
                                                  success:^(id result)
     {
         if ([[result safeObjectForKey:@"success"] boolValue])
         {
             [HUD hide:YES];
             
             dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DEFAULT_DISPLAY_DURATION * NSEC_PER_SEC));
             dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                 [self customPopToRootViewController];
             });
         }
         else
         {
             [HUD bwm_hideWithTitle:result[@"message"]
                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
         }
         
     } failure:^(NSError *error)
     {
         [HUD bwm_hideWithTitle:@"连接不上服务器，请稍后再试!"
                      hideAfter:kBWMMBProgressHUDHideTimeInterval];
     }];
}

- (void)receiveSMSCodeClick
{
    HouseLoginModel *obj = self.formSettingAry[self.loginType];
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    NSMutableArray *childAry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < obj.FormParams.count; i++)
    {
        NSMutableDictionary *childDic = [[NSMutableDictionary alloc] init];
        
        HouseFormparams *item = obj.FormParams[i];
        
        UITextField *field = (UITextField *)[self.fieldView viewWithTag:2226+i];
        
        NSString *content = field.text;
        
        //--判断是否为空
        if (!content.length)
        {
            error = YES;
            errorStr = [NSString stringWithFormat:@"%@不能为空",item.ParameterName];
            [MBProgressHUD bwm_showTitle:errorStr
                                  toView:self.view
                               hideAfter:1.2f];
            break;
        }
        
        //--正则校验
        for (int j = 0; j < item.ParameterExt.count; j++)
        {
            HouseParameterext *regexItem = item.ParameterExt[j];
            
            if (![self validateContent:regexItem.Regex withContent:content] && regexItem.Regex.length)
            {
                error = YES;
                errorStr = regexItem.Msg;
                break;
            }
        }
        
        if (error)
        {
            [MBProgressHUD bwm_showTitle:errorStr
                                  toView:self.view
                               hideAfter:1.2f];
            break;
        }
        
        [childDic setObject:item.ParameterCode forKey:@"ParameterCode"];
        [childDic setObject:item.ParameterType forKey:@"ParameterType"];
        
        if ([item.ParameterType isEqualToString:@"select"])
        {
            HouseParameterext *ext = item.ParameterExt[self.parameterExtSelectType];
            content = ext.Value;
        }
        
        [childDic setObject:content forKey:@"ParameterValue"];
        
        [childAry addObject:childDic];
    }

    if (error) return;
    
    NSDictionary *dic = @{
                          @"cityCode":self.selectCityModel.CityCode,
                          @"token":self.gjjToken,
                          @"logintypecode":obj.LoginTypeCode,
                          @"verCodeType":@"1",
                          @"formParams":childAry
                          };
    
    [[VVNetWorkUtility netUtility] postGetGjjVercodeParameters:dic
                                                       success:^(id result)
     {
         if ([result[@"success"] integerValue] != 1)
         {
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:1.2f];
         }else{
             [self.receiveSMSCode startTime:59 title:@"重新获取" waitTittle:@"重新获取"];
         }
         
     } failure:^(NSError *error)
     {
         
     }];
}

//--获取短信验证码
- (void)getSMSCode
{
    HouseLoginModel *obj = self.formSettingAry[self.loginType];
    
    NSMutableArray *childAry = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < obj.FormParams.count; i++)
    {
        NSMutableDictionary *childDic = [[NSMutableDictionary alloc] init];
        
        HouseFormparams *item = obj.FormParams[i];
        
        UITextField *field = (UITextField *)[self.fieldView viewWithTag:2226+i];
        
        NSString *content = field.text;
        
        [childDic setObject:item.ParameterCode forKey:@"ParameterCode"];
        [childDic setObject:item.ParameterType forKey:@"ParameterType"];
        
        if ([item.ParameterType isEqualToString:@"select"])
        {
            HouseParameterext *ext = item.ParameterExt[self.parameterExtSelectType];
            content = ext.Value;
        }
        
        [childDic setObject:content forKey:@"ParameterValue"];
        
        [childAry addObject:childDic];
    }

    NSDictionary *dic = @{
                          @"CityCode":self.selectCityModel.CityCode,
                          @"Token":@"",
                          @"logintypecode":obj.LoginTypeCode,
                          @"VerCodeType":@"1",
                          @"FormParams":childAry,
                          @"BusType":@"Test"
                          };
    
    [[VVNetWorkUtility netUtility] postGetGjjVercodeParameters:dic
                                                       success:^(id result)
     {
         if ([[result safeObjectForKey:@"success"] boolValue])
         {
             
         }
         
     } failure:^(NSError *error)
     {
         
     }];
}

//--获取图形验证码
- (void)getImageCode
{
    [self.imageCodeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    HouseLoginModel *obj = self.formSettingAry[self.loginType];
    
    NSDictionary *dic = @{
                          @"cityCode":self.selectCityModel.CityCode,
                          @"token":@"",
                          @"loginTypeCode":obj.LoginTypeCode,
                          @"verCodeType":@"0"
                          };
    
    [[VVNetWorkUtility netUtility] postGetGjjVercodeParameters:dic
                                                       success:^(id result)
     {
         if ([[result safeObjectForKey:@"success"] boolValue])
         {
             NSString *base64String = [[result safeObjectForKey:@"data"] safeObjectForKey:@"result"];
             
             [self.imageCodeBtn setBackgroundImage:[UIImage base64ToImage:base64String] forState:UIControlStateNormal];
             
             self.gjjToken = [[result safeObjectForKey:@"data"] safeObjectForKey:@"token"];
         }
         else
         {
             self.gjjToken = nil;
             
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:1.2f];
         }
         
     } failure:^(NSError *error)
     {
         self.gjjToken = nil;
     }];
}

//--ParameterType为select时，弹出选择选项
- (void)showSelect:(UITextField *)selectField
{
    HouseLoginModel *obj = self.formSettingAry[self.loginType];
    
    HouseFormparams *params = obj.FormParams[selectField.tag - 2226];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];;
    
    for (int i = 0; i < params.ParameterExt.count; i++)
    {
        HouseParameterext *ext = params.ParameterExt[i];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:ext.Lable
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    self.parameterExtSelectType = i;
                                    selectField.text = ext.Lable;
                                }]];
    }
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

@end
