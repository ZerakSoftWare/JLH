//
//  CustomerServiceViewController.m
//  JieLeHua
//
//  Created by kuang on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "CustomerServiceViewController.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface CustomerServiceViewController ()<UIAlertViewDelegate>


@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation CustomerServiceViewController


#pragma mark - Properties


#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication]
             openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"tel://%@",@"4000-523-528"]]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Overridden Methods

+ (id)allocWithRouterParams:(NSDictionary *)params {
    CustomerServiceViewController *instance = [[CustomerServiceViewController alloc] init];
    return instance;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self setNavigationBarTitle:@"客服中心"];
    
    [self addBackButton];
    
    [self initAndLayoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)initAndLayoutUI
{
    /************************客服工作时间************************/
    
    UIImageView *timeImg = ({
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(@"service_time")];
        
        UILabel *topLab = [[UILabel alloc] init];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.font = [UIFont boldSystemFontOfSize:18];
        topLab.textColor = [UIColor whiteColor];
        topLab.text = @"客服工作时间";
        [img addSubview:topLab];
        
        UILabel *remindLab = [[UILabel alloc] init];
        remindLab.textAlignment = NSTextAlignmentCenter;
        remindLab.font = [UIFont systemFontOfSize:15];
        remindLab.textColor = [UIColor whiteColor];
        remindLab.text = @"除法定节假日外每周一至周日";
        [img addSubview:remindLab];
        
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = [UIFont systemFontOfSize:15];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text = @"9:00-17:30";
        [img addSubview:timeLab];
        
        [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img).offset(40);
            make.left.right.equalTo(img);
            make.height.equalTo(@25);
        }];
        
        [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLab.mas_bottom).offset(27);
            make.left.right.equalTo(img);
            make.height.equalTo(@21);
        }];
        
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remindLab.mas_bottom);
            make.left.right.equalTo(img);
            make.height.equalTo(@21);
        }];
        
        img;
    });
    [self.scrollView addSubview:timeImg];
    
    [timeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@182);
        make.top.equalTo(self.scrollView.mas_top).offset(16+64);
    }];
    
    
    /************************客服电话************************/
    
    UIImageView *phoneImg = ({
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(@"service_phone")];
        
        UILabel *topLab = [[UILabel alloc] init];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.font = [UIFont boldSystemFontOfSize:18];
        topLab.textColor = [UIColor whiteColor];
        topLab.text = @"客服电话";
        [img addSubview:topLab];
        
        [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img).offset(40);
            make.left.right.equalTo(img);
            make.height.equalTo(@25);
        }];
        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callBtn setTitle:@"4000-523-528" forState:UIControlStateNormal];
        [callBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [callBtn setBackgroundImage:kGetImage(@"service_phone_btn") forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:callBtn];
        
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLab.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(148, 36));
            make.centerX.equalTo(topLab.mas_centerX);
        }];
        
        UILabel *remindLab = [[UILabel alloc] init];
        remindLab.textAlignment = NSTextAlignmentCenter;
        remindLab.font = [UIFont systemFontOfSize:15];
        remindLab.textColor = [UIColor whiteColor];
        remindLab.text = @"拨通后 按4，转入“借乐花在线业务申请”";
        [img addSubview:remindLab];
        
        [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(callBtn.mas_bottom).offset(6);
            make.left.right.equalTo(img);
            make.height.equalTo(@21);
        }];
        
        img;
    });
    [self.scrollView addSubview:phoneImg];
    
    phoneImg.userInteractionEnabled = YES;
    
    [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@182);
        make.top.equalTo(timeImg.mas_bottom).offset(16);
    }];
    
    
    /************************服务范围************************/
    
    UIImageView *serviceImg = ({
        UIImageView *img = [[UIImageView alloc] initWithImage:kGetImage(@"service_service")];
        
        
        UILabel *topLab = [[UILabel alloc] init];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.font = [UIFont boldSystemFontOfSize:18];
        topLab.textColor = [UIColor whiteColor];
        topLab.text = @"服务范围";
        [img addSubview:topLab];
        
        [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(img).offset(40);
            make.left.right.equalTo(img);
            make.height.equalTo(@25);
        }];
        
        UILabel *remindLab = [[UILabel alloc] init];
        remindLab.textAlignment = NSTextAlignmentCenter;
        remindLab.font = [UIFont systemFontOfSize:15];
        remindLab.textColor = [UIColor whiteColor];
        remindLab.text = @"解决客户在线上申请遇到的问题";
        [img addSubview:remindLab];
        
        [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topLab.mas_bottom).offset(30);
            make.left.right.equalTo(img);
            make.height.equalTo(@21);
        }];
        
        img;
    });
    [self.scrollView addSubview:serviceImg];
    
    [serviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.equalTo(@182);
        make.top.equalTo(phoneImg.mas_bottom).offset(16);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.bottom.mas_equalTo(serviceImg.mas_bottom).offset(20);
    }];
}

- (void)callPhone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"4000-523-528"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

@end
