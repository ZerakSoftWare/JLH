//
//  JJCheckProgressViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/4/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJCheckProgressViewController.h"
#import "JJCheckProgressTableViewCell.h"
#import "JJH5SignViewController.h"
#import "JJGetApplyInfoByCustomerIdRequest.h"
#import "VVVcreditSignWebViewController.h"
#import "JJCheckProgressModel.h"
#import "JJVersionSourceManager.h"
#import "JJZhimaWebViewController.h"

typedef NS_ENUM(NSInteger ,ShowViewStatus ){
    informationGetting,
    amountApprovaling
};

@interface JJCheckProgressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_pesonalImageBase64;

}
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) UIImageView * statusImgView;
@property(nonatomic,strong) UILabel * statusLab;
@property(nonatomic,strong) UILabel * statusDetialLab;
@property(nonatomic,strong) VVCommonButton * knowBtn;
@property (nonatomic, copy) NSString *applicantName;

@property (nonatomic, copy) NSString *huaBeiDetialText;
@property (nonatomic, copy) NSString *mobileDetialText;
@property (nonatomic, copy) NSString *zhimaDetialText;
@property (nonatomic, copy) NSString *creditDetialText;

@property(nonatomic,assign) BOOL isHuaBeiGot;
@property(nonatomic,assign) BOOL isMobileGot;
@property(nonatomic,assign) BOOL isZhimaGot;
@property(nonatomic,assign) BOOL isCreditGot;

@property(nonatomic,assign) ShowViewStatus showViewStatus;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *labelText;
@property (nonatomic, copy) NSString *detialLabelText;

//定时器
@property (nonatomic, strong) NSTimer *previewTimer;
@property(nonatomic,strong) NSTimer * crawlerStateTimer;

@property(nonatomic,strong) JJCheckProgressModel * progressModel;
@property(nonatomic,strong) MBProgressHUD * hud;


@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL needRefresh;
@end

@implementation JJCheckProgressViewController

static NSString *const checkProgressCell = @"checkProgressCell";

//如果是代码 xib 创建ViewController 则JCRouter会调用此方法
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        VVLog(@"%@", params);
        self.needRefresh = [[params objectForKey:@"needRefresh"] boolValue];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self refreshView];
    }else{
        self.progressModel = [[JJCheckProgressModel alloc] init];
        self.progressModel.customerId = [UserModel currentUser].customerId;
        self.progressModel.mobileBill = @"1";
        self.progressModel.sesameCredit = @"1";
        self.progressModel.creditReport = @"2";
        [self analysisModel];
    }
}

- (void)dealloc
{
    [_crawlerStateTimer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.backgroundColor = [UIColor colorWithWholeRed:241 green:244 blue:246];
     _scrollView.frame = CGRectMake(0, 64, vScreenWidth, vScreenHeight-64);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initViewShowStatues];
    [self analysisModel];
    [self setUpNavigation];
    [self setUpTableView];
    [self setUpSubView];
    

}

