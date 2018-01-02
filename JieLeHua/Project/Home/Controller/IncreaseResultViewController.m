//
//  IncreaseResultViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/8/18.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IncreaseResultViewController.h"
#import "CALayer+JJBorderColor.h"
#import "JJGetIncreaseDetailRequest.h"
#import "JJGiveUpIncreaseRequest.h"

@interface IncreaseResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *statusTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDesLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reloadBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reloadBottonHeight;
@property (weak, nonatomic) IBOutlet UIView *frontView;

@property (weak, nonatomic) IBOutlet UIButton *reIncreaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
@property (weak, nonatomic) IBOutlet UIButton *giveupBtn;
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UIImageView *iconNextImage;
@property (nonatomic, strong) JJIncreaseDetailModel *detailModel;
@property (nonatomic, assign) BOOL isHuabei;
@end

@implementation IncreaseResultViewController
+ (id)allocWithRouterParams:(NSDictionary *)params {
    IncreaseResultViewController *instance = [[UIStoryboard storyboardWithName:@"IncreaseResultViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"IncreaseResultViewController"];
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"进度查看"];
    [self addBackButton];
    self.frontView.hidden = NO;
    [self.view insertSubview:self.knowBtn aboveSubview:_scrollView];
    [self.view insertSubview:self.giveupBtn aboveSubview:_scrollView];
    [self.view insertSubview:self.reloadBtn aboveSubview:_scrollView];
    [self.view insertSubview:self.topView aboveSubview:_scrollView];
    [self.view insertSubview:self.frontView aboveSubview:_scrollView];
    [self getDetails];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 获取数据
- (void)getDetails
{
    JJGetIncreaseDetailRequest *request = [[JJGetIncreaseDetailRequest alloc] initWithCustomerId:[UserModel currentUser].customerId];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;
    
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        JJIncreaseDetailModel *model = [(JJGetIncreaseDetailRequest *)request response];
        strongSelf.detailModel = model;
        VVLog(@"%@",request.responseJSONObject);
        if (model.improveCreditStatus) {
            if (strongSelf.detailModel.improveCreditStatus.gongjijinCreditStatus == 5 || strongSelf.detailModel.improveCreditStatus.antsChantFlowersCreditStatus == 5) {
                //成功或状态异常
                
                strongSelf.reloadBtn.hidden = strongSelf.topView.hidden = strongSelf.imageView.hidden = strongSelf.statusTipLabel.hidden = strongSelf.statusDesLabel.hidden = strongSelf.knowBtn.hidden = strongSelf.giveupBtn.hidden = strongSelf.reloadBtn.hidden = YES;
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                [VVAlertUtils showAlertViewWithTitle:@"" message:@"恭喜您，提额成功" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    if (buttonIndex != kCancelButtonTag) {
//                        [alertView hideAlertViewAnimated:YES];
//                        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                    }
//                }];
                return;
            }
            if (strongSelf.detailModel.improveCreditStatus.gongjijinCreditStatus == 4 && strongSelf.detailModel.improveCreditStatus.antsChantFlowersCreditStatus == 4) {

                strongSelf.reloadBtn.hidden = strongSelf.topView.hidden = strongSelf.imageView.hidden = strongSelf.statusTipLabel.hidden = strongSelf.statusDesLabel.hidden = strongSelf.knowBtn.hidden = strongSelf.giveupBtn.hidden = strongSelf.reloadBtn.hidden = YES;
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];

//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您暂不满足提额要求，无法提额" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    if (buttonIndex != kCancelButtonTag) {
//                        [defaults setObject:@"1" forKey:@"bothTip"];
//                        [defaults synchronize];
//                        [alertView hideAlertViewAnimated:YES];
//                        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                    }
//                }];
                return ;
            }
              if (strongSelf.detailModel.improveCreditStatus.gongjijinCreditStatus == 4 && strongSelf.detailModel.improveCreditStatus.antsChantFlowersCreditStatus == 0) {

                  strongSelf.reloadBtn.hidden = strongSelf.topView.hidden = strongSelf.imageView.hidden = strongSelf.statusTipLabel.hidden = strongSelf.statusDesLabel.hidden = strongSelf.knowBtn.hidden = strongSelf.giveupBtn.hidden = strongSelf.reloadBtn.hidden = YES;
                  [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                  [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您的公积金缴纳情况暂不满足提额要求，无法提额" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                      if (buttonIndex != kCancelButtonTag) {
//                          [defaults setObject:@"1" forKey:@"gongjijinFailTip"];
//                          [defaults synchronize];
//                          [alertView hideAlertViewAnimated:YES];
//                          [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                      }
//                  }];
                  return ;
              }
            if (strongSelf.detailModel.improveCreditStatus.antsChantFlowersCreditStatus == 4 && strongSelf.detailModel.improveCreditStatus.gongjijinCreditStatus == 0) {

                strongSelf.reloadBtn.hidden = strongSelf.topView.hidden = strongSelf.imageView.hidden = strongSelf.statusTipLabel.hidden = strongSelf.statusDesLabel.hidden = strongSelf.knowBtn.hidden = strongSelf.giveupBtn.hidden = strongSelf.reloadBtn.hidden = YES;
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [VVAlertUtils showAlertViewWithTitle:@"" message:@"很抱歉，您的花呗额度暂不满足提额要求，无法提额" customView:nil cancelButtonTitle:nil otherButtonTitles:@[@"知道了"] tag:0 completeBlock:^(VVAlertView *alertView, NSInteger buttonIndex) {
//                    if (buttonIndex != kCancelButtonTag) {
//                        [defaults setObject:@"1" forKey:@"huabeiFailTip"];
//                        [defaults synchronize];
//                        [alertView hideAlertViewAnimated:YES];
//                        [strongSelf.navigationController popToRootViewControllerAnimated:YES];
//                    }
//                }];
                return ;
            }
            
            strongSelf.reloadBtn.hidden = strongSelf.topView.hidden = strongSelf.imageView.hidden = strongSelf.statusTipLabel.hidden = strongSelf.statusDesLabel.hidden = strongSelf.knowBtn.hidden = strongSelf.giveupBtn.hidden = strongSelf.reloadBtn.hidden = NO;

            strongSelf.frontView.hidden = YES;
            [strongSelf updateUI];
        }else{
            //获取资料失败
            [MBProgressHUD showError:@"获取失败，请稍后再试"];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"获取失败，请稍后再试"];
    }];
}


- (void)updateUI
{
    if (self.detailModel.improveCreditStatus.antsChantFlowersCreditStatus == 1 || self.detailModel.improveCreditStatus.gongjijinCreditStatus == 1) {
        //显示刷新+知道，资料获取中
        self.reIncreaseBtn.hidden = YES;
        self.statusLabel.text = @"获取中";
        self.iconNextImage.hidden = YES;
        self.statusLabel.textColor = [UIColor colorWithHexString:@"ff3131"];
        self.bottomHeightConstraint.constant = self.bottomConstraint.constant = 0;
        self.statusTipLabel.text = @"资料获取中";
        self.statusDesLabel.text = @"正在获取额度审批所需的相关资料，获取完成后系统将自动审批额度，请耐心等待";
    }
    if (self.detailModel.improveCreditStatus.antsChantFlowersCreditStatus == 2  || self.detailModel.improveCreditStatus.gongjijinCreditStatus == 2) {
        //显示放弃提额+知道了，资料获取中
        self.statusLabel.text = @"获取失败，请重新获取";
        self.reIncreaseBtn.hidden = NO;
        self.iconNextImage.hidden = NO;
        self.statusLabel.textColor = [UIColor colorWithHexString:@"ff3131"];
        self.reloadBtnHeight.constant = self.reloadBottonHeight.constant = 0;
        self.statusTipLabel.text = @"资料获取中";
        self.statusDesLabel.text = @"正在获取额度审批所需的相关资料，获取完成后系统将自动审批额度，请耐心等待";
        
    }

    if (self.detailModel.improveCreditStatus.antsChantFlowersCreditStatus == 3 || self.detailModel.improveCreditStatus.gongjijinCreditStatus == 3) {
        //显示知道了、提额审批中
        self.reIncreaseBtn.hidden = YES;
        self.iconNextImage.hidden = YES;
        self.statusLabel.text = @"已获取";
        self.statusLabel.textColor = [UIColor colorWithHexString:@"57C939"];
        self.bottomHeightConstraint.constant = self.bottomConstraint.constant = 0;
        self.reloadBtnHeight.constant = self.reloadBottonHeight.constant = 0;
        self.statusTipLabel.text = @"额度审批中";
        self.statusDesLabel.text = @"您的信息已提交成功，审批可能需要1~2小时请耐心等待...";
    }
    if (self.detailModel.improveCreditStatus.antsChantFlowersCreditStatus < 4 && self.detailModel.improveCreditStatus.antsChantFlowersCreditStatus > 0) {
        //显示花呗信息
        self.isHuabei = YES;
        self.titleLabel.text = @"花呗额度";
        self.reloadBtnHeight.constant = 0;
        self.reloadBtn.hidden = YES;
    }
    if (self.detailModel.improveCreditStatus.gongjijinCreditStatus < 4 && self.detailModel.improveCreditStatus.gongjijinCreditStatus > 0) {
        //显示公积金信息
        self.isHuabei = NO;
        self.titleLabel.text = @"公积金缴纳情况";
        if ([self.detailModel.improveCreditStatus.gongjijinComment containsString:@"账号或密码错误，请重新输入"]) {
            self.statusLabel.text = @"账号或密码错误,请重新输入";
        }
    }
}

#pragma mark - 放弃提额
- (void)giveUpRequest
{
    //（0：花呗；1：公积金）
    NSString *type = @"";
    if (self.isHuabei) {
        type = @"0";
    }else{
        type = @"1";
    }
    JJGiveUpIncreaseRequest *request = [[JJGiveUpIncreaseRequest alloc] initWithCustomerId:[UserModel currentUser].customerId busType:type];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    __weak __typeof(self)weakSelf = self;

    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        JJBaseResponseModel *model = [(JJGiveUpIncreaseRequest *)request response];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (model.success) {
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"获取失败，请稍后再试"];
        }
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [MBProgressHUD showError:@"获取失败，请稍后再试"];
    }];
}

#pragma mark - 按钮
- (IBAction)reloadDetails:(id)sender {
    [self getDetails];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)giveUp:(id)sender {
    [self giveUpRequest];
}

//重新提额
- (IBAction)reIncrease:(id)sender {
    if (self.isHuabei) {
        [[JCRouter shareRouter] pushURL:@"huabei/1"];
    }else{
        [[JCRouter shareRouter] pushURL:@"housing"];
    }
}
@end
