//
//  JJFindViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/2/17.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJFindViewController.h"
#import "JJBulletinViewController.h"
#import "JJMessageViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DeleteMessageRequest.h"
#import "IntroduceToolbarView.h"

@interface JJFindViewController ()<UIScrollViewDelegate,IntroduceToolbarViewDelegate>
{
    UIButton *_deleteBtn;
    UIScrollView *_botScroll;
    
    JJBulletinViewController *bulletinVC;
    JJMessageViewController *messageVC;
}

@property (nonatomic, strong) IntroduceToolbarView *toolbarView;

@end

@implementation JJFindViewController

- (IntroduceToolbarView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [[IntroduceToolbarView alloc] initWithFrame:CGRectMake(0, 22, 188, 32)];
        _toolbarView.delegate = self;
        _toolbarView.lightColor = VVColor(57, 158, 255);
        _toolbarView.deepColor = VVColor(13, 136, 255);
        _toolbarView.backColor = VVColor(232, 236, 239);
        _toolbarView.layer.cornerRadius = 16;
        _toolbarView.clipsToBounds = YES;
    }
    return _toolbarView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self createMessageBtnWithFind];
    [self createBottonScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![UserModel isLoggedIn] || _deleteBtn.hidden)
    {
        [self.toolbarView setSelectedBtnIndex:0];
    }
}

- (void)createMessageBtnWithFind
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5f, vScreenWidth, 0.5f)];
    line.backgroundColor = VVColor(211, 218, 222);
    
    if (iPhoneX)
    {
        navView.height = 64 + 20;
        line.y = 63.5 + 20;
    }
   
    
    [navView addSubview:line];
    [self.view addSubview:navView];
    
    /***************选项组***************/
    
    self.toolbarView.centerX = navView.centerX;
    NSArray *arry = @[@"公告",@"消息"];
    self.toolbarView.productArr = arry;
    if (iPhoneX)
    {
        self.toolbarView.y = self.toolbarView.y + 20;
    }
    [navView addSubview:self.toolbarView];
    
    [self.toolbarView setSelectedBtnIndex:0];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(vScreenWidth-80, 30, 80, 17);
    [_deleteBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:VVBASE_OLD_COLOR forState:UIControlStateNormal];
    [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
    [navView addSubview:_deleteBtn];
}

#pragma mark - IntroduceToolbarViewDelegate

- (void)topToolbar:(IntroduceToolbarView *)topToolbar didSelectedTag:(int)tag
{
    if (![UserModel isLoggedIn] && tag == 2)
    {
        [self loginAndRegisterBtnClck];
        return;
    }

    _botScroll.contentOffset = CGPointMake(self.view.frame.size.width*(tag - 1), 0);
    
    switch (tag) {
        case 1:
        {
            //--公告
            _deleteBtn.hidden = YES;
        }
            break;
        case 2:
        {
            //--消息
            _deleteBtn.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 创建下面可滑动的scrollview和两个视图控制器
- (void)createBottonScrollView
{
    _botScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight)];
    _botScroll.contentSize = CGSizeMake(vScreenWidth*2, vScreenHeight);
    _botScroll.pagingEnabled = YES;
    _botScroll.delegate = self;
    _botScroll.bounces = NO;
    _botScroll.backgroundColor = VVColor(241, 244, 246);
    _botScroll.showsHorizontalScrollIndicator = NO;
    if (iPhoneX){
        _botScroll.y = 64 + 20;
    }
    //两个按钮两个视图控制器
    bulletinVC =  [[JJBulletinViewController alloc]init];
    bulletinVC.view.frame = CGRectMake(0, 0,vScreenWidth, vScreenHeight);
    [self addChildViewController:bulletinVC];
    [_botScroll addSubview:bulletinVC.view];
    

    messageVC = [[JJMessageViewController alloc]init];
    messageVC.view.frame = CGRectMake(vScreenWidth, 0, vScreenWidth, vScreenHeight);
    [self addChildViewController:messageVC];
    [_botScroll addSubview:messageVC.view];
    
    [self.view addSubview:_botScroll];
}

#pragma mark scrollview代理方法  滑动scrollview改变按钮移动

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _botScroll) {
        
        int offSetNum = _botScroll.contentOffset.x/_botScroll.frame.size.width;
        [self.toolbarView setSelectedBtnIndex:offSetNum];
        
        //未登录情况下，划动scrollView
        if (![UserModel isLoggedIn])
        {
            _botScroll.contentOffset = CGPointMake(0, 0);
        }
    }
}

- (void)deleteBtnClick:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"确定要删除所有信息吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"全部删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self sendDeleteAllRequest];
    }];
    
    [alert addAction:updateAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendDeleteAllRequest
{
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在删除中……" toView:self.view];
    
    DeleteMessageRequest *deleteAllRequest = [[DeleteMessageRequest alloc] init];
    [deleteAllRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        
        if ([request.responseJSONObject safeObjectForKey:@"success"])
        {
            [HUD hide:NO];
            
            [messageVC.messageWeb reload];
        }
        else
        {
            [HUD bwm_hideWithTitle:request.responseJSONObject[@"message"]
                         hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }
        
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
        [HUD bwm_hideWithTitle:[self strFromErrCode:error]
                     hideAfter:kBWMMBProgressHUDHideTimeInterval];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loginAndRegisterBtnClck
{
    [[JCRouter shareRouter] presentURL:@"login" withNavigationClass:[AppNavigationController class] completion:nil];
}

#pragma mark - public
- (void)gotoMsg
{
    [self.toolbarView setSelectedBtnIndex:1];
}

@end
