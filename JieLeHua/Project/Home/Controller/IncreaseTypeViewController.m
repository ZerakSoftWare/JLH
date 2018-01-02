//
//  IncreaseTypeViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/20.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "IncreaseTypeViewController.h"

@interface IncreaseTypeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *huabeiBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *huabeiRightImage;
@property (weak, nonatomic) IBOutlet UIImageView *huabeiHudImg;

@property (weak, nonatomic) IBOutlet UIImageView *gongjijinBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *gongjijinHudImg;
@property (weak, nonatomic) IBOutlet UIImageView *gongjijinRightImage;
@property (weak, nonatomic) IBOutlet UIButton *huabeiBtn;
@property (weak, nonatomic) IBOutlet UIButton *gongjijinBtn;
@property (weak, nonatomic) IBOutlet UIImageView *huabeiUpImg;
@property (weak, nonatomic) IBOutlet UIImageView *gongjijinUpImg;
@end

@implementation IncreaseTypeViewController
+ (instancetype)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IncreaseType" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"IncreaseTypeViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUIWithHuabeiStatus:(BOOL)huabeiFailed gongjijinStatus:(BOOL)gongjijinFailed
{
    if (gongjijinFailed) {
        self.gongjijinBgImg.image = [UIImage imageNamed:@"img_bg_up_line_grey_01"];
        self.gongjijinHudImg.image = [UIImage imageNamed:@"icon_flower_white"];
        self.gongjijinRightImage.image = [UIImage imageNamed:@"icon_gongjijin_white"];
        self.gongjijinBtn.enabled = NO;
        self.gongjijinUpImg.image = [UIImage imageNamed:@""];
    }else{
        self.gongjijinBgImg.image = [UIImage imageNamed:@"img_bg_up_line_02"];
        self.gongjijinHudImg.image = [UIImage imageNamed:@"icon_flower_red"];
        self.gongjijinRightImage.image = [UIImage imageNamed:@"icon_gongjijin"];
        self.gongjijinBtn.enabled = YES;
        self.gongjijinUpImg.image = [UIImage imageNamed:@"img_up"];
    }
    
    if (huabeiFailed) {
        self.huabeiUpImg.image = [UIImage imageNamed:@""];
        self.huabeiBgImg.image = [UIImage imageNamed:@"img_bg_up_line_grey_01"];
        self.huabeiHudImg.image = [UIImage imageNamed:@"icon_flower_white"];
        self.huabeiRightImage.image = [UIImage imageNamed:@"icon_huabei_white"];
        self.huabeiBtn.enabled = NO;
    }else{
        self.huabeiUpImg.image = [UIImage imageNamed:@"img_up"];
        self.huabeiBgImg.image = [UIImage imageNamed:@"img_bg_up_line_01"];
        self.huabeiHudImg.image = [UIImage imageNamed:@"icon_flower_blue"];
        self.huabeiRightImage.image = [UIImage imageNamed:@"icon_huabei"];
        self.huabeiBtn.enabled = YES;
    }
}

- (IBAction)cancelSelect:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)huabei:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate chooseType:IncreaseType_Huabei];
    }];
}

- (IBAction)gongjijin:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate chooseType:IncreaseType_Gongjijin];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
