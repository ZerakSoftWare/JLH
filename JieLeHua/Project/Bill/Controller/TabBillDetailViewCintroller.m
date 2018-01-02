//
//  TabBillDetailViewCintroller.m
//  JieLeHua
//
//  Created by kuang on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "TabBillDetailViewCintroller.h"
#import "UIViewController+WebViewControllerFailLoadHelper.h"
#import "IntroduceToolbarView.h"
#import "JJRepayInfoRequest.h"
#import <JavaScriptCore/JavaScriptCore.h>

#pragma mark Constants


#pragma mark - Class Extension

@interface TabBillDetailViewCintroller ()<UIWebViewDelegate,IntroduceToolbarViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) NSString *webUrl;

@property (nonatomic, strong) UIButton *repayBtn;

@property (nonatomic, assign) BOOL isOverDue;

@property (nonatomic, strong) IntroduceToolbarView *toolbarView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, copy) NSString *reloadWebUrl;

@property (nonatomic, strong) JSContext *context;
@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation TabBillDetailViewCintroller


#pragma mark - Properties

- (UIButton *)repayBtn {
    if (!_repayBtn) {
        _repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repayBtn.layer.cornerRadius = 22.5f;
        _repayBtn.clipsToBounds = YES;
        [_repayBtn addTarget:self action:@selector(repayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repayBtn;
}

- (IntroduceToolbarView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [[IntroduceToolbarView alloc] initWithFrame:CGRectMake(0, 76, 282, 32)];
        _toolbarView.delegate = self;
        _toolbarView.lightColor = VVColor(75, 231, 243);
        _toolbarView.deepColor = VVColor(88, 152, 242);
        _toolbarView.backColor = VVColor(232, 236, 239);
        _toolbarView.layer.cornerRadius = 16;
        _toolbarView.clipsToBounds = YES;
    }
    return _toolbarView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

#pragma mark - Constructors


#pragma mark - Destructor

//- (void)dealloc 
//{
//    [VV_NC removeObserver:self name:@"prepayNotifcation" object:nil];
//}


#pragma mark - Public Methods

#pragma mark - IntroduceToolbarViewDelegate

- (void)topToolbar:(IntroduceToolbarView *)topToolbar didSelectedTag:(int)tag
{
    NSMutableString *newUrlStr = nil;
    self.repayBtn.hidden = YES;
    CGFloat offset = 0.0;
    
    switch (tag) {
        case 1:
        {
            //--未出账
            newUrlStr = [NSMutableString stringWithFormat:@"%@/billDetail.html?token=%@&id=3",WEB_BASE_URL,[UserModel currentUser].token];
//            self.repayBtn.hidden = NO;
            [self.repayBtn setTitle:@"提前还款" forState:UIControlStateNormal];
            offset = -76;
        }
            break;
        case 2:
        {
            //--已逾期
            newUrlStr = [self.webUrl mutableCopy];
#pragma  self.repayBtn.hidden = !self.isOverDue;
//            self.repayBtn.hidden = NO;
            [self.repayBtn setTitle:@"偿还逾期" forState:UIControlStateNormal];
            offset = -76;
        }
            break;
        case 3:
        {
            //--已还款
            newUrlStr = [self.webUrl mutableCopy];
            [newUrlStr appendString:@"&type=yh"];
//            self.repayBtn.hidden = YES;
            
            offset = 0;
        }
            break;
            
        default:
            break;
    }
    
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(offset);
    }];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Timeout];
    [self.webView loadRequest:request];
    [self showHud];
    _reloadWebUrl = newUrlStr;
    VVLog(@"_webUrl跳转前======%@",_webUrl);
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
    
    __weak __typeof(self)weakSelf = self;
    if (_context) {
        _context = nil;
    }
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"wxRecord"] = ^(BOOL isSHow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.repayBtn.hidden = !isSHow;
        });
        
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHud];
    [self showErrorPlaceholdView:kGetImage(@"error_info") errorMsg:@"加载失败，点击重新加载"];
}

- (void)webReloadData
{
    [self hiddenFailLoadViewView];
    [self.webView reload];
}