-(void)refreshView{
    if (nil == _hud) {
        _hud = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
        [self.view addSubview:_hud];
    }
    [self.hud show:YES];
    [[VVNetWorkUtility netUtility] getApplyProgressCustomerId:[UserModel currentUser].customerId success:^(id result) {
        [self.hud hide:NO];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            
            JJCheckProgressModel *progressModel = [JJCheckProgressModel mj_objectWithKeyValues:result[@"data"]];
            self.progressModel = progressModel;
            
//            NSDictionary *params = @{@ "customerId":@"468874",@"applyId":@"341604",@"huaBei":@"1",@"mobileBill":@"3",@"sesameCredit":@"1",@"creditReport":@"3"};
//            JJCheckProgressModel *progressModel = [JJCheckProgressModel mj_objectWithKeyValues:params];
//            self.progressModel = progressModel;
            
            [self analysisModel];

        }else{
            [MBProgressHUD showError:[result safeObjectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:NO];
        [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];
        
    }];

}

-(void)initViewShowStatues{
    _isZhimaGot = NO;
    _isCreditGot = NO;
    _isHuaBeiGot = NO;
    _isZhimaGot = NO;
    _showViewStatus = informationGetting;
}

-(void)analysisModel{
    if (self.progressModel) {
        
            switch ([self.progressModel.huaBei integerValue]) {
                case 0:
                    _huaBeiDetialText = @"无";
                    break;
                case 1:
                    _huaBeiDetialText = @"已获取";
                    _isHuaBeiGot = YES;
                    break;
                case 2:
                    _huaBeiDetialText = @"获取中";
                    
                    break;
                case 3:
                    _huaBeiDetialText = @"二维码登录失效，请重新登陆";
                    break;
                default:
                    break;
            }
            
            switch ([self.progressModel.mobileBill integerValue]) {
                case 0:
                    _mobileDetialText = @"无";
                    break;
                case 1:
                    _mobileDetialText = @"已获取";
                    _isMobileGot = YES;
                    break;
                case 2:
                    _mobileDetialText = @"获取中";
                    break;
                case 3:
                    _mobileDetialText = @"获取失败，请重新获取";
                    break;
                default:
                    break;
            }
            
            switch ([self.progressModel.sesameCredit integerValue]) {
                case 0:
                    _zhimaDetialText = @"无";
                    break;
                case 1:
                    _zhimaDetialText = @"已获取";
                    _isZhimaGot = YES;
                    break;
                case 2:
                    _zhimaDetialText = @"获取失败，请重新获取";
                    break;
                default:
                    break;
            }

            switch ([self.progressModel.creditReport integerValue]) {
                case 0:
                    _creditDetialText = @"无";
                    break;
                case 1:
                    _creditDetialText = @"已获取";
                    _isCreditGot = YES;
                    break;
                case 2:
                    _creditDetialText = @"获取中";
                    break;
                case 3:
                    _creditDetialText = @"征信授权签名未通过，请重签";
                    break;
                default:
                    break;
            }
        
//        if ([[JJVersionSourceManager versionSourceManager].versionSource integerValue] == 0){
//            if (_isHuaBeiGot && _isZhimaGot && _isMobileGot &&_isCreditGot) _showViewStatus = amountApprovaling;
//        }else{
            if (_isZhimaGot && _isMobileGot && _isCreditGot)_showViewStatus = amountApprovaling;
//        }
        
        [self.tableView reloadData];
        
    }
}

-(void)setUpSubView{
    
    switch (_showViewStatus) {
        case informationGetting:
            _imageName = @"dataAcquisitionImg";
            _labelText = @"资料获取中";
            _detialLabelText = @"正在获取额度审批所需的相关资料，获取完成后系统将自动审批额度，请耐心等待";
            break;
        case amountApprovaling:
            _imageName = @"approvalMoneyImg";
            _labelText = @"额度审批中";
            _detialLabelText = @"您的信息已提交成功，审批可能需要1-2小时请耐心等待...";
            break;
     
        default:
            break;
    }
    
     NSString *imgName = _imageName;
    UIImageView * statusImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    [_scrollView addSubview:statusImgView];
    self.statusImgView = statusImgView;

    [statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 160));
    }];
    
    NSString *labText = _labelText;
    UILabel * statusLab = [[UILabel alloc]init];
    statusLab.textColor = [UIColor globalThemeColor];
    statusLab.textAlignment = NSTextAlignmentCenter;
    statusLab.font = [UIFont systemFontOfSize:24.f];
    statusLab.text = labText;
    [_scrollView addSubview:statusLab];
    self.statusLab = statusLab;

    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusImgView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(24);
        
    }];
    
    NSString *detialLabText = _detialLabelText;
    UILabel * statusDetialLab = [[UILabel alloc]init];
    statusDetialLab.textColor = VVColor666666;
    statusDetialLab.textAlignment = NSTextAlignmentCenter;
    statusDetialLab.font = [UIFont systemFontOfSize:12.f];
    statusDetialLab.numberOfLines = 0;
    statusDetialLab.text = detialLabText;
    [_scrollView addSubview:statusDetialLab];
    self.statusDetialLab = statusDetialLab;

    [statusDetialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(18);
        make.right.mas_equalTo(self.view.mas_right).offset(-18);
        
    }];
    
    VVCommonButton *knowBtn = [VVCommonButton solidButtonWithTitle:@"知道了"];
    [knowBtn addTarget:self action:@selector(hnowBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:knowBtn];
    self.knowBtn = knowBtn;

    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusDetialLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(18);
        make.right.mas_equalTo(self.view.mas_right).offset(-18);
        make.height.equalTo(@44);
    }];
    [_scrollView layoutIfNeeded];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, self.knowBtn.bottom + 30);

    
}

