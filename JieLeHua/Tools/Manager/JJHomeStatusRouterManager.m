//
//  JJHomeStatusRouterManager.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/11.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJHomeStatusRouterManager.h"
#import "JJH5SignViewController.h"
#import "VVTabBarViewController.h"
#import "JJGetApplyInfoByCustomerIdRequest.h"
#import "JJGetApplyProgressRequest.h"
#import "JJVersionSourceManager.h"
#import "JJHomeStatusRequest.h"
#import "JJRepayInfoRequest.h"


@interface JJHomeStatusRouterManager ()
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation JJHomeStatusRouterManager
+ (JJHomeStatusRouterManager *)homeStatusRouterManager
{
    static dispatch_once_t onceToken;
    static JJHomeStatusRouterManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)dealWithStatus:(HomeStatus)status data:(JJMainStateModel *)data
{
    switch (status) {
        case HomeStatus_NoAmount:
        {
            //已登录，暂无额度，跳到蚂蚁花呗注册协议页面
            [[JCRouter shareRouter] pushURL:@"huabei/0"];
        }
            break;
        case HomeStatus_AmountApproving:
        {
            //额度审批中
            if (data.summary.reApply == 1) {
                [self applyBtnClicksuccess:^(id result) {
                    
                    if ([[result safeObjectForKey:@"success"] boolValue]) {
                        VVOrderInfoModel *orderInfo = nil;
                        NSDictionary *resultData = [result safeObjectForKey:@"data"];
                        
                        orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
                        VV_SHDAT.orderInfo = orderInfo;
                        
                        VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
                        VV_SHDAT.creditBaseInfoModel = baseInfoModel;
                        
                        JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
                        VV_SHDAT.authenticationModel = authenticationModel;
                        VV_SHDAT.timestamp =  result[@"timestamp"];
                        
                        [self getApplyProgressWithCustomerId];
                        
                    }else{
                        VVLog(@"结束时间%@",[NSDate date]);
                        [MBProgressHUD showError:@"信息不正确，请刷新页面重试"];
                    }
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];
                    
                }];
            }else{
                [[JCRouter shareRouter] pushURL:@"checkProgress/0" extraParams:nil] ;
            }
        }
            break;
        case HomeStatus_AmountInvalid:
            //额度失效
        {
            [[JCRouter shareRouter] pushURL:@"market" extraParams:@{@"startPage": [NSString stringWithFormat:@"%@/market.html",WEB_BASE_URL],@"webTitle":@"花花精选"}];
        }
            break;
        case HomeStatus_CanNotGetAmount:
        {
//            if ([data.data.isMemberShip isEqualToString:@"1"]) {
                [[JCRouter shareRouter] pushURL:@"market" extraParams:@{@"startPage": [NSString stringWithFormat:@"%@/market.html",WEB_BASE_URL],@"webTitle":@"花花精选"}];
//            }else{
//                //开通会员
//            }
        }
            break;
        case HomeStatus_AdvanceIn30Days:
        {
            // 30天内提现
            NSString *avaibleMoney = [NSString stringWithFormat:@"%.f",data.summary.vbsCreditMoney-data.summary.usedMoney];
            [[JCRouter shareRouter]pushURL:[NSString stringWithFormat:@"withdrawMoney/%@",avaibleMoney]];
        }
            break;
        case HomeStatus_AdvanceApproving:
        {
            //提现申请中,按钮不可点击
        }
            break;
        case HomeStatus_AdvanceApprovedWaitReviewing:
        {
            //提现申请已提交，等待电审中
            [[JCRouter shareRouter]pushURL:@"reviewStatus/signed/applyId/2/1/0"];
        }
            break;
        case HomeStatus_Advancing:
        {
            //提现中，请留意银行卡信息。
            [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
                if ([[result safeObjectForKey:@"success"] boolValue]) {
                    NSDictionary *resultData = [result safeObjectForKey:@"data"];
                    NSString *string = [NSString stringWithFormat:@"reviewStatus/signed/applyId/3/1/%@",[resultData safeObjectForKey:@"applyId"]];
                    [[JCRouter shareRouter]pushURL:string];
                }
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case HomeStatus_ReviewRefused:
        {
            //电审未通过
        }
            break;
        case HomeStatus_SignatureRefused:
        {
            //提现签名未通过
            [[JCRouter shareRouter]pushURL:@"reviewStatus/signed/applyId/2/0/0"];
        }
            break;
        case HomeStatus_NeedRepayIn7Days:
        {
            //7日内需还款，暂时没这状态
            
        }
            break;
        case HomeStatus_DeductFailured:
        {
            //本期扣款失败，暂时没这状态
            
        }
            break;
        case HomeStatus_NeedRepayImmediately:
        {
            //有逾期账单请及时还款，暂时没这状态
            
        }
            break;
        case HomeStatus_Huabei:
        {
            //花呗进度条页面
            [[JCRouter shareRouter]pushURL:@"huabei/0"];
            //            [self gotoHuabeiProgress];
        }
            break;
        case HomeStatus_ZhimaShouxin:
        {
            [self applyBtnClicksuccess:^(id result) {
                
                if ([[result safeObjectForKey:@"success"] boolValue]) {
                    VVOrderInfoModel *orderInfo = nil;
                    NSDictionary *resultData = [result safeObjectForKey:@"data"];
                    
                    orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.orderInfo = orderInfo;
                    
                    VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.creditBaseInfoModel = baseInfoModel;
                    
                    JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.authenticationModel = authenticationModel;
                    VV_SHDAT.timestamp =  result[@"timestamp"];
                    
                    
                    if ([orderInfo.applyStatusCode integerValue] == applyTypeBase|| [orderInfo.applyStatusCode integerValue] ==applyTypeCredit || [orderInfo.applyStatusCode integerValue] ==applyTypeMobileVerification || [orderInfo.applyStatusCode integerValue] == applyTypeZhimaScore) {
                        [[JCRouter shareRouter] pushURL:@"fillInformation"];
                        VVLog(@"结束时间%@",[NSDate date]);
                    }else{
                        [MBProgressHUD showError:@"信息不正确，请刷新页面重试"];
                    }
                }else{
                    VVLog(@"结束时间%@",[NSDate date]);
                    [MBProgressHUD showError:@"信息不正确，请刷新页面重试"];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];
                
            }];

        }
            break;
        case HomeStatus_BaseInfo:
        case HomeStatus_IdentityAuthentication:
        case HomeStatus_OrganCreditReporting:
        case HomeStatus_InternetCreditReporting:
            [self applyBtnClicksuccess:^(id result) {
                
                if ([[result safeObjectForKey:@"success"] boolValue]) {
                    VVOrderInfoModel *orderInfo = nil;
                    NSDictionary *resultData = [result safeObjectForKey:@"data"];
                    
                    orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.orderInfo = orderInfo;
                    
                    VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.creditBaseInfoModel = baseInfoModel;
                    
                    JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
                    VV_SHDAT.authenticationModel = authenticationModel;
                    VV_SHDAT.timestamp =  result[@"timestamp"];
                    
                    
                    if ([orderInfo.applyStatusCode integerValue] == applyTypeBase|| [orderInfo.applyStatusCode integerValue] ==applyTypeCredit || [orderInfo.applyStatusCode integerValue] ==applyTypeMobileVerification || [orderInfo.applyStatusCode integerValue] == applyTypeZhimaScore) {
                        [[JCRouter shareRouter] pushURL:@"fillInformation"];
                        VVLog(@"结束时间%@",[NSDate date]);
                    }else{
                        [MBProgressHUD showError:@"信息不正确，请刷新页面重试"];
                    }
                }else{
                    VVLog(@"结束时间%@",[NSDate date]);
                    [MBProgressHUD showError:@"信息不正确，请刷新页面重试"];
                }

            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];

            }];
            break;
        case HomeStatus_WithdrawalProcessed:
        {
            //提款申请
        }
            break;
        case HomeStatus_FillBankCardInfo:
        {
            //填写银行卡，直接打开添加银行卡
            [[JCRouter shareRouter]pushURL:@"addBankCard"];
        }
            break;
        case HomeStatus_FillContractInfo:
        {
            //填写提现合同，直接打开提现合同
            [self getCustomerInfo];
        }
            break;
        case HomeStatus_SignaturePassed:
        {
            //签名通过
            //提现申请已提交，电审等待中
            [[JCRouter shareRouter]pushURL:@"reviewStatus/signed/applyId/2/1/0"];
        }
            break;
        case HomeStatus_ReviewPassed:
        {
            //电审通过
            [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
                if ([[result safeObjectForKey:@"success"] boolValue]) {
                    NSDictionary *resultData = [result safeObjectForKey:@"data"];
                    NSString *string = [NSString stringWithFormat:@"reviewStatus/signed/applyId/3/1/%@",[resultData safeObjectForKey:@"applyId"]];
                    [[JCRouter shareRouter]pushURL:string];
                }
            } failure:^(NSError *error) {
                
            }];
//            [[JCRouter shareRouter]pushURL:@"reviewStatus/signed/applyId/3/1/0"];
        }
            break;
        case HomeStatus_Loaded:
        {
//            [self gotoRepay];
        }
            break;
        case HomeStatus_Termination:
        {
            //已解约，立即提现
            NSString *avaibleMoney = [NSString stringWithFormat:@"%.f",data.summary.vbsCreditMoney-data.summary.usedMoney];
            [[JCRouter shareRouter]pushURL:[NSString stringWithFormat:@"withdrawMoney/%@",avaibleMoney]];
        }
            break;
        case HomeStatus_Loading:
        {
            //放款中
            [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
                if ([[result safeObjectForKey:@"success"] boolValue]) {
                    NSDictionary *resultData = [result safeObjectForKey:@"data"];
                    NSString *string = [NSString stringWithFormat:@"reviewStatus/signed/applyId/3/1/%@",[resultData safeObjectForKey:@"applyId"]];
                    [[JCRouter shareRouter]pushURL:string];
                }
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case HomeStatus_RepayingPleWaiting:
        {
            //还款中,请耐心等待
        }
            break;
        case HomeStatus_LoadAndNotRepay:
        {
            //已放款，尚未还款 按钮不可点击
//            [self gotoRepay];
            
        }
            break;
        case HomeStatus_Repaying:
        {
            //还款中
        }
            break;
        case HomeStatus_RepayDone:
        {
            //还款完成
        }
            break;
        case HomeStatus_LockOrder:
        {
            //锁单
        }
            break;
        case HomeStatus_LoanAgain:
        {
            //再贷
            NSString *avaibleMoney = [NSString stringWithFormat:@"%.f",data.summary.vbsCreditMoney-data.summary.usedMoney];
            [[JCRouter shareRouter]pushURL:[NSString stringWithFormat:@"withdrawMoney/%@",avaibleMoney]];
        }
            break;
        case HomeStatus_CreditReportingSignPassed:
        {
            if (data.summary.reApply == 1) {
                [self applyBtnClicksuccess:^(id result) {
                    
                    if ([[result safeObjectForKey:@"success"] boolValue]) {
                        VVOrderInfoModel *orderInfo = nil;
                        NSDictionary *resultData = [result safeObjectForKey:@"data"];
                        
                        orderInfo = [VVOrderInfoModel mj_objectWithKeyValues:resultData];
                        VV_SHDAT.orderInfo = orderInfo;
                        
                        VVCreditBaseInfoModel *baseInfoModel = [VVCreditBaseInfoModel mj_objectWithKeyValues:resultData];
                        VV_SHDAT.creditBaseInfoModel = baseInfoModel;
                        
                        JJAuthenticationModel *authenticationModel = [JJAuthenticationModel mj_objectWithKeyValues:resultData];
                        VV_SHDAT.authenticationModel = authenticationModel;
                        VV_SHDAT.timestamp =  result[@"timestamp"];
                        
                        [self getApplyProgressWithCustomerId];
                        
                    }else{
                        VVLog(@"结束时间%@",[NSDate date]);
                        [MBProgressHUD showError:@"信息不正确，请刷新页面重试"];
                    }
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];
                    
                }];
            }else{
                if (![data.data.isMemberShip isEqualToString:@"1"]) {
                    [[JCRouter shareRouter] pushURL:@"memberArgeement" extraParams:@{@"isDrawWebPage":@"0"}];
                }else{
                    [[JCRouter shareRouter] pushURL:@"checkProgress/0" extraParams:nil] ;
                }
            }
            
        }
            break;
        case HomeStatus_CreditReportingSignRefused:
        {
            [self getApplyProgressWithCustomerId];
//            [[JCRouter shareRouter]pushURL:@"reviewStatus/signed/applyId/1/0/0"];
        }
            break;
        case HomeStatus_Repayment_Normal_Doing:
        {
            //正常还款中
            [self gotoRepay:data.summary.customerBillId period:data.summary.postLoanPeriod];
        }
            break;
        case HomeStatus_Repayment_Overdate_Not:
        {
            //逾期未还款
            [self gotoAdan:data.summary.customerBillId period:data.summary.postLoanPeriod];
        }
            break;
        case HomeStatus_Repayment_Overdate_Doing:
        {
            //逾期还款中,
        }
            break;
        case HomeStatus_Repayment_Cloan_Doing:
        {
            //提前清贷中
        }
            break;
        case HomeStatus_IncreasingMoney:
        {
            [self getLastStatus];
        }
            break;
        case HomeStatus_FillContractInfoAgain:
        {
            [[JCRouter shareRouter] pushURL:@"addLinkman"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 清贷
- (void)gotoRepay:(NSString *)drawMoneyApplyId period:(NSString *)period
{
    //跳到账单详情页
    //status: 未出账:1 已逾期:2 已还款:3
    NSDictionary *param = @{
                            @"drawMoneyApplyId":drawMoneyApplyId,
                            @"status":@"1",
                            @"postLoanPeriod":period
                            };
    [[JCRouter shareRouter] pushURL:@"billDetailById" extraParams:param];
    
//    NSString *string = @"repay/1";
//    [[JCRouter shareRouter] pushURL:string];
}

#pragma mark - 逾期还款
- (void)gotoAdan:(NSString *)drawMoneyApplyId period:(NSString *)period
{
    NSDictionary *param = @{
                            @"drawMoneyApplyId":drawMoneyApplyId,
                            @"status":@"2",
                            @"postLoanPeriod":period
                            };
    [[JCRouter shareRouter] pushURL:@"billDetailById" extraParams:param];
    return;
    
//    NSString *urlType = @"1";
//    UIViewController *vc = [(VVTabBarViewController *)VV_App.tabBarController selectedViewController];
//    JJRepayInfoRequest *request = [[JJRepayInfoRequest alloc]initWithType:urlType];
//    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:vc];
//    [request addAccessory:accessory];
//    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
//        VVLog(@"%@",request.responseJSONObject);
//        JJRepayInfoModel *model = [(JJRepayInfoRequest *)request response];
//        if (model.success) {
//            JJRepayInfoDataModel *data = model.data;
//            NSString *billDate;
//            if ([urlType isEqualToString:@"1"]) {
//                billDate = @"逾期账单";
//            }else{
//                billDate  = [NSString stringWithFormat:@"%d/%d期",data.lastBillIndex,data.sumBillIndex];
//            }
//            NSString *undueBill = [NSString stringWithFormat:@"%.2f元",data.nextBillAmt];
//            NSString *dueBill = [NSString stringWithFormat:@"%.2f元",data.dueAmt];
//            NSString *payBill = [NSString stringWithFormat:@"%.2f元",data.payAmt];
//            NSString *dueProceduresAmt = [NSString stringWithFormat:@"%.2f元",data.dueProceduresAmt];
//            NSString *bankAccount = data.bankAccount;
//            NSString *showAlert;
//            if (!data.isPay) {
//                showAlert = @"show";
//            }else{
//                showAlert = @"";
//            }
//            NSDictionary *dic = @{@"source":@"homeView",
//                                  @"urlType":urlType,
//                                  @"billDate":billDate,
//                                  @"undueBill":undueBill,
//                                  @"dueBill":dueBill,
//                                  @"payBill":payBill,
//                                  @"dueProceduresAmt":dueProceduresAmt,
//                                  @"bankAccount":bankAccount,
//                                  @"showAlert":showAlert
//                                  };
//            [[JCRouter shareRouter]pushURL:@"JJRepaymentOrder" extraParams:dic animated:YES];
//
//        }else{
//            [MBProgressHUD showError:model.message];
//        }
//    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
//        [MBProgressHUD showError:@"调用微信失败，请稍后再试"];
//    }];
}

#pragma mark - 进入蚂蚁花呗页面
//- (void)gotoHuabeiProgress
//{
//    UserModel *userModel = [UserModel currentUser];
//    [[VVNetWorkUtility netUtility] getHuebeiTokenWithCustomerId:userModel.customerId success:^(id result) {
//        VVLog(@"%@",result);
//        if ([[result safeObjectForKey:@"success"] boolValue]) {
//            if ([[result safeObjectForKey:@"data"] length] == 0) {
//                [MBProgressHUD showError:@"身份认证过期，请重新认证"];
//                [[JCRouter shareRouter]pushURL:@"huabei"];
//                return ;
//            }
//            VV_SHDAT.antsToken = [result safeObjectForKey:@"data"];
//            [[JCRouter shareRouter]pushURL:[NSString stringWithFormat:@"huabeiResult/hasResult/%@/%@",[result safeObjectForKey:@"data"],@"1"]];
//        }else{
//            [MBProgressHUD showError:@"获取数据错误"];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}

-(void)applyBtnClicksuccess:(void (^)(id result))success
                    failure:(void (^)(NSError *error))failure{
    UIViewController *vc = [(VVTabBarViewController *)VV_App.tabBarController selectedViewController];
    UserModel *userModel = [UserModel currentUser];
    VVLog(@"用户id：%@",userModel.customerId);
    VVLog(@"开始时间%@",[NSDate date]);
    JJGetApplyInfoByCustomerIdRequest *request = [[JJGetApplyInfoByCustomerIdRequest alloc] initWithCustomerId:userModel.customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:vc];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"中间时间%@",[NSDate date]);
        NSDictionary *result = request.responseJSONObject;
        success(result);
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        failure(error);
    }];
}

- (void)getCustomerInfo
{
    UIViewController *vc = [(VVTabBarViewController *)VV_App.tabBarController selectedViewController];
    if (nil == _hud) {
        _hud = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:vc.view];
        [vc.view addSubview:_hud];
    }
    [self.hud show:YES];
    
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
        [self.hud hide:NO];
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"]boolValue]) {
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
        [self.hud hide:NO];
        [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
    }];
}

