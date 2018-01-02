//
//  JJPayVipViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/12/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJPayVipViewController.h"

@interface JJPayVipViewController ()

@end

@implementation JJPayVipViewController

+ (instancetype)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"JJPayVip" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"JJPayVipViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelPay:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)payVipAction:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.payVipActionBlock) {
            weakSelf.payVipActionBlock();
        }
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
