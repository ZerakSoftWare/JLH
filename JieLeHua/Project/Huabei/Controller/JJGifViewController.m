//
//  JJGifViewController.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/23.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJGifViewController.h"
#import "GifView.h"

@interface JJGifViewController ()
@property (nonatomic, strong) GifView *gifView;
@property (nonatomic, assign) BOOL stoped;
@property (nonatomic, strong) UIImageView *bgImage;
@end

@implementation JJGifViewController

//如果是代码 xib 创建ViewController 则JCRouter会调用此方法
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [super init])) {
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setNavigationBarTitle:@"支付宝登录授权"];
    [self addBackButton];
    self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, self.view.frame.size.height)];
    _bgImage.userInteractionEnabled = YES;
    _bgImage.image = [UIImage imageNamed:@"watchVideo"];
    [self.view insertSubview:_bgImage aboveSubview:self.scrollView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [_bgImage addSubview:btn];
    [btn addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImage.mas_top).offset(180);
        make.left.mas_equalTo(_bgImage.mas_left).offset(60);
        make.right.mas_equalTo(_bgImage.mas_right).offset(-60);
        make.height.equalTo(@200);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 开始播放gif
- (void)startPlay
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"gif"];
    self.gifView = [[GifView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44) filePath:path];
    __weak __typeof(self)weakSelf = self;
    self.gifView.gifStopBlock = ^(BOOL stoped){
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.stoped = stoped;
    };
    [self.view insertSubview:self.gifView aboveSubview:_bgImage];
}

- (void)backAction:(id)sender
{
    if (self.gifView) {
        [self.gifView removeFromSuperview];
        self.gifView = nil;
        self.stoped = YES;
    }else{
        [self customPopViewController];
    }
}

@end
