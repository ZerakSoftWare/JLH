//
//  JLHResetPasswordController.m
//  JLH
//
//  Created by YuZhongqi on 17/2/17.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JLHResetPasswordController.h"
#import "UITextField+LimitLength.h"

@interface JLHResetPasswordController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *surePsswordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *passwordFBottomLine;
@property (weak, nonatomic) IBOutlet UIView *surePsswordFBottomLine;

@end

@implementation JLHResetPasswordController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [self initWithNibName:@"JLHResetPasswordController" bundle:nil])) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationItem.title = @"重置密码";
    
    [self layoutPageSubviews];
    
    [self.passwordTextfield limitTextLength:18 block:^(NSString *text) {
        self.passwordTextfield.text = text;
    }];
    
    [self.surePsswordTextfield limitTextLength:18 block:^(NSString *text) {
        self.surePsswordTextfield.text = text;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageSubviews {
    _passwordFBottomLine.backgroundColor = [UIColor grayThemeColor];
    _surePsswordFBottomLine.backgroundColor = [UIColor grayThemeColor];
    
    [_sureButton setBackgroundImage:[UIImage imageWithColor:[UIColor globalThemeColor] size:CGSizeMake(_sureButton.frame.size.width, _sureButton.frame.size.height)] forState:UIControlStateNormal];
}

- (IBAction)sureButtonClick:(UIButton *)sender
{
    NSString *pwdStr = self.passwordTextfield.text;
    NSString *confirmPwd = self.surePsswordTextfield.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (pwdStr.length < 6 || pwdStr.length > 18) {
        error = YES;
        errorStr = @"请输入6-18位密码";
    }
    if (![pwdStr isEqualToString:confirmPwd]) {
        error = YES;
        errorStr = @"两次密码输入不一致";
    }
    if (!pwdStr.length || !confirmPwd.length) {
        error = YES;
        errorStr = @"请输入密码";
    }

    if (error) {
        [MBProgressHUD bwm_showTitle:errorStr
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
        
    NSDictionary *dic = @{
                          @"smsCode":self.verifyCodeStr,
                          @"passWord":[[self.passwordTextfield.text md5]uppercaseString],
                          @"mobile":self.phoneStr
                          };
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] postResetPasswordParameters:dic
                                                       success:^(id result)
    {
        if ([result[@"success"] integerValue] == 1)
        {
            [HUD bwm_hideWithTitle:@"重置成功"
                         hideAfter:kBWMMBProgressHUDHideTimeInterval];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self turnBack];
            });
        }
        else
        {
            [HUD bwm_hideWithTitle:result[@"message"]
                         hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }
        
    } failure:^(NSError *error)
    {
        [HUD bwm_hideWithTitle:@"网络不给力"
                     hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }];
}

- (void)turnBack
{
    [[JCRouter shareRouter] popViewControllerWithIndex:2 animated:YES];
}

@end
