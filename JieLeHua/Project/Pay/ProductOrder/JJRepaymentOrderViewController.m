//
//  JJRepaymentOrderViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/9/26.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJRepaymentOrderViewController.h"
#import "JJOrderTableViewCell.h"
#import "JJWechatPayRequest.h"
#import "JJWchatPaySuccessedRequest.h"
#import "PayToolsManager.h"
#import "WXApi.h"
#import "JJWKWebViewViewController.h"
#import "JJUnionPayWebViewController.h"

@interface JJRepaymentOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton * repayBtn;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property(assign,nonatomic)NSIndexPath * selIndex;   //单选选中的行
@property(nonatomic,copy) NSString * source;
@property(nonatomic,copy) NSString * urlType;
@property(nonatomic,copy) NSString * billDate;
@property(nonatomic,copy) NSString * undueBill;
@property(nonatomic,copy) NSString * dueBill;
@property(nonatomic,copy) NSString * payBill;
@property(nonatomic,copy) NSString * dueProceduresAmt;
@property(nonatomic,copy) NSString * bankAccount;
@property(nonatomic,copy) NSString * showAlert;
@property(nonatomic,strong) UIButton * showWebBtn;

@property(nonatomic,strong) JJWechatPayDataModel * data;
@end

@implementation JJRepaymentOrderViewController

- (UIButton *)repayBtn {
    if (!_repayBtn) {
        _repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repayBtn.layer.cornerRadius = 22.5f;
        _repayBtn.clipsToBounds = YES;
        [_repayBtn addTarget:self action:@selector(repayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repayBtn;
}

- (UIButton *)showWebBtn {
    if (!_showWebBtn) {
        _showWebBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showWebBtn addTarget:self action:@selector(showWebBtnClick) forControlEvents:UIControlEventTouchUpInside];
         NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:@"银行卡扣款限额"];
        [tncString addAttribute:NSForegroundColorAttributeName value:[UIColor globalThemeColor]  range:NSMakeRange(0,[tncString length])];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        [tncString addAttribute:NSUnderlineColorAttributeName value:[UIColor globalThemeColor]range:(NSRange){0,[tncString length]}];
        [_showWebBtn setAttributedTitle:tncString forState:UIControlStateNormal];
    }
    return _showWebBtn;
}

static NSString *const repaymentOrderCell = @"repaymentOrderCell";

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        self.source = [params objectForKey:@"source"];
        self.urlType = [params objectForKey:@"urlType"];
        self.billDate = [params objectForKey:@"billDate"];
        self.undueBill = [params objectForKey:@"undueBill"];
        self.dueBill = [params objectForKey:@"dueBill"];
        self.payBill = [params objectForKey:@"payBill"];
        self.dueProceduresAmt = [params objectForKey:@"dueProceduresAmt"];
        self.bankAccount = [params objectForKey:@"bankAccount"];
        self.showAlert = [params objectForKey:@"showAlert"];

    }
    return self;
}

- (void)viewDidLoad {
    [self showfirstAlertView];
    [super viewDidLoad];
    [self setUpNavigation];
    [self setupSubView];
//    [self showAlertView];
    
}

-(void)showAlertCustomerView{
         __weak __typeof(self)weakSelf = self;
        [VVAlertUtils showAlertViewWithTitle:@"" message:nil
                                  customView:[self customAlertView]
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                               if (buttonIndex == kCancelButtonTag) {
                                   __strong __typeof(weakSelf)strongSelf = weakSelf;
                                   [alertView hideAlertViewAnimated:YES];
                                   [strongSelf wechatPay];
                               }
                           }];
}

-(UIView*)customAlertView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    NSString *title =@"当前还款金额较大\n建议使用以下银行还款\n中国银行\n平安银行\n中信银行\n兴业银行\n招商银行\n光大银行\n民生银行\n广发银行\n浦发银行\n华夏银行";
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,230)];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:title];
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:15];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = VVclearColor;
        lab.attributedText = attrStr;
        [view addSubview:lab];
    return view;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.repayBtn.bounds;
    [self.repayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repayBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.repayBtn setTitle:@"立即还款" forState:UIControlStateNormal];
}

-(void)setUpNavigation{
    [self setNavigationBarTitle:@"账单还款"];
    [self addBackButton];
}

-(void)setupSubView{
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithWholeRed:241 green:244 blue:246];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource  =  self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"JJOrderTableViewCell" bundle:nil] forCellReuseIdentifier:repaymentOrderCell];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.top.mas_equalTo(_scrollView.mas_top).offset(0);
    }];//masonry这里用self.view
    self.tableView = tableView;
    [_scrollView addSubview:self.repayBtn];
    [_scrollView bringSubviewToFront:self.repayBtn];
