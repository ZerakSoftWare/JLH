//
//  AgreementViewController.m
//  JieLeHua
//
//  Created by admin on 17/3/3.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "AgreementViewController.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface AgreementViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *applyBtn;

@property (nonatomic, assign) BOOL isDrawWebPage;

@end

#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation AgreementViewController
//如果是代码 xib 创建ViewController 则JCRouter会调用此方法
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
        VVLog(@"%@", params);
        
        self.isDrawWebPage = [[params safeObjectForKey:@"isDrawWebPage"] boolValue];
        
    }
    return self;
}

#pragma mark - Properties

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_sureBtn setTitle:@" 同意并接受以上条款" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:VVColor(13, 136, 255) forState:UIControlStateNormal];
        [_sureBtn setImage:kGetImage(@"btn_unread_agree_pre") forState:UIControlStateNormal];
        [_sureBtn setImage:kGetImage(@"btn_read_agree_pre") forState:UIControlStateSelected];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureBtn addTarget:self action:@selector(readAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)applyBtn {
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBtn.userInteractionEnabled = NO;
        [_applyBtn setTitle:@"开始申请" forState:UIControlStateNormal];
        [_applyBtn setBackgroundColor:VVColor(170, 195, 226) forState:UIControlStateNormal];
        [_applyBtn setBackgroundColor:VVColor(13, 136, 255) forState:UIControlStateSelected];
        [_applyBtn setBackgroundColor:VVAppButtonTitleHeightLightColor forState:UIControlStateHighlighted];
        _applyBtn.titleLabel.font  = [UIFont systemFontOfSize:17.0];
        _applyBtn.layer.cornerRadius = 6;
        _applyBtn.clipsToBounds = YES;
        [_applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBtn;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.sureBtn.hidden = NO;
    self.applyBtn.hidden = NO;
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"会员协议"];
    [self addBackButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = VVColor(241, 244, 246);
    
    [self initAndLayoutUI];
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

- (void)initAndLayoutUI
{
    UIView *view = [[UIView alloc] init];
    view.layer.borderWidth = 1.0;//边宽
    view.layer.cornerRadius = 5.0;//设置圆角
    view.layer.borderColor = VVColor(205, 205, 205).CGColor;
    view.clipsToBounds = YES;
    [self.view addSubview:view];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    NSString *url = [NSString stringWithFormat:@"%@/hyxieyi.html?customerId=%@&token=%@",WEB_BASE_URL,[UserModel currentUser].customerId,[UserModel currentUser].token];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    webView.delegate = self;
    [view addSubview:webView];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(80);
        make.left.mas_equalTo(self.view).with.offset(12);
        make.right.mas_equalTo(self.view).with.offset(-12);
        make.bottom.mas_equalTo(self.view).with.offset(-146);
    }];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(view);
    }];
    
    self.sureBtn.hidden = YES;
    [self.view addSubview:self.sureBtn];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(260, 40));
        make.top.equalTo(view.mas_bottom);
    }];
    
    self.applyBtn.hidden = YES;
    [self.view addSubview:self.applyBtn];
    
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).with.offset(-41);
        make.left.mas_equalTo(self.view).with.offset(20);
        make.right.mas_equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
}

- (void)readAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.applyBtn.selected = !self.applyBtn.selected;
    self.applyBtn.userInteractionEnabled = self.applyBtn.selected;
}

- (void)applyAction
{
    NSDictionary *param = @{
                            @"isDrawWebPage": self.isDrawWebPage ? @"1" : @"0"
                            };
    
    [[JCRouter shareRouter] pushURL:@"memberOrder" extraParams:param];
}

- (void)backAction:(id)sender
{
    [[JCRouter shareRouter] popViewControllerAnimated:YES];
}

@end
