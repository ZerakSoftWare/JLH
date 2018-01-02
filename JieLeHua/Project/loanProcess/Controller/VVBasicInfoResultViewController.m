//
//  VVBasicInfoResultViewController.m
//  O2oApp
//
//  Created by chenlei on 16/5/12.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVBasicInfoResultViewController.h"
#import "VVLoanAplicationProcessViewController.h"
#import "VVNoResultView.h"

@interface VVBasicInfoResultViewController ()

@end

@implementation VVBasicInfoResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"结果"];
    [self addBackButton];
    _btnRight.hidden = YES;
    
    if (!VV_IS_NIL(_noStore)) {
        VVNoResultView *noresultView = [[VVNoResultView alloc]initWithFrame:CGRectMake(0, 0, vScreenWidth, kScreenHeight-kNavigationBarHeight)];
        NSString *url = [WEB_BASE_URL stringByAppendingString:[NSString stringWithFormat:@"/noresult.html?msg=%@",[_titleStr base64EncodedString]]];
        [noresultView loadWebView:url];
        [_scrollView addSubview:noresultView];
        return;
    }
    CGFloat imageviewHeight;
    if (ISIPHONE4 ) {
        imageviewHeight = 180;
    }else if(ISIPHONE5){
        imageviewHeight = 240;
    }else if (ISIPHONE6){
        imageviewHeight = 300;
    }else if (ISIPHONE6Plus){
        imageviewHeight = 320;
    }else{
        imageviewHeight = 240;
    }
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-30, imageviewHeight, 60, 60)];
    imageview.image = _image;
    imageview.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageview];
    CGRect titleLabelFrame = CGRectMake(20 , imageview.bottom+20 , kScreenWidth-40, 30);

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = VV_COL_RGB(0x6c6c6c);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 0;

    titleLabel.text = _titleStr;
    CGFloat  height = [_titleStr sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(kScreenWidth-40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    titleLabelFrame.size.height = height;
    titleLabel.frame = titleLabelFrame;
    [self.view addSubview:titleLabel];
    CGRect buttonFrame;
    if (ISIPHONE4) {
        buttonFrame = CGRectMake(VVleftMargin, kScreenHeight-50, kScreenWidth-VVleftMargin*2, VVBtnHeight);
    }else{
       buttonFrame = CGRectMake(VVleftMargin, kScreenHeight-65, kScreenWidth-VVleftMargin*2, VVBtnHeight);
    }
    VVCommonButton *itemButton = [VVCommonButton solidButtonWithTitle:@"重新前往认证"];
    [itemButton setFrame:buttonFrame];
    itemButton.hidden = _btnHidden;
    [itemButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [itemButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:itemButton];
    

    
//    UILabel *qrLabel = [[UILabel alloc] init];
//   if (ISIPHONE4 || ISIPHONE5) {
//        qrLabel.frame = CGRectMake(0.5 * (vScreenWidth - 200),titleLabel.bottom + 20 , 200, 36);
//    }else{
//        qrLabel.frame = CGRectMake(0.5 * (vScreenWidth - 200),titleLabel.bottom + 20 , 200, 36);
//    }
//    qrLabel.backgroundColor = [UIColor clearColor];
//    qrLabel.text = @"您可以扫描下面二维码或直接搜索微信公众号(豆豆钱)申请线上贷款";
//
//    qrLabel.textColor = VVBASE_COLOR;
//    qrLabel.textAlignment = NSTextAlignmentCenter;
//    qrLabel.font = [UIFont systemFontOfSize:15];
//    qrLabel.numberOfLines = 0;
//    qrLabel.hidden = _qrHidden;
//    qrLabel.textColor = VVAppButtonTitleColor;
//    [qrLabel sizeToFit];
//    [self.view addSubview:qrLabel];
//
//    UIImageView *qrimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0.5*(kScreenWidth-125), qrLabel.bottom+20, 125, 125)];
//    qrimageview.image = [UIImage imageNamed:@"erweima"];
//    qrimageview.hidden = _qrHidden;
//    [self.view addSubview:qrimageview];
//    if (_isMineController) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }else{
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
}

- (void)backAction:(id)sender{
    if (_isMineController) {
        [self customPopViewController];
    }else if (!_btnHidden) {//手机认证
        [super backAction:sender];
    }else{
        [self customPopToRootViewController];
    }
}

- (void)buttonPressed:(VVCommonButton *)btn{
    NSArray* viewStack = self.navigationController.viewControllers;
    __block BOOL isController = NO;
    [viewStack enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController* preViewController =  VV_OBJATIDX(viewStack, idx);
        if ([preViewController isKindOfClass:[VVLoanAplicationProcessViewController class]]) {
            isController = YES;
            VVLoanAplicationProcessViewController *controller =   (VVLoanAplicationProcessViewController*)preViewController;
            VV_SHDAT.mobileInitModel = nil;
            controller.isBack = YES;
            [self customPopToViewController:controller];
            *stop = YES;
        }
    }];
    
    if (!isController) {
        VVLoanAplicationProcessViewController *controller =   [[VVLoanAplicationProcessViewController alloc]init];
        [self customPushViewController:controller withType:nil subType:nil];
    }

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