-(void)hnowBtnClick{
    [[JCRouter shareRouter]popViewControllerAnimated:YES];
}

-(void)setUpTableView{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithWholeRed:241 green:244 blue:246];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource  =  self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"JJCheckProgressTableViewCell" bundle:nil] forCellReuseIdentifier:checkProgressCell];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left);
        make.width.equalTo(_scrollView.mas_width);
        make.height.mas_equalTo(@220);
        make.top.mas_equalTo(_scrollView.mas_top).offset(0);
    }];
    self.tableView = tableView;

}

-(void)setUpNavigation{
    [self setNavigationBarTitle:@"进度查看"];
    [self addBackButton];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JJCheckProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:checkProgressCell];
    if (indexPath.row == 0) {
        cell.Label.text = @"手机账单";
        cell.detialLabel.text = _mobileDetialText;
        if ([self.progressModel.mobileBill integerValue] == 0 || [self.progressModel.mobileBill integerValue] == 1 ||[self.progressModel.mobileBill integerValue] == 2) {
            cell.arrow_right.hidden = YES;
        }else{
            cell.arrow_right.hidden = NO;
        }
        if(_isMobileGot){
            cell.detialLabel.textColor = [UIColor greenColor];
        }else{
            cell.detialLabel.textColor = [UIColor redColor];
        }
        
    }else if (indexPath.row == 1){
        cell.Label.text = @"芝麻信用";
        cell.detialLabel.text = _zhimaDetialText;
        if ([self.progressModel.sesameCredit integerValue] ==0 || [self.progressModel.sesameCredit integerValue] ==1) {
            cell.arrow_right.hidden = YES;
        }else{
            cell.arrow_right.hidden = NO;
        }
       
        if(_isZhimaGot){
            cell.detialLabel.textColor = [UIColor greenColor];
        }else{
            cell.detialLabel.textColor = [UIColor redColor];
        }

    }else if (indexPath.row == 2){
        cell.Label.text = @"征信报告";
        cell.detialLabel.text = _creditDetialText;
        if ([self.progressModel.creditReport integerValue] ==0 ||[self.progressModel.creditReport integerValue] ==1 || [self.progressModel.creditReport integerValue] ==2) {
            cell.arrow_right.hidden = YES;
        }else{
            cell.arrow_right.hidden = NO;
        }
        
        if(_isCreditGot){
            cell.detialLabel.textColor = [UIColor greenColor];
        }else{
            cell.detialLabel.textColor = [UIColor redColor];
        }
        
    }else if(indexPath.row == 3){
        cell.Label.text = @"花呗额度";
        cell.detialLabel.text = _huaBeiDetialText;
        if ([self.progressModel.huaBei integerValue] ==0 ||[self.progressModel.huaBei integerValue] ==1|| [self.progressModel.huaBei integerValue] ==2) {
            cell.arrow_right.hidden = YES;
        }else{
            cell.arrow_right.hidden = NO;
        }

        if(_isHuaBeiGot){
            cell.detialLabel.textColor = [UIColor greenColor];
        }else{
            cell.detialLabel.textColor = [UIColor redColor];
        }
        
//        if ([[JJVersionSourceManager versionSourceManager].versionSource integerValue] == 0) {
//            cell.hidden = NO;
//        }else{
            cell.hidden = YES;
//        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        if ([self.progressModel.mobileBill integerValue] == 0 || [self.progressModel.mobileBill integerValue] == 1 ||[self.progressModel.mobileBill integerValue] == 2) return;
        [self getMobileBillStatues];
    }else if (indexPath.row == 1){
        if ([self.progressModel.sesameCredit integerValue] ==0 || [self.progressModel.sesameCredit integerValue] ==1  ) return;
        [self pushToZhiMa];
    }else if (indexPath.row == 2){
        if ([self.progressModel.creditReport integerValue] ==0 ||[self.progressModel.creditReport integerValue] ==1 || [self.progressModel.creditReport integerValue] ==2) return;
        [self creditReport];
    }else if(indexPath.row == 3){
        if ([self.progressModel.huaBei integerValue] ==0 ||[self.progressModel.huaBei integerValue] ==1|| [self.progressModel.huaBei integerValue] ==2) return;
        [self goToHuaBei];
    }
    
}

