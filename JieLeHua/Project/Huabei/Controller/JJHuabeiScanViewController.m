//
//  JJHuabeiScanViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJHuabeiScanViewController.h"
#import "JJHuabeiImageModel.h"
#import "JJHuabeiCheckModel.h"
#import "JJMainStateModel.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"
#import "JJGetApplyInfoByCustomerIdRequest.h"
#import "JJCrawlstatusModel.h"
#import "JJBaicModel.h"
#import "JJHuabeiIncreaseRequest.h"

@interface JJHuabeiScanViewController ()
{
    UIView *bgView;
}
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UITextView *tipTextView;
@property (nonatomic, strong) UIButton *ensureBtn;
@property (nonatomic, copy) NSString *token;
//@property (nonatomic, assign) BOOL canOpenAlipay;
@property (nonatomic, assign) BOOL needReloadImage;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *applicantName;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation JJHuabeiScanViewController

//如果是代码 xib 创建ViewController 则JCRouter会调用此方法
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        VVLog(@"%@", params);
        self.needUpdate = [params objectForKey:@"needUpdate"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.canOpenAlipay = YES;
    [MobClick event:@"apply_credit"];
    [self setNavigationBarTitle:@"支付宝登录授权"];
    [self addBackButton];
    self.qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 265.5)];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [bgView addSubview:self.qrImageView];
    bgView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:bgView];
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(55);
        make.right.mas_equalTo(bgView.mas_right).offset(-55);
        make.top.mas_equalTo(bgView.mas_top).offset(40);
        make.height.mas_equalTo(@265.5);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getQrImage)];
    self.qrImageView.userInteractionEnabled = YES;
    [self.qrImageView addGestureRecognizer:tap];
    
    
    UILongPressGestureRecognizer *pressReco = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [self.qrImageView addGestureRecognizer:pressReco];

    [self hiddenFailLoadViewView];
    [self getQrImage];
    [self addReloadTarget:self action:@selector(reloadView)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 扫描确认按钮
- (void)initQRCodeBtn
{
    if (self.ensureBtn) {
        return;
    }
    self.ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ensureBtn setBackgroundColor:UIColor.globalThemeColor forState:UIControlStateNormal];
    [self.ensureBtn setBackgroundColor:UIColor.unableButtonThemeColor forState:UIControlStateDisabled];
    [self.ensureBtn setTitle:@"保存图片，打开支付宝" forState:UIControlStateNormal];
    [self.ensureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [bgView addSubview:self.ensureBtn];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(20);
        make.right.mas_equalTo(bgView.mas_right).offset(-20);
        make.top.mas_equalTo(self.tipTextView.mas_bottom).offset(10);
        make.height.mas_equalTo(@44);
    }];
    self.ensureBtn.layer.cornerRadius = 5.f;
    self.ensureBtn.layer.masksToBounds = YES;
    [self.ensureBtn addTarget:self action:@selector(ensureQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoBtn setTitle:@"观看视频教程" forState:UIControlStateNormal];
    [videoBtn setTitleColor:UIColor.globalThemeColor forState:UIControlStateNormal];
    videoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:videoBtn];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(20);
        make.right.mas_equalTo(bgView.mas_right).offset(-20);
        make.top.mas_equalTo(self.ensureBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(@30);
    }];
    [videoBtn addTarget:self action:@selector(gotoVideo) forControlEvents:UIControlEventTouchUpInside];
    
    bgView.height = self.view.frame.size.height+64;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, self.view.frame.size.height+64);
}

