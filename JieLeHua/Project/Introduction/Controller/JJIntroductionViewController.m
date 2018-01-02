//
//  JJIntroductionViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 17/6/7.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJIntroductionViewController.h"
#import "JJIntroduceMineTableViewCell.h"
#import "JJWKWebViewViewController.h"
#import "VVNavigationController.h"

@interface JJIntroductionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UIImageView * iconImgView;
@property(nonatomic,strong) UILabel * nameLab;
@property(nonatomic,strong) UIButton * quiteBtn;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) MBProgressHUD * hud;
@property(nonatomic,strong) NSArray * saleNumArr;
@end

@implementation JJIntroductionViewController

-(NSArray *)saleNumArr{
    if (_saleNumArr == nil) {
        _saleNumArr = [[NSArray alloc]init];
    }
    return _saleNumArr;
}

static NSString *const introduceCell = @"introduceCell";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestInfomation];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"转介绍"];
    self.view.backgroundColor = VVclearColor;
    [self setUpSubView];

}

-(void)setUpSubView{
    _scrollView.backgroundColor = [UIColor colorWithWholeRed:241 green:244 blue:246];
    _scrollView.frame = CGRectMake(0, 0, vScreenWidth, vScreenHeight-44 );
    
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_zhuanjieshao_bg_1"]];
    [self.scrollView addSubview:headView];
    self.headView = headView;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top).offset(64);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(0);
        make.width.mas_equalTo(self.scrollView.mas_width).offset(0);
        make.height.mas_equalTo(@154);
    }];
    
    UIImageView *iconImgView = [[UIImageView alloc]init];
//    iconImgView.backgroundColor = VVRandomColor;
    iconImgView.image = [UIImage imageNamed:@"img_user_head_protrait"];
    [_headView addSubview:iconImgView];
    iconImgView.layer.cornerRadius = 35;
    iconImgView.clipsToBounds = YES;
    iconImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImgView.layer.borderWidth = 1.f;
    _iconImgView = iconImgView;
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headView.mas_left).offset(18);
        make.centerY.mas_equalTo(self.headView.mas_centerY).offset(0);
        make.width.equalTo(@70);
        make.height.equalTo(@70);
    }];
   
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.backgroundColor = VVclearColor;
    nameLab.font = [UIFont systemFontOfSize:24.f];
    nameLab.textColor = VVWhiteColor;
    [_headView addSubview:nameLab];
    self.nameLab = nameLab;
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.headView.mas_centerY).offset(0);
        make.height.mas_equalTo(@24);
    }];
    
    UIButton *quiteBtn = [[UIButton alloc]init];
    NSMutableAttributedString* btnTitle = [[NSMutableAttributedString alloc] initWithString:@"退出登录"];
       //此时如果设置字体颜色要这样
    [btnTitle addAttribute:NSForegroundColorAttributeName value:VVWhiteColor  range:NSMakeRange(0,[btnTitle length])];
    [btnTitle addAttribute:NSUnderlineStyleAttributeName
                     value:@(NSUnderlineStyleSingle)
                     range:(NSRange){0,[btnTitle length]}];
    //设置下划线颜色...
    [btnTitle addAttribute:NSUnderlineColorAttributeName value:VVWhiteColor range:(NSRange){0,[btnTitle length]}];
    [quiteBtn setAttributedTitle:btnTitle forState:UIControlStateNormal];
    [quiteBtn addTarget:self action:@selector(quiteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:quiteBtn];
    self.quiteBtn = quiteBtn;
    [quiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headView.mas_centerY).offset(0);
        make.right.mas_equalTo(self.headView.mas_right).offset(-18);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(80);
    }];

    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource  =  self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:@"JJIntroduceMineTableViewCell" bundle:nil] forCellReuseIdentifier:introduceCell];
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(0);
        make.width.mas_equalTo(self.scrollView.mas_width).offset(0);
        make.height.mas_equalTo(@270);
    }];
    
    [_scrollView layoutIfNeeded];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, self.tableView.bottom + 30);
}