-(void)goToHuaBei{
    [[JCRouter shareRouter] pushURL:@"huabei/1"];
}

/// 该段代码走不到
-(void)pushToZhiMa{
//    NSDictionary * dic =  @{@"Identity":VV_SHDAT.orderInfo.applicantIdcard,
//                            @"Name":VV_SHDAT.orderInfo.applicantName
//                            };
//    [[JCRouter shareRouter] pushURL:@"zhiMaWebView" extraParams:dic animated:YES];
    

    JJZhimaWebViewController *testVC = [[JJZhimaWebViewController alloc] init];
    testVC.identity = VV_SHDAT.orderInfo.applicantIdcard;
    testVC.name = VV_SHDAT.orderInfo.applicantName;
    testVC.webTitle = @"芝麻授信";
    testVC.authorizationSuccessBlockSuccBlock = ^(NSString *score){
        
        
    };
    [self customPushViewController:testVC withType:nil subType:nil];

}



-(void)getMobileBillStatues{

    [self crawlerStateTimerRunLoop];
            
}


-(void)creditReport{
    [self getCustomerInfo];
}

-(void)crawlerStateTimerRunLoop{
    if(_crawlerStateTimer)[ _crawlerStateTimer invalidate];
    _crawlerStateTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(queryMobileGetCrawlerState:) userInfo:nil repeats:YES];
    [_crawlerStateTimer fire];
}

#pragma mark - 手机账单
//获取手机采集状态抓单http://10.138.60.43:7008/mobile/query/GetCrawlerStateById/Json
- (void)queryMobileGetCrawlerState:(void (^)( BOOL succ))success{
    VVLog(@"查询手机账单");
    
    NSString *mobileBillId = VV_SHDAT.orderInfo.mobileBillId;
    
    if (nil == mobileBillId) {
        [VLToast showWithText:@"未获取手机账单，请重新获取"];
        
        return;
    }
    NSDictionary *dic = @{@"id":mobileBillId
                          };
    
    NSString *str = [dic mj_JSONString];
    NSString *base64 = [str base64EncodedString];
    VVLog(@"base64 ==%@",base64);
    __weak __typeof(self) weakSelf = self;
    [[VVNetWorkUtility netUtility] postMobileQueryGetCrawlerStateByIdSoapMessage:base64 success:^(id result)
     {
         
         NSDictionary *rsultDic = (NSDictionary *)result;
         
         if ([rsultDic[@"StatusCode"]integerValue] == 0) {
             NSString *mobileRsult = rsultDic[@"Result"];
             NSDictionary *mobileDic = [mobileRsult mj_JSONObject];
             if([mobileDic[@"Code"]integerValue] ==100){ //采集中
                 
             }else if([mobileDic[@"Code"]integerValue] == 201){//成功
                 [_crawlerStateTimer invalidate];
                 
                 __strong __typeof(weakSelf)strongSelf = weakSelf;
                 [strongSelf setMobieBillResultsuccess:^(id result) {
                     
                 } failure:^(NSError *error) {
                     
                 }];
                 
             }else{ //告诉后台去抓账单
//                 [self getAddMobileBillRecord:^(BOOL succ) {
//                     
//                 }];
             }
             
         }else{
             
         }
         
     } failure:^(NSError *error) {
         
     }];
    
}


-(void)getAddMobileBillRecord:(void (^)( BOOL succ))success{
    
    [[VVNetWorkUtility netUtility] getAddMobileBillRecordCustomerId:[UserModel currentUser].customerId success:^(id result) {
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            
            NSDictionary *dic =  [result safeObjectForKey:@"data"];
            NSInteger applyTimes  = [dic[@"applyTimes"] integerValue] ;
            NSInteger status = [dic[@"status"] integerValue];
            
            
            if (applyTimes == 0) {
                
                [VVAlertUtils showAlertViewWithTitle:@"提示" message:@"是否授权获取手机账单" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"是"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != kCancelButtonTag) {
                        [MobClick event:@"authorization_preview"];
                        [alertView hideAnimated:YES];
                        
                        if (status == 1) { //成功  调预审
                            [self postApplyPreview:^(BOOL succ) {
                                
                            }];
                        }else if (status == 2){//失败
                            
                            [self getAddMobileBillRecord:^(BOOL succ) {
                                
                            }];
                            
                        }else if (status == 0){//调取中  不处理
                            
                        }
                    }
                }];
                
            }else if (applyTimes > 1){  //成功applyTimes 结束 失败 走过1 所以大于1
                
                if (status == 1) { //成功  调预审
                    [self postApplyPreview:^(BOOL succ) {
                        
                    }];
                    
                }else if (status == 2){//失败 不处理
                    
                }else if (status == 0){//调取中  不处理
                    
                }
            }
            
        }else{
            
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
        }
        
    } failure:^(NSError *error) {
        [VLToast showWithText:[self strFromErrCode:error]];
        
    }];
    
    
}