#pragma mark - 提示语句
- (void)setTipContent
{
    if (self.tipTextView) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    UIFont *textFont = [UIFont systemFontOfSize:15];
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:textFont,
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
    self.tipTextView = [[UITextView alloc] init];
    NSString *string= @"<html><body><p><font size=\"4\" face=\"Verdana\">1、保存图片到本地，并打开<font color=\"#EC5F2B\">支付宝APP</font></p>\n <p>2、在<font color=\"#EC5F2B\">支付宝APP</font>内，点击“<font color=\"#EC5F2B\">扫一扫</font>”，选择<font color=\"#EC5F2B\">扫描图片</font></p>\n <p>3、选择扫描刚刚保存到相册的<font color=\"#EC5F2B\">二维码</font></p>\n <p>4、扫描确认后，返回借乐花,确认扫描</p>\n <p>5、支付宝二维码登录成功后，<font color=\"#EC5F2B\">有效期为24小时</font>，请在有效期内完成额度申请流程</p></body></html>";
    NSAttributedString * strAtt = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    self.tipTextView.attributedText = strAtt;
    CGSize size = [self.tipTextView.text sizeWithFont:textFont constrainedToSize:CGSizeMake(kScreenWidth-30-16, MAXFLOAT)];
    [bgView addSubview:self.tipTextView];
    self.tipTextView.showsVerticalScrollIndicator = NO;
    self.tipTextView.scrollEnabled = NO;
    self.tipTextView.editable = NO;
    self.tipTextView.backgroundColor = [UIColor clearColor];
    [self.tipTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.top.mas_equalTo(self.qrImageView.mas_bottom).offset(10);
        //注意：再前两种方法中,UITextView在上下左右分别有一个8px的padding，需要将UITextView.contentSize.width减去16像素（左右的padding 2 x 8px）。同时返回的高度中再加上16像素（上下的padding），这样得到的才是UITextView真正适应内容的高度
        make.height.mas_equalTo(size.height+16+60);
    }];
}

#pragma mark - 获取花呗二维码
- (void)getQrImage
{
    __weak __typeof(self)weakSelf = self;
    [self showHud];
    [[VVNetWorkUtility netUtility] getHuabeiImage:@"QCode" success:^(id result) {
//        VVLog(@"成功%@",result);
        JJHuabeiImageModel *model = [JJHuabeiImageModel mj_objectWithKeyValues:result];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideHud];
        strongSelf.ensureBtn.enabled = YES;
        if ([model.StatusCode integerValue] == 0) {
            [strongSelf hiddenFailLoadViewView];
            strongSelf.token = model.Token;
            strongSelf.needReloadImage = NO;
            NSData *data = [NSData base64DataFromString:model.VerCodeBase64];
            strongSelf.qrImageView.image = [UIImage imageWithData:data];
            [strongSelf setTipContent];
            [strongSelf initQRCodeBtn];
//            [strongSelf saveImage];
        }else{
            strongSelf.needReloadImage = YES;
            [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
        }
    } failure:^(NSError *error) {
//        VVLog(@"失败-- %@",error);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.ensureBtn.enabled = NO;
        strongSelf.needReloadImage = YES;
        [strongSelf hideHud];
        [MBProgressHUD showError:@"加载图片失败"];
        [strongSelf showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
    }];
}

#pragma mark - 刷新
- (void)reloadView
{
    [self hiddenFailLoadViewView];
    [self getQrImage];
}

#pragma mark - 重新获取图片

#pragma mark - 保存图片到本地

- (void)saveImage:(UILongPressGestureRecognizer *)recognizer
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"保存图片！" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImage];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:updateAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageWriteToSavedPhotosAlbum(self.qrImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        [MBProgressHUD bwm_showTitle:@"已成功保存至相册" toView:self.view hideAfter:2.f msgType:BWMMBProgressHUDMsgTypeSuccessful];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL  URLWithString:@"alipay://"]]){
            VVLog(@"install--");
            [self.ensureBtn setTitle:@"已扫描二维码，点击刷新" forState:UIControlStateNormal];
            [self performSelector:@selector(gotoAlipay) withObject:nil afterDelay:1.f];
        }else{
            VVLog(@"not install---");
            [MBProgressHUD showError:@"请先安装支付宝App"];
        }
    }else{
        [MBProgressHUD bwm_showTitle:@"保存失败,请确认打开相册权限" toView:self.view hideAfter:1.0f msgType:BWMMBProgressHUDMsgTypeError];

//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
    }
    
}

#pragma mark - 提示打开支付宝扫码
- (void)gotoAlipay
{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"打开支付宝进行扫描图片" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *openAlipayAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"alipay://"]];

//    }];
//    [alert addAction:openAlipayAction];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 按钮事件
- (void)gotoVideo
{
    [[JCRouter shareRouter] pushURL:@"gifView"];
}

- (void)ensureQRCode
{
        __weak __typeof(self)weakSelf = self;
        [self showHud];
        [[VVNetWorkUtility netUtility] checkQRCodeWithToken:self.token success:^(id result) {
            JJHuabeiCheckModel *model = [JJHuabeiCheckModel mj_objectWithKeyValues:result];
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hideHud];
            if ([model.StatusCode integerValue]== 0) {
                if ([self.needUpdate boolValue]) {
                    [strongSelf getCustomerInfo];
                }else{
                    [strongSelf beginApply];
                }
            }else{
                [strongSelf saveImage];
            }
        } failure:^(NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hideHud];
        }];
}