#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return section == 0 ?4:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ?32:10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headCell = [[UIView alloc]init];
    headCell.backgroundColor = VVColor(241, 244, 246);
    if (section == 0) {
        headCell.frame = CGRectMake(0, 0, vScreenWidth, 32);
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, vScreenWidth - 24, 14)];
        leftLab.centerY = headCell.centerY;
        leftLab.text = @"转介绍用户详情";
        leftLab.textColor = VVColor999999;
        leftLab.font = [UIFont systemFontOfSize:14];
        [headCell addSubview:leftLab];
        
    }else{
        headCell.frame = CGRectMake(0, 0, vScreenWidth, 10);
    }
    return  headCell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJIntroduceMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:introduceCell];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.detialLab.textColor = [UIColor globalThemeColor];
        switch (indexPath.row) {
            case 0:
                cell.titleLab.text = @"成功关注用户";
                cell.detialLab.text = [NSString stringWithFormat:@"%@人",self.saleNumArr[indexPath.row]];
                cell.separateLine.hidden = NO;
                break;
            case 1:
                cell.titleLab.text = @"成功注册用户";
                cell.detialLab.text = [NSString stringWithFormat:@"%@人",self.saleNumArr[indexPath.row]];
                cell.separateLine.hidden = NO;
                break;
            case 2:
                cell.titleLab.text = @"获得额度用户";
                cell.detialLab.text = [NSString stringWithFormat:@"%@人",self.saleNumArr[indexPath.row]];
                cell.separateLine.hidden = NO;
                break;
            case 3:
                cell.titleLab.text = @"成功提现用户";
                cell.detialLab.text = [NSString stringWithFormat:@"%@人",self.saleNumArr[indexPath.row]];
                cell.separateLine.hidden = YES;
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        cell.detialLab.textColor = VVColor999999;
        cell.titleLab.text = @"积分商城";
        cell.detialLab.text = @"0元好物在这里";
        cell.separateLine.hidden = YES;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJWKWebViewViewController *wkwebVc = [[JJWKWebViewViewController alloc]init];
    wkwebVc.isNavHidden = NO;
    
    NSString *salesId = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeSalesId"];
//    NSString *salesId = @"37504";

    NSString *salesToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeSalesToken"];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                [wkwebVc loadWebURLSring:[NSString stringWithFormat:@"%@/transfer.html?salesId=%@&style=1",WEB_BASE_URL,salesId]];
                wkwebVc.webTitle = @"成功关注用户";
                break;
            case 1:
                [wkwebVc loadWebURLSring:[NSString stringWithFormat:@"%@/transfer.html?salesId=%@&style=2",WEB_BASE_URL,salesId]];
                wkwebVc.webTitle = @"成功注册用户";

                break;
            case 2:
                [wkwebVc loadWebURLSring:[NSString stringWithFormat:@"%@/transfer.html?salesId=%@&style=3",WEB_BASE_URL,salesId]];
                wkwebVc.webTitle = @"获得额度用户";
                break;
            case 3:
                [wkwebVc loadWebURLSring:[NSString stringWithFormat:@"%@/transfer.html?salesId=%@&style=4",WEB_BASE_URL,salesId]];
                wkwebVc.webTitle = @"成功提现用户";
                break;
            default:
                break;
        }
        
    }else{
    [wkwebVc loadWebURLSring: [NSString stringWithFormat:@"%@/market/index.html?token=%@&saleId=%@",WEB_BASE_URL,salesToken,salesId]];
    }
    
    wkwebVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wkwebVc animated:YES];

}

-(void)requestInfomation{
    NSString *salesId = [[NSUserDefaults standardUserDefaults]objectForKey:@"JJEmployeSalesId"];
//    NSString *saleId = @"22571";
    [self.hud show:YES];
    [[VVNetWorkUtility netUtility] getSaleNumBySaleId:salesId success:^(id result) {
        [self.hud hide:NO];
        
        if ([[result safeObjectForKey:@"success"] boolValue]) {
            self.nameLab.text = [[result safeObjectForKey:@"data"] safeObjectForKey:@"saleName"];
            self.saleNumArr = [[result safeObjectForKey:@"data"] safeObjectForKey:@"saleNums"];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:[result safeObjectForKey:@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self.hud hide:NO];
        [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];
    }];

    
}


-(void)quiteBtnClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您是否选择立即退出登录" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self quitRequest];
    }];
    
    [alert addAction:updateAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)quitRequest
{
    [MBProgressHUD bwm_showTitle:@"退出成功" toView:self.view hideAfter:1.5f];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeSalesId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JJEmployeSalesToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [VV_App.naviController presentLoginViewController];
//    [self.tabBarController.navigationController popViewControllerAnimated:NO];
}

@end
