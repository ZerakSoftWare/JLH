//
//  VVCreditBaseViewController.m
//  O2oApp
//
//  Created by chenlei on 16/4/23.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVCreditBaseViewController.h"

@interface VVCreditBaseViewController ()

@end

@implementation VVCreditBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.backgroundColor = VV_COL_RGB(0xffffff);
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setNavigation];
}


-(void)setNavigation{
//    [self setNavigationBarTitle:@"我的"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
