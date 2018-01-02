//
//  ViewController.m
//  UPPayDemo
//
//  Created by zhangyi on 15/11/19.
//  Copyright © 2015年 UnionPay. All rights reserved.
//

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "JJUnionPayViewController.h"
#import "UPPaymentControl.h"

#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#if DEBUG
#define kMode_Development             @"01"
#else
#define kMode_Development             @"00"

#endif

#define kURL_TN_Normal                @"http://101.231.204.84:8091/sim/getacptn"
#define kURL_TN_Configure             @"http://101.231.204.84:8091/sim/app.jsp?user=123456789"




@interface JJUnionPayViewController ()

@property(nonatomic,strong) UIAlertView* alertView;
@property(nonatomic,strong) NSMutableData* responseData;
@property(nonatomic,assign) CGFloat maxWidth;
@property(nonatomic,assign) CGFloat maxHeight;
@property(nonatomic,strong) UITextField *urlField;
@property(nonatomic,strong) UITextField *modeField;
@property(nonatomic,strong) UITextField *curField;
@property(nonatomic, copy)NSString *tnMode;
@property(nonatomic, strong)UITableView *tableView;

- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;
- (void)startNetWithURL:(NSURL *)url;
- (void)buttonAction;

@end

@implementation JJUnionPayViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarTitle:@"我的订单"];
    [self addBackButton];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    btn.backgroundColor = VVRandomColor;
    [btn setTitle:@"开始支付" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    btn.centerX = kScreenWidth * 0.5;
    btn.centerY = kScreenHeight * 0.5;
    [self.view addSubview:btn];
    
}

- (void)startNetWithURL:(NSURL *)url
{
    [_curField resignFirstResponder];
    _curField = nil;
    [self showAlertWait];
    
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
}

#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
    
}

- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    
}
- (void)hideAlert
{
    if (_alertView != nil)
    {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertView = nil;
}

#pragma mark - connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        
        [self showAlertMessage:kErrorNet];
        [connection cancel];
    }
    else
    {
        
        _responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    NSLog(@"====data%@",data);
    // <38363438 39393130 39373738 38353732 31393430 30>  <38363438 39393130 39373738 38353732 31393430 30>
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"tn===%@,_responseData====%@",tn,_responseData);
    
    if (tn != nil && tn.length > 0)
    {
        
        NSLog(@"tn=%@",tn);
     BOOL isPaySuccess = [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"jielehua" mode:self.tnMode viewController:self];
        
        NSLog(@"isPaySuccess === %d",isPaySuccess);
        
    }
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showAlertMessage:kErrorNet];
}


#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:kResult, result];
    [self showAlertMessage:msg];
}

- (void)buttonAction
{
    self.tnMode = kMode_Development;
    [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
    
}


@end