//    _scrollView.contentSize = CGSizeMake(vScreenWidth, 55 * 15);//

    [self.repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(80);
        make.right.equalTo(self.view.mas_right).offset(-80);
        make.bottom.equalTo(self.view.mas_bottom).offset(-21);
        make.height.equalTo(@45);
    }];
    
    [_scrollView addSubview:self.showWebBtn];
    [self.showWebBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(-195);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 44));
    }];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.locations = @[@0,@1.0f];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5f);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5f);
    [self.repayBtn.layer addSublayer:self.gradientLayer];
    self.gradientLayer.colors = @[(__bridge id)RGB(255, 199, 150).CGColor,
                                  (__bridge id)RGB(255, 107, 149).CGColor];
}

-(void)showWebBtnClick{
    JJWKWebViewViewController *wkwebVc = [[JJWKWebViewViewController alloc]init];
    wkwebVc.isNavHidden = NO;
    [wkwebVc loadWebURLSring: [NSString stringWithFormat:@"%@/quota.html",WEB_BASE_URL]];
    [self.navigationController pushViewController:wkwebVc animated:YES];
}

-(void)repayBtnClick{
    
    if(!self.selIndex || self.selIndex.row == 5){
        // 先判断是否安装微信
        if (!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])) {
            [VLToast showWithText:@"您未安装最新版本微信，不支持微信支付，请安装或升级微信版本"];
            return;
        }
        if ([_payBill floatValue] > 10000) {
            [self showAlertCustomerView];
        }else{
            [self wechatPay];
        }
    }else{
        // [self pusWebPayVC];
        //银联支付
        if ([_payBill floatValue] > 2000) {
            NSString * msg = [NSString stringWithFormat:@"当前还款金额超出银联支付上限，请将款项存入尾号%@的银行卡中，等待系统自动扣款",self.bankAccount];
            [VVAlertUtils showAlertViewWithTitle:@"" message:nil customView:[self customerAlertViewWith:msg] cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != kCancelButtonTag) {
                    [alertView hideAlertViewAnimated:YES];
                }
            }];
        }else{
            [self testPush];
        }
    }
}

-(void)wechatPay{
    VVLog(@"wechatPay=============");
    JJWechatPayRequest *request = [[JJWechatPayRequest alloc] initWithType:self.urlType] ;
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJWechatPayModel *model = [(JJWechatPayRequest *)request response];
        if (model.success) {
            JJWechatPayDataModel * data = model.data;
            [[PayToolsManager defaultManager] startWeChatPayWithAppId:data.appId timeStamp:data.timeStamp nonceStr:data.nonceStr packageValue:data.packageValue paySign:data.paySign partnerid:data.partnerid prepayid:data.prepayid paySuccess:^{
                VVLog(@"========微信支付成功========");
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [VLToast showWithText:@"微信支付成功"];
                [strongSelf paySuccessed:^{
                    [strongSelf wechatPayViewReturnLogic];
                }];
            } payFaild:^(NSString *desc) {
                VVLog(@"=======微信支付失败===========");
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [VLToast showWithText:desc];
                [strongSelf wechatPayViewReturnLogic];
                
            }];
        }else{
            [VVAlertUtils showAlertViewWithTitle:@"" message:nil customView:[self showAlertViewWith:model.message] cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != kCancelButtonTag) {
                    [alertView hideAlertViewAnimated:YES];
                }
            }];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"调用微信失败，请稍后再试"];
    }];
}

-(void)showfirstAlertView{
    NSString *str = @"若您未完成主动还款支付全过程，为保证账单对账准确，可能会暂时冻结您的账单哦！若账单被冻结请等待一小时后重新操作，长时间未解冻请及时联系客服！";
    [VVAlertUtils showAlertViewWithTitle:@"提示" message: nil customView:[self showfirstAlertViewWith:str] cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != kCancelButtonTag) {
            [alertView hideAlertViewAnimated:YES];
        }
    }];
}

-(UIView *)showfirstAlertViewWith:(NSString*)message{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 210, 260)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 210,180)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:message];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,12)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(28,8)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(45, 10)];
    lab.attributedText = attrStr;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = message;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:15];
    [view addSubview:lab];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_repayment"]];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom).offset(0);
        make.centerX.mas_equalTo(lab.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    return view;
}

-(UIView *)showAlertViewWith:(NSString*)message{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 210, 260)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 210,180)];
    lab.text = message;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:15];
    [view addSubview:lab];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_repayment"]];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom).offset(0);
        make.centerX.mas_equalTo(lab.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    return view;
}

- (UIView *)customerAlertViewWith:(NSString*)str
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 210, 100)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 210,90)];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:15];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:VVBASE_OLD_COLOR range:NSMakeRange(8, 4)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(23, 4)];
    [attrStr addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:NSMakeRange(23, 4)];
    lab.attributedText = attrStr;
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    return view;
}


