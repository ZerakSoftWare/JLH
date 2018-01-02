//
//  JJH5DetailViewController.m
//  JieLeHua
//
//  Created by 维信金科 on 17/2/27.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJH5DetailViewController.h"

@interface JJH5DetailViewController ()<UIWebViewDelegate>
{
    UIWebView *detailWeb;
}
@end

@implementation JJH5DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarTitle:self.h5Title];
    [self addBackButton];
    
    NSString *requestUrl = self.strUrl;
    
    detailWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight-64)];
    [detailWeb setDelegate:self];
    [detailWeb.scrollView setBounces:NO];
    [detailWeb setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:detailWeb];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest *requrest = [[NSURLRequest alloc] initWithURL:url];
    [detailWeb loadRequest:requrest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