- (void)getMainStateRequestWithUserID:(NSString *)userid {
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getMainUserStateWithAccountId:userid vc:self success:^(id result) {
        VVLog(@"成功-- %@",result);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJMainStateModel *statusModel = [JJMainStateModel mj_objectWithKeyValues:result];
        if (statusModel.summary.applyStatus == 16 ||
                  statusModel.summary.applyStatus == 17 || 
                  statusModel.summary.applyStatus == 18 ||
            statusModel.summary.applyStatus == 15){
            [strongSelf applyBtnClick];
        }
        else{
            //其他状态直接返回首页
            [[JCRouter shareRouter] popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        VVLog(@"失败-- %@",error);
    }];
}

-(void)applyBtnClick{
    UserModel *userModel = [UserModel currentUser];
    [[VVNetWorkUtility netUtility] getCustomersOrderDetailsWithAccountId:userModel.customerId success:^(id result) {
        
        if ([result[@"code"] integerValue] == 200) {
            VVOrderInfoModel *orderInfo = nil;
            NSDictionary *resultData = [result safeObjectForKey:@"data"];
            
            orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.orderInfo = orderInfo;
            
            VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.creditBaseInfoModel = baseInfoModel;
            
            JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
            VV_SHDAT.authenticationModel = authenticationModel;
            VV_SHDAT.timestamp =  result[@"timestamp"];
            
            if ([orderInfo.applyStatusCode integerValue] == applyTypeBase|| [orderInfo.applyStatusCode integerValue] ==applyTypeCredit || [orderInfo.applyStatusCode integerValue] ==applyTypeMobileVerification || [orderInfo.applyStatusCode integerValue] ==applyTypeZhimaScore) {
                [[JCRouter shareRouter] pushURL:@"fillInformation"];
            }else{
                [MBProgressHUD showError:@"信息不正确，请刷新页面重试"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取信息
- (void)getCustomerInfo
{
    JJGetApplyInfoByCustomerIdRequest *infoRequest = [[JJGetApplyInfoByCustomerIdRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [infoRequest addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    
    [infoRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSDictionary *result = request.responseJSONObject;
        if ([result[@"code"] integerValue] == 200) {
            strongSelf.cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
            strongSelf.applicantName = [[result safeObjectForKey:@"data"] objectForKey:@"applicantName"];
            //name不为空的情况，需要进行实名认证，否则继续updatetoken
            if (strongSelf.applicantName != nil) {
                [strongSelf queryAlipa];
            }else{
//                [strongSelf updateHuabeiToken];
            }
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
}

- (void)queryAlipa
{
    NSDictionary *dic = @{
                          @"Token":self.token,
                          @"Name":self.applicantName,
                          @"IdentityCard":self.cardId
                          };
    
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postQueryAlipaySummaryWithParameters:dic success:^(id result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSDictionary *rsultDic = (NSDictionary *)result;
        if ([rsultDic[@"StatusCode"]integerValue] == 0)  {
            if([[rsultDic[@"Result"] mj_JSONObject][@"IsRealName"] isEqualToString:@"否"]){
                [strongSelf.hud hide:YES];
                [VVAlertUtils showAlertViewWithTitle:@"" message:@"您的身份信息与支付宝账号信息不一致，请更换支付宝账号" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"更换支付宝"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex  != kCancelButtonTag) {
                        [alertView hideAlertViewAnimated:YES];
                        [VLToast showWithText:@"身份认证失败，请使用本人支付宝扫描"];
                        [strongSelf getQrImage];
                    }
                }];
            }
            else if([[rsultDic[@"Result"] mj_JSONObject][@"IsRealName"] isEqualToString:@"是"]){
                [strongSelf getCrawlstatus];
//                [strongSelf updateHuabeiToken];
            }
            else{
                //Result为空,30s 调用该接口
                [strongSelf retryAlipayQuery];
//                [VLToast showWithText:@"支付宝实名认证失败，请使用本人支付宝扫描"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)retryAlipayQuery
{
    if (_hud == nil) {
        _hud = [MBProgressHUD showAnimationWithtitle:@"正在获取数据，请勿离开！！" toView:self.view];
    }
    else{
        _hud = nil;
        _hud = [MBProgressHUD showAnimationWithtitle:@"正在获取数据，请勿离开！！" toView:self.view];
    }
    //30s后再试尝试，直至成功
    [self performSelector:@selector(queryAlipa) withObject:nil afterDelay:30];
}

- (void)updateHuabeiToken
{
    UserModel *userModel = [UserModel currentUser];
    __weak __typeof(self)weakSelf = self;
    VV_SHDAT.antsToken = self.token;
    [[VVNetWorkUtility netUtility] updateTokenWithCustomerId:userModel.customerId token:self.token success:^(id result) {
        VVLog(@"%@",result);
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            [strongSelf getMainStateRequestWithUserID:[UserModel currentUser].customerId];
        }else{
            [strongSelf dealWithFail];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)beginApply
{
    UserModel *userModel = [UserModel currentUser];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] beginApplyWithToken:self.token customerId:userModel.customerId success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            [strongSelf getMainStateRequestWithUserID:[UserModel currentUser].customerId];
        }else{
            [strongSelf dealWithFail];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)dealWithFail
{
    [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"您的二维码未扫描成功，请重新扫描登录" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex  != kCancelButtonTag) {
            //刷新二维码图片
            [self getQrImage];
        }
    }];
}


#pragma mark - 网络请求

- (void)retryHuabeiQuery
{
    //30s后再试尝试，直至成功
    [self performSelector:@selector(getCrawlstatus) withObject:nil afterDelay:30];
}



//采集状态查询，每40s查询一次，直到成功后查询基本信息，超过8分钟取消请求
- (void)getCrawlstatus
{
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getCrawlstatusWithToken:self.token success:^(id result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJCrawlstatusModel *statusModel = [JJCrawlstatusModel mj_objectWithKeyValues:result];
        if (statusModel.CrawlStatus == 2002) {
            //数据采集成功后获取基本信息
            [strongSelf getBaic];
        }
        else if(statusModel.CrawlStatus == 2000 || statusModel.CrawlStatus == 1007 || statusModel.CrawlStatus == 1008 || statusModel.CrawlStatus == 2001){
            //登录成功 || 正在登录 || 等待发送短信验证码 || 数据正在采集
            [strongSelf retryHuabeiQuery];
        }
        else{
            //失败，需要重新获取
            [strongSelf.hud hide:YES];
            [strongSelf getQrImage];
        }
        //加载重新获取页面
    } failure:^(NSError *error) {
        //加载重新获取页面
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hud hide:YES];
        [strongSelf getQrImage];
    }];
}

//查询基本信息
- (void)getBaic
{
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getBaicWithToken:self.token success:^(id result) {
        VVLog(@"%@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hud hide:YES];
        JJBaicModel *baicModel = [JJBaicModel mj_objectWithKeyValues:result];
        if (baicModel.StatusCode == 0) {

            if (baicModel.Result.FlowersBalance > 0) {
                //有花呗额度
                [strongSelf uploadHuabeiBalance:baicModel.Result.FlowersBalance];
            }else{
                //没有花呗额度的情况
                [VVAlertUtils showAlertViewWithTitle:@"" message:@"您的花呗额度为0,不满足要求" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != kCancelButtonTag) {
                        [alertView hideAlertViewAnimated:YES];
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }else{
            [MBProgressHUD showError:@"获取花呗额度异常,请稍后再试"];
            [strongSelf getQrImage];
        }
        
    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hud hide:YES];
        [MBProgressHUD showError:@"获取花呗额度异常,请稍后再试"];
        [strongSelf getQrImage];
    }];
}


#pragma mark - 花呗额度传值
- (void)uploadHuabeiBalance:(float)balance
{
    JJHuabeiIncreaseRequest *request = [[JJHuabeiIncreaseRequest alloc] initWithCustomerId:[UserModel currentUser].customerId antsChantFlowers:[NSString stringWithFormat:@"%.2f",balance] status:@"1"];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;

    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJBaseResponseModel *model = [(JJHuabeiIncreaseRequest *)request response];
        if (model.success) {
            //跳转到详情
            [[JCRouter shareRouter] pushURL:@"increaseMoney"];
        }else{
            [MBProgressHUD showError:@"上传花呗额度失败，请稍后再试！"];
            [strongSelf getQrImage];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"上传花呗额度失败，请稍后再试！"];
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getQrImage];
    }];
}


@end
