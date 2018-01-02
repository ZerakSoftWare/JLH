//
//  JJWchatPayViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/9/8.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJWchatPayViewController.h"
#import "PayToolsManager.h"

@interface JJWchatPayViewController ()

@end

@implementation JJWchatPayViewController

- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarTitle:@"微信支付"];
    [self addBackButton];
    
    VVCommonButton *btn = [VVCommonButton solidButtonWithTitle:@"支付"];
    btn.frame = CGRectMake(0,0,vScreenWidth - 40,44);
    btn.centerX = vScreenWidth * 0.5;
    btn.centerY = vScreenHeight  * 0.5;
    [btn addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)goToPay{
//    __weak typeof(self) weakSelf = self;
//    [[PayToolsManager defaultManager] startWeChatPayWithOrderSn:@"201703292002519" orderName:@"订单名称" orderPrice:@"0.03" notiURL:@"http://o2oappserv.xiuche580.com/payment/notify/UnionPayNotify.do" paySuccess:^{
//        [weakSelf.view makeToast:@"微信支付成功"];
//
//    } payFaild:^(NSString *desc) {
//        [weakSelf.view makeToast:desc];
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