- (void)gotoSign
{
//    JJH5SignViewController *signVc = [[JJH5SignViewController alloc]init];
//    signVc.webTitle = @"电子签名";
//    NSString *url = [NSString stringWithFormat:@"%@/jlh-webview/webapp/sign2.html?idcard=%@&token=%@",WEB_XUSHEN_BASE_URL,self.cardId,[UserModel currentUser].token];
//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    signVc.startPage = url;
//    NSDictionary *dict = @{@"title":@"电子签名",@"url":url};
    [[JCRouter shareRouter] pushURL:[NSString stringWithFormat:@"signForhtml/cardId/token/name/%@/%@/%@/%@",@"电子签名",self.cardId,[UserModel currentUser].token,self.name]];
}


-(void)getApplyProgressWithCustomerId{
    [[JCRouter shareRouter] pushURL:@"checkProgress/1" extraParams:nil] ;
}

#pragma mark - 获取最新状态
- (void)getLastStatus
{
    JJHomeStatusRequest *request = [[JJHomeStatusRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    UIViewController *vc = [(VVTabBarViewController *)VV_App.tabBarController selectedViewController];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc]initWithShowVC:vc];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        
        NSDictionary *result = request.responseJSONObject;
        VVLog(@"成功-- %@",result);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJMainStateModel *statusModel = [JJMainStateModel mj_objectWithKeyValues:result];
        if (statusModel.success) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *huabeiFailTip = [defaults objectForKey:@"huabeiFailTip"];
            NSString *gongjijinFailTip = [defaults objectForKey:@"gongjijinFailTip"];
            if (statusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4 && statusModel.improveCreditStatus.gongjijinCreditStatus == 4){
                NSString *bothTip = [defaults objectForKey:@"bothTip"];
                if (bothTip == nil) {
                    [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您暂不满足提额要求，无法提额" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex != kCancelButtonTag) {
                            [alertView hideAlertViewAnimated:YES];
                            [defaults setObject:@"1" forKey:@"bothTip"];
                            [defaults synchronize];
                        }
                    }];
                    return;
                }
            }
            else if ((statusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4 && statusModel.improveCreditStatus.gongjijinCreditStatus == 0) || (statusModel.improveCreditStatus.antsChantFlowersCreditStatus == 0 && statusModel.improveCreditStatus.gongjijinCreditStatus == 4)) {
                if (statusModel.improveCreditStatus.gongjijinCreditStatus == 4) {
                    
                    if (gongjijinFailTip == nil) {
                        [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您的公积金缴纳情况暂不满足提额要求，无法提额!" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex != kCancelButtonTag) {
                                [defaults setObject:@"1" forKey:@"gongjijinFailTip"];
                                [defaults synchronize];
                                [alertView hideAlertViewAnimated:YES];
                                
                            }
                        }];
                        return ;
                    }
                }
                else if(statusModel.improveCreditStatus.antsChantFlowersCreditStatus == 4)
                {
                    if (huabeiFailTip) {
                        [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您的花呗额度暂不满足提额要求，无法提额!" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex != kCancelButtonTag) {
                                [defaults setObject:@"1" forKey:@"huabeiFailTip"];
                                [defaults synchronize];
                                [alertView hideAlertViewAnimated:YES];
                                
                            }
                        }];
                        return;
                    }
                    
                }
            }
            
            [[JCRouter shareRouter] pushURL:@"increaseMoney"];
            
        }else{
            [MBProgressHUD showError:@"服务器异常请稍后再试"];
        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"服务器异常请稍后再试"];
    }];
}

@end