-(void)postApplyPreview:(void (^)( BOOL succ))success{
    [MobClick event:@"apply_preview"];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postApplyPreviewCustomerId:[UserModel currentUser].customerId success:^(id result) {
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSDictionary * dataDic = [result safeObjectForKey:@"data"];
            NSInteger applyStep = [[dataDic safeObjectForKey:@"applyStep"] integerValue];
            NSInteger intervalSecond = [[dataDic safeObjectForKey:@"intervalSecond"] integerValue];
            if ((applyStep == 2 )|| (applyStep == 34 ) ) {
                //切换账号的时候cancel掉定时器
                if (strongSelf.previewTimer) {
                    [strongSelf.previewTimer invalidate];
                }
                strongSelf.previewTimer = [NSTimer scheduledTimerWithTimeInterval:intervalSecond target:self selector:@selector(postApplyPreview:) userInfo:nil repeats:NO];
                
            }else{
                if (strongSelf.previewTimer) {
                    [strongSelf.previewTimer invalidate];
                }
            }
            
        }else{
            
            if (!VV_IS_NIL(result[@"message"])) {
                [VLToast showWithText:result[@"message"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)setMobieBillRecord:(void(^)(BOOL succ))success{
    
    [[VVNetWorkUtility netUtility ] getApplySetMobileBillRecordCustomerId:[UserModel currentUser].customerId success:^(id result) {
        VVLog(@"特殊跳setMobileBillRecord");
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            if (success) {
                success(YES);
            }
        }
       
    } failure:^(NSError *error) {
        
    }];
}

-(void)setMobieBillResultsuccess:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure{
    
    [[VVNetWorkUtility netUtility] getApplySetMobileBillResultCustomerId:[UserModel currentUser].customerId Result:@"1" success:^(id result) {
        VVLog(@"特殊跳setMobileBillResult");
        if (success) {
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)getCustomerInfo
{
    [self showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
        [self hideHud];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            strongSelf.cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
            strongSelf.name = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantName"];
            
            if (strongSelf.cardId == nil) {
                [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
                return ;
            }
            [strongSelf gotoSign];
            
        }else{
            [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
    }];
}

- (void)gotoSign
{
    VVVcreditSignWebViewController *credictVc = [[VVVcreditSignWebViewController alloc]init];
    credictVc.webTitle = @"电子签名";
    NSString *url = [WEB_BASE_URL stringByAppendingString:@"/sign.html"];
    NSString *urlStarPage = [NSString stringWithFormat:@"%@?name=%@&idcard=%@&customerId=%@&token=%@",url,self.name,self.cardId,[UserModel currentUser].customerId,[UserModel currentUser].token];
    urlStarPage = [urlStarPage stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    credictVc.startPage = urlStarPage;
    credictVc.signSuccBlock = ^(NSString *pesonalImageBase64){
        [self postRecordOrgSignImage:^(BOOL succ) {
            
        }];
    };
    [self customPushViewController:credictVc withType:nil subType:nil];
}


-(void)postRecordOrgSignImage:(void (^)( BOOL succ))success{
    
    NSDictionary *params = @{
                             @"customerId": [UserModel currentUser].customerId,
                             @"imageBase64":@"" ,
                             @"signImageBase64": _pesonalImageBase64
                             };
    
    [self showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] postRecordOrgSignImageParameters:params success:^(id result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideHud];
        
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
        [strongSelf hideHud];
        [VLToast showWithText:[strongSelf strFromErrCode:error]];
        if (success) {
            success(NO);
        }
    }];
    
}

@end