#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    TabBillDetailViewCintroller *instance = [[TabBillDetailViewCintroller alloc] init];
    instance.webUrl = [params safeObjectForKey:@"webUrl"];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"账单明细"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackButton];
    
    [self addReloadTarget:self action:@selector(webReloadData)];
    
    [self initAndLayoutUI];
    
}



- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    VVLog(@"_webUrl返回后======%@",_reloadWebUrl);
    self.repayBtn.hidden = YES;
    if(!VV_IS_NIL(_reloadWebUrl)){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_reloadWebUrl
                                                                                 ] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Timeout];
        [self.webView loadRequest:request];
    }
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
    
    self.gradientLayer.frame = self.repayBtn.bounds;
    
    [self.repayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repayBtn.titleLabel.font = [UIFont systemFontOfSize:17];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)initAndLayoutUI
{
    [self.view addSubview:self.webView];
    
    /***************选项组***************/
    self.toolbarView.centerX = self.view.centerX;
    NSArray *arry = @[@"未出账",@"已逾期",@"已还款"];
    self.toolbarView.productArr = arry;
    [self.view addSubview:self.toolbarView];
    
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Timeout];
//    [self.webView loadRequest:request];
    [self.view addSubview:self.repayBtn];
    
    [self.repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(80);
        make.right.equalTo(self.view).offset(-80);
        make.bottom.equalTo(self.view).offset(-21);
        make.height.equalTo(@45);
    }];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.locations = @[@0,@1.0f];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5f);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5f);
    [self.repayBtn.layer addSublayer:self.gradientLayer];
    self.gradientLayer.colors = @[(__bridge id)RGB(255, 199, 150).CGColor,
                                  (__bridge id)RGB(255, 107, 149).CGColor];
    
//    //--判断已逾期中的数据是否为空
//    CGFloat offset;
    if ([_webUrl rangeOfString:@"&status=ch" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        self.isOverDue = NO;
        [self.toolbarView setSelectedBtnIndex:0];
//        offset = 0;
    }
    else
    {
        self.isOverDue = YES;
        [self.toolbarView setSelectedBtnIndex:1];
//        offset = -76;
    }
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.toolbarView.mas_bottom).offset(13);
        make.bottom.equalTo(self.view.mas_bottom).offset(-76);
    }];
    
}

- (void)repayAction
{
    NSString *urlType;
    int payTag = (int)self.toolbarView.selectedButton.tag-1989;
    if (payTag == 0)
    {
        //--提前还款
        urlType = @"2";
    }
    else
    {
        urlType = @"1";
    }
    JJRepayInfoRequest *request = [[JJRepayInfoRequest alloc]initWithType:urlType];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        VVLog(@"%@",request.responseJSONObject);
        JJRepayInfoModel *model = [(JJRepayInfoRequest *)request response];
        if (model.success) {
            JJRepayInfoDataModel *data = model.data;
            NSString *billDate;
            if ([urlType isEqualToString:@"1"]) {
                billDate = @"逾期账单";
            }else{
                billDate  = [NSString stringWithFormat:@"%d/%d期",data.lastBillIndex,data.sumBillIndex];
            }
            NSString *undueBill = [NSString stringWithFormat:@"%.2f元",data.nextBillAmt];
            NSString *dueBill = [NSString stringWithFormat:@"%.2f元",data.dueAmt];
            NSString *payBill = [NSString stringWithFormat:@"%.2f元",data.payAmt];
            NSString *dueProceduresAmt = [NSString stringWithFormat:@"%.2f元",data.dueProceduresAmt];
            NSString *bankAccount = data.bankAccount;
            NSString *showAlert;
            if (!data.isPay) {
                showAlert = @"show";
            }else{
                showAlert = @"";
            }
            NSDictionary *dic = @{@"source":@"billWeb",
                                  @"urlType":urlType,
                                  @"billDate":billDate,
                                  @"undueBill":undueBill,
                                  @"dueBill":dueBill,
                                  @"payBill":payBill,
                                  @"dueProceduresAmt":dueProceduresAmt,
                                  @"bankAccount":bankAccount,
                                  @"showAlert":showAlert
                                  };
            [[JCRouter shareRouter]pushURL:@"JJRepaymentOrder" extraParams:dic animated:YES];
            
        }else{
            [MBProgressHUD showError:model.message];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"调用微信失败，请稍后再试"];
    }];
}

@end
