//
//  JLHForgetPasswordViewController.m
//  JLH
//
//  Created by YuZhongqi on 17/2/17.
//  Copyright © 2017年 Jam. All rights reserved.
//

#import "JLHForgetPasswordViewController.h"
#import "JLHResetPasswordController.h"
#import "UITextField+LimitLength.h"
#import "UIButton+JJMultiClickButton.h"

@interface JLHForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextfield;
@property (weak, nonatomic) IBOutlet UIButton *receiveSMSCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *phoneNumTFBottomLine;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UITextField *SMSCodeTextfield;

@property (weak, nonatomic) IBOutlet UIView *SMSCodeTFBottomLine;
@property (weak, nonatomic) IBOutlet UITextField *imageCodeField;
@property (weak, nonatomic) IBOutlet UIImageView *imageNumView;
@property (weak, nonatomic) IBOutlet UIButton *getImageBtn;

@end

@implementation JLHForgetPasswordViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [self initWithNibName:@"JLHForgetPasswordViewController" bundle:nil])) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.getImageBtn.vv_acceptEventInterval = 1;
    self.navigationItem.title = @"忘记密码";
    
    [self layoutPageSubviews];
    
    [self.phoneNumTextfield limitTextLength:11 block:^(NSString *text) {
        self.phoneNumTextfield.text = text;
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageSubviews
{
    [_nextStepButton setBackgroundImage:[UIImage imageWithColor:[UIColor globalThemeColor] size:CGSizeMake(_nextStepButton.frame.size.width, _nextStepButton.frame.size.height)] forState:UIControlStateNormal];
    _phoneNumTFBottomLine.backgroundColor = [UIColor grayThemeColor];
    _SMSCodeTFBottomLine.backgroundColor = [UIColor grayThemeColor];
}


- (IBAction)getImage:(id)sender {
    VVLog(@"获取图片验证码");
    NSString *phoneStr = self.phoneNumTextfield.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (!phoneStr.length || ![phoneStr isMobileNumber]) {
        error = YES;
        errorStr = @"请输入正确的手机号码";
    }
    if (error) {
        [MBProgressHUD bwm_showTitle:errorStr
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
    [self.getImageBtn setTitle:@"" forState:UIControlStateNormal];
    self.getImageBtn.backgroundColor = [UIColor clearColor];
    NSString *imageUrl = [NSString stringWithFormat:@"%@/account/regedit/verifyCode/%@",APP_BASE_URL,self.phoneNumTextfield.text];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.imageNumView.image = [UIImage imageWithData:imageData];
        });

    });
}

- (IBAction)receiveSMSCodeBtnClick:(UIButton*)sender {
    
    NSString *phoneStr = self.phoneNumTextfield.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (!phoneStr.length || ![phoneStr isMobileNumber]) {
        error = YES;
        errorStr = @"请输入正确的手机号码";
    }
    
    if (error) {
        [MBProgressHUD bwm_showTitle:errorStr
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
    
    [self getVerifyCode];
}

/**
 *  发送验证码
 */
- (void)getVerifyCode
{
    if ([self.imageCodeField.text length] == 0) {
        [MBProgressHUD bwm_showTitle:@"请先输入图片验证码"
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
    NSString *string = [NSString stringWithFormat:@"JLH_SBGJ_%@",self.phoneNumTextfield.text];
    
    __weak __typeof(self)weakSelf = self;
    [[VVNetWorkUtility netUtility] getCommonVerificationMobile:self.phoneNumTextfield.text picNum:self.imageCodeField.text st:[[[[string md5] uppercaseString] md5] uppercaseString] success:^(id result)
     {
         if ([result[@"success"] integerValue] != 1)
         {
             [MBProgressHUD bwm_showTitle:result[@"message"]
                                   toView:self.view
                                hideAfter:1.2f];
         }else{
             [weakSelf.receiveSMSCodeBtn startTime:59 title:@"重新获取" waitTittle:@"重新获取"];
         }
         
     } failure:^(NSError *error)
     {
         
     }];
}

/**
 *  检验验证码
 */
- (IBAction)nextStepButtonClick:(UIButton *)sender {
    
    NSString *codeStr = self.SMSCodeTextfield.text;
    NSString *phoneStr = self.phoneNumTextfield.text;
    
    BOOL error = NO;
    NSString *errorStr = @"";
    
    if (!codeStr.length) {
        error = YES;
        errorStr = @"请输入验证码";
    }
    if (!phoneStr.length || ![phoneStr isMobileNumber]) {
        error = YES;
        errorStr = @"请输入正确的手机号码";
    }
    
    if (error) {
        [MBProgressHUD bwm_showTitle:errorStr
                              toView:self.view
                           hideAfter:1.2f];
        return;
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showAnimationWithtitle:@"正在加载中……" toView:self.view];
    
    [[VVNetWorkUtility netUtility] getCheckSmsCodeWithMobile:self.phoneNumTextfield.text
                                                 withSmsCode:self.SMSCodeTextfield.text
                                                     success:^(id result)
    {
        if ([result[@"success"] integerValue] == 1)
        {
            [HUD hide:YES];
            
            JLHResetPasswordController *vc = [[JLHResetPasswordController alloc] init];
            vc.verifyCodeStr = self.SMSCodeTextfield.text;
            vc.phoneStr = self.phoneNumTextfield.text;
            [self.navigationController pushViewController:vc animated:YES];
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

@end
