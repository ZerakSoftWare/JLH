//
//  JJWithdrawWebViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/5/26.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJWithdrawWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JJWithdrawWebViewController ()
<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) MBProgressHUD *hudV;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, assign) BOOL firstLoaded;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *name;

@end

@implementation JJWithdrawWebViewController
//如果是代码 xib 创建ViewController 则JCRouter会调用此方法
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        VVLog(@"%@", params);
        self.maxMoney = [params safeObjectForKey:@"maxMoney"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"额度提现"];
    [self addBackButton];

    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.webView.delegate = self;
    NSString *string = [NSString stringWithFormat:@"%@/vcash.html",WEB_BASE_URL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    [self.view insertSubview:self.webView aboveSubview:_scrollView];
    [self showHud];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberShip:) name:@"DrawChoosePayMethod" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)memberShip:(NSNotification *)notification
{
    NSLog(@"jack %@", notification.userInfo[@"isMemberShip"]);
    NSString *jsStr = [NSString stringWithFormat:@"contextLoaded('%@','%@','%@','%@')",[UserModel currentUser].token,[UserModel currentUser].customerId,self.maxMoney,notification.userInfo[@"isMemberShip"]];
    [self.context evaluateScript:jsStr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self hideHud];
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context = context;
    NSString *jsStr = [NSString stringWithFormat:@"contextLoaded('%@','%@','%@','%@')",[UserModel currentUser].token,[UserModel currentUser].customerId,self.maxMoney,@"0"];
    [self.context evaluateScript:jsStr];
    __weak __typeof(self)weakSelf = self;
    
    self.context[@"paymentMode"] = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongSelf choosePayMethod];
        });
    };
    
        self.context[@"router"] = ^ {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSArray *arg = [JSContext currentArguments];
            [MobClick event:@"subbmit_drawMoney"];
            for (JSValue *jsVal in arg) {
                int router = jsVal.toInt32;
                switch (router) {
                    case 1:
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [[JCRouter shareRouter]pushURL:@"addLinkman"];
                        });
                        break;
                    case 2:
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [strongSelf getCustomerInfo];
                        });
                    }
                        break;
                    case 3:
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [[JCRouter shareRouter]pushURL:@"addBankCard"];
                        });
                        break;
                    default:
                        break;
                }
            }
        };
}

#pragma mark - 选择缴纳方式

- (void)choosePayMethod
{
    [[JCRouter shareRouter] pushURL:@"choosePayMethod"];
}

#pragma mark - 去签名
- (void)getCustomerInfo
{
    [self showHud];
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
        [weakSelf hideHud];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[result safeObjectForKey:@"success"]boolValue]) {
            strongSelf.cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
            strongSelf.name = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantName"];

            if (strongSelf.cardId == nil) {
                [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
                return ;
            }
//            dispatch_sync(dispatch_get_main_queue(), ^{
            [[JCRouter shareRouter] pushURL:[NSString stringWithFormat:@"signForhtml/cardId/token/name/%@/%@/%@/%@",@"电子合同",strongSelf.cardId,[UserModel currentUser].token,strongSelf.name]];
//            });
        }else{
            [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
    }];
}

@end