- (void)pusWebPayVC
{
    NSString *token = [UserModel currentUser].token;
    NSString *urlType = self.urlType;
    JJWKWebViewViewController *wkwebVc = [[JJWKWebViewViewController alloc]init];
    __weak __typeof(self)weakSelf = self;
    wkwebVc.payBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf wechatPayViewReturnLogic];
    };
    wkwebVc.isNavHidden = NO;
    [wkwebVc loadWebURLSring: [NSString stringWithFormat:@"%@/unionPay.html?token=%@&type=%@",WEB_BASE_URL,token,urlType]];
    [self.navigationController pushViewController:wkwebVc animated:YES];
}


-(void)testPush{
    __weak __typeof(self)weakSelf = self;
    NSString *token = [UserModel currentUser].token;
    NSString *urlType = self.urlType;
    JJUnionPayWebViewController *webVC = [[JJUnionPayWebViewController alloc]init];
    NSString *url = [NSString stringWithFormat:@"%@/unionPay.html?token=%@&type=%@",WEB_BASE_URL,token,urlType];
    webVC.startPage = url;
    webVC.webTitle = @"银联支付";
    webVC.paySuccess = ^(BOOL isSuccess) {
        if (isSuccess) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf wechatPayViewReturnLogic];
        }
    };
    [self customPushViewController:webVC withType:nil subType:nil];
}

-(void)wechatPayViewReturnLogic{
    if( [_source isEqualToString:@"billWeb" ]){   //prepay 返回账单web页面
        //                    [VV_NC postNotificationName:@"prepayNotifcation" object:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }else if([_source isEqualToString:@"homeView" ]){  //返回home页面
        //                    [VV_NC postNotificationName:@"overdueNotifcation" object:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

//告诉后台支付成功了
-(void)paySuccessed:(void (^)())finish{
    JJWchatPaySuccessedRequest *request = [[JJWchatPaySuccessedRequest alloc]initWithType:self.urlType];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]init];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        if ([[request.responseJSONObject safeObjectForKey:@"success"] boolValue]){
            if (finish) {
                finish();
            }
        }else{
           [MBProgressHUD showError:[request.responseJSONObject safeKeyForValue:@"message"]];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        if (finish) {
            finish();
        }
    }];
}

#pragma ========UItableViewDelegate==========
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JJOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:repaymentOrderCell];
    switch (indexPath.row) {
        case 0:
            cell.lable.text =@"账单期数:";
            cell.detialLabel.text = _billDate;
            cell.leftImg.hidden = YES;
            cell.rightImg.hidden = YES;
            cell.weixinLab.hidden = YES;
            break;
        case 1:
            cell.lable.text =@"未到期账单:";
            cell.detialLabel.text = _undueBill;
            cell.leftImg.hidden = YES;
            cell.rightImg.hidden = YES;
            cell.weixinLab.hidden = YES;
            break;
        case 2:
            cell.lable.text =@"逾期账单:";
            cell.detialLabel.text = _dueBill;
            cell.leftImg.hidden = YES;
            cell.rightImg.hidden = YES;
            cell.weixinLab.hidden = YES;
            break;
        case 3:
            cell.lable.text =@"欠费手续费金额:";
            cell.detialLabel.text = _dueProceduresAmt;
            cell.leftImg.hidden = YES;
            cell.rightImg.hidden = YES;
            cell.weixinLab.hidden = YES;
            break;
        case 4:
            cell.lable.text =@"还款金额:";
            cell.detialLabel.text = _payBill ;
            cell.leftImg.hidden = YES;
            cell.rightImg.hidden = YES;
            cell.weixinLab.hidden = YES;
            break;
        case 5:
            cell.leftImg.hidden = NO;
            cell.rightImg.hidden = NO;
            cell.weixinLab.hidden = NO;
            cell.leftImg.image = [UIImage imageNamed:@"icon_weixin"];
            if(self.selIndex == nil || self.selIndex.row == 5){
                cell.rightImg.image = [UIImage imageNamed:@"btn_round_check"];
            }else{
                cell.rightImg.image = [UIImage imageNamed:@"btn_round_grey"];
            }
            cell.weixinLab.text = @"微信支付";
            break;

        case 6:
            cell.leftImg.hidden = NO;
            cell.rightImg.hidden = NO;
            cell.weixinLab.hidden = NO;
            cell.leftImg.image = [UIImage imageNamed:@"icon_yinlian"];
            if(self.selIndex == nil || self.selIndex.row == 5){
            cell.rightImg.image = [UIImage imageNamed:@"btn_round_grey"];
            }else{
                cell.rightImg.image = [UIImage imageNamed:@"btn_round_check"];
            }
            cell.weixinLab.text = @"银联支付";
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= 4 || indexPath.row == self.selIndex.row) {
        return;
    }
    self.selIndex = indexPath;
    VVLog(@"index.row = %ld",indexPath.row);
    [tableView reloadData];
}

@end
