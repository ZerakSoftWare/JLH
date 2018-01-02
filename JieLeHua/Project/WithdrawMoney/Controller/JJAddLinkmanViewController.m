//
//  JJAddLinkmanViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/8/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJAddLinkmanViewController.h"
#import "JJConnectionRelationshipViewController.h"
#import "JJContactsViewController.h"
#import "XHJAddressBook.h"
#import "PersonModel.h"
#import "JJJsonTransformation.h"
#import "JJRiskCusomerRequest.h"
#import "JJH5SignViewController.h"

@interface JJAddLinkmanViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property(nonatomic,strong) UILabel * relationShipLab1;
@property(nonatomic,strong) UILabel * relationShipLab2;
@property(nonatomic,strong) UILabel * telLab1;
@property(nonatomic,strong) UILabel * telLab2;
@property(nonatomic,strong)NSMutableArray *listContent;
@property(nonatomic,strong)  XHJAddressBook *addBook;
@property(nonatomic,strong)NSMutableArray *nameAndTelArr;
@property(nonatomic,strong) NSString * contactStr;
@property(nonatomic,strong) NSArray * relationShipArr;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *name;
@property(nonatomic,strong) UITextField * firstNameTf;
@property(nonatomic,strong) UITextField * secoendNameTf;

@end

@implementation JJAddLinkmanViewController

+ (id)allocWithRouterParams:(NSDictionary *)params {
    JJAddLinkmanViewController *instance = [[UIStoryboard storyboardWithName:@"AddLinkman" bundle:nil] instantiateViewControllerWithIdentifier:@"AddLinkman"];
    VVLog(@"%@", params);
    return instance;
}

-(NSArray *)relationShipArr{
    if (!_relationShipArr) {
        _relationShipArr = [NSArray array];
    }
    return _relationShipArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNavigationBarTitle:@"联系人添加"];
    [self addBackButton];
    [self.view insertSubview:self.tableView aboveSubview:_scrollView];
    [self.view insertSubview:self.sureButton aboveSubview:_scrollView];
    _tableView.scrollEnabled = NO;
    [_sureButton setBackgroundColor:[UIColor unableButtonThemeColor] forState:UIControlStateDisabled];
    [_sureButton setBackgroundColor:[UIColor globalThemeColor] forState:UIControlStateNormal];
    _sureButton.enabled = NO;
    _sureButton.userInteractionEnabled = NO;
    [VV_NC addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)dealloc{
    [VV_NC removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)backAction:(id)sender{
    [self customPopToRootViewController];
}

- (IBAction)sureButtonClick:(UIButton *)sender {
    
//    NSString *cleaned = [[_telLab1.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];

     NSString *tel1 = [_telLab1.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tel2 = [_telLab2.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([tel1 isEqualToString:tel2]) {
        [VLToast showWithText:@"联系人号码相同，请重新选择" duration:3];
        return;
    }

    if ([VVCommonFunc isValidateMobile:tel1] && [VVCommonFunc isValidateMobile:tel2]) {
        VVLog(@"sureButtonClick");
        NSDictionary *firstDic = @{@"appellation":_relationShipLab1.text,
                                   @"phoneNum":tel1,
                                   @"name":_firstNameTf.text
                                   };
        NSDictionary *secondDic = @{@"appellation":_relationShipLab2.text,
                                   @"phoneNum":tel2,
                                   @"name":_secoendNameTf.text
                                   };
        NSDictionary *dict = @{
                               @"firstContact":firstDic,
                               @"secondContact":secondDic,
                               @"allContacts":_contactStr,
                               @"addressBookTime":[self readAuthorizationTime]
                               };
        JJRiskCusomerRequest *request = [[JJRiskCusomerRequest alloc]initWithParam:dict];
        JJRequestAccessory *accessory =[[JJRequestAccessory alloc]initWithShowVC:self];
        [request addAccessory:accessory];
        [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
           NSDictionary *result = request.responseJSONObject;
            if ([[result safeObjectForKey:@"success"] boolValue]) {
                [self getCustomersOrderDetail];
            }else{
                [MBProgressHUD showError:[result safeObjectForKey:@"message"]];
            }
        } failure:^(__kindof KZBaseRequest *request, NSError *error) {
            [MBProgressHUD showError:@"添加联系人失败"];
        }];
    }else{
        [VLToast showWithText:@"请选择有效手机号"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return   [@[@"联系人一",@"联系人二"] objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = VVColor999999;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(indexPath.section == 0){
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"relationshipCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _firstNameTf = [(UITextField*)self.tableView viewWithTag:100];
            _firstNameTf.placeholder = @"请输入联系人姓名";
            return cell;
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"connectionCell" forIndexPath:indexPath];
            _telLab1 =  (UILabel *)[self.tableView viewWithTag:200];
            _relationShipLab1 = (UILabel*)[self.tableView viewWithTag:300];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        if (row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"relationship1Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name1Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _secoendNameTf = [(UITextField*)self.tableView viewWithTag:101];
            _secoendNameTf.placeholder = @"请输入联系人姓名";
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"connection1Cell" forIndexPath:indexPath];
            _telLab2 =  (UILabel *)[self.tableView viewWithTag:201];
            _relationShipLab2 = (UILabel*)[self.tableView viewWithTag:301];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VVLog(@"row1");
            [self getCustomerContactsRelationShip:@"first"];
          
        }else if(indexPath.section == 1){
            
        }else{
            _addBook=[[XHJAddressBook alloc]init];
            self.listContent=[_addBook getAllPerson];
            if(_listContent==nil)
            {
                [self showAlert];
            }else{
                NSMutableArray *mutArr =[NSMutableArray arrayWithCapacity:30];
                for (NSMutableArray *temMutArr1 in _listContent) {
                    for (NSMutableDictionary *dict in temMutArr1) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        PersonModel *model = [PersonModel mj_objectWithKeyValues:dict];
                        NSString *tel = [[model.tel componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
                        [dic setValue:model.name1 forKey:@"name"];
                        [dic setValue:tel forKey:@"phoneNum"];
                        [mutArr addObject:dic];
                    }
                }
                NSString *jsonString = [[JJJsonTransformation sharedInstance] toJSONData:mutArr];
                self.contactStr = jsonString;
                VVLog(@"jsonString = %@",jsonString);
                __weak __typeof(self)weakSelf = self;
                JJContactsViewController *vc = [[JJContactsViewController alloc]init];
                vc.listContent = self.listContent;
                vc.getTelBlock = ^(NSString *tel) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    strongSelf.telLab1.text = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [strongSelf sureButtonStatues];
                    [strongSelf markAuthorizationTime];
                };
                [self customPushViewController:vc withType:nil subType:nil];
            }
        }
    }else{
        if (indexPath.row == 0) {
            VVLog(@"row2");
            [self getCustomerContactsRelationShip:@"second"];

        }else if(indexPath.row == 1){
            
        }else{
            _addBook=[[XHJAddressBook alloc]init];
            self.listContent=[_addBook getAllPerson];
            if(_listContent==nil)
            {
                [self showAlert];
            }else{
                NSMutableArray *mutArr =[NSMutableArray arrayWithCapacity:30];
                for (NSMutableArray *temMutArr1 in _listContent) {
                    for (NSMutableDictionary *dict in temMutArr1) {
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        PersonModel *model = [PersonModel mj_objectWithKeyValues:dict];
                        NSString *tel = [[model.tel componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
                        [dic setValue:model.name1 forKey:@"name"];
                        [dic setValue:tel forKey:@"phoneNum"];
                        [mutArr addObject:dic];
                    }
                }
                NSString *jsonString = [[JJJsonTransformation sharedInstance] toJSONData:mutArr];
                self.contactStr = jsonString;
                VVLog(@"jsonString = %@",jsonString);
                __weak __typeof(self)weakSelf = self;
                JJContactsViewController *vc = [[JJContactsViewController alloc]init];
                vc.listContent = self.listContent;
                vc.getTelBlock = ^(NSString *tel) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    strongSelf.telLab2.text = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [strongSelf sureButtonStatues];
                    [strongSelf markAuthorizationTime];

                };
                [self customPushViewController:vc withType:nil subType:nil];
            }
        }
    }
}

-(void)markAuthorizationTime{
    
    if( VV_IS_NIL([self readAuthorizationTime])){
    NSString *plistPath = [VVPathUtils contactAuthorizationTimePlistPath];
    NSDictionary *authorizationTimeDict ;
    NSString *timeStp = [NSString stringWithFormat:@"%@",[VVCommonFunc currentYearMounthDayTime]];
    VVLog(@"timeStp%@",timeStp);
    authorizationTimeDict = @{@"key":timeStp};
    [authorizationTimeDict writeToFile:plistPath atomically:YES];
    }
}

-(NSString*)readAuthorizationTime{
    NSString *plistPath = [VVPathUtils contactAuthorizationTimePlistPath];
    NSDictionary *authorizationTimeDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *authorizationTime = [authorizationTimeDict safeObjectForKey:@"key"];
    VVLog(@"authorizationTime%@",authorizationTime);
    return authorizationTime;
}

-(void)initData
{
    _addBook=[[XHJAddressBook alloc]init];
    self.listContent=[_addBook getAllPerson];
    if(_listContent==nil)
    {
        [self showAlert];
    }else{
        NSMutableArray *mutArr =[NSMutableArray arrayWithCapacity:30];
        for (NSMutableArray *temMutArr1 in _listContent) {
            for (NSMutableDictionary *dict in temMutArr1) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                PersonModel *model = [PersonModel mj_objectWithKeyValues:dict];
                [dic setValue:model.name1 forKey:@"name"];
                NSString *tel = [[model.tel componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
                [dic setValue:tel forKey:@"phoneNum"];
                [mutArr addObject:dic];
            }
        }
        NSString *jsonString = [[JJJsonTransformation sharedInstance] toJSONData:mutArr];
        self.contactStr = jsonString;
        VVLog(@"jsonString = %@",jsonString);
    }
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的通讯录暂未允许访问，请去设置->隐私里面授权!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChangeNotification:(NSNotification *)notification
{
    [self sureButtonStatues];
}

-(void)sureButtonStatues{
    UITextField*firstNameTf =  (UITextField *)[self.tableView viewWithTag:100];
    UITextField*secondNameTf =  (UITextField *)[self.tableView viewWithTag:101];
    UILabel*text0 =  (UILabel *)[self.tableView viewWithTag:200];
    UILabel*text1 =  (UILabel *)[self.tableView viewWithTag:201];
    if (!VV_IS_NIL(text0.text)&&!VV_IS_NIL(text1.text)&&!VV_IS_NIL(_relationShipLab1.text)&&!VV_IS_NIL(_relationShipLab2.text)&&!VV_IS_NIL(firstNameTf.text)&&!VV_IS_NIL(secondNameTf.text)) {
        _sureButton.enabled = YES;
        _sureButton.userInteractionEnabled = YES;
    }else{
        _sureButton.enabled = NO;
        _sureButton.userInteractionEnabled = NO;
    }
}

-(void)getCustomerContactsRelationShip:(NSString*)relationShip{
    __weak __typeof(self)weakSelf = self;
    [self showHud];
    [[VVNetWorkUtility netUtility] getCustomerContactsRelationShipParameters:nil success:^(id result) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideHud];
        if ([[result safeObjectForKey:@"success"] boolValue]) {
           strongSelf.relationShipArr = [(NSDictionary*)[result safeObjectForKey:@"data"] objectForKey:@"customerRelationship"];
            [strongSelf pushNextViewController:(NSString*)relationShip];
        }else{
            [MBProgressHUD showError:[result safeObjectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hideHud];
        [MBProgressHUD showError:@"连接不上服务器，请稍后再试!"];

    }];
}
-(void)pushNextViewController:(NSString*)relationShip{
    __weak __typeof(self)weakSelf = self;
    JJConnectionRelationshipViewController *vc = [[JJConnectionRelationshipViewController alloc]init];
    vc.relationShipArr = self.relationShipArr;
    vc.connectionblock = ^(NSString *text) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([relationShip isEqualToString:@"first"]) {
            strongSelf.relationShipLab1.text = text;
        }else{
            strongSelf.relationShipLab2.text = text;
        }
        [strongSelf sureButtonStatues];
    };
    [self customPushViewController:vc withType:nil subType:nil];
}

- (void)gotoSign
{
    JJH5SignViewController *signVc = [[JJH5SignViewController alloc]init];
    signVc.webTitle = @"电子合同";
    NSString *url = [NSString stringWithFormat:@"%@/sign2.html?idcard=%@&token=%@&name=%@&customerId=%@",WEB_BASE_URL,self.cardId,[UserModel currentUser].token,self.name,[UserModel currentUser].customerId];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    signVc.startPage = url;
    [self customPushViewController:signVc withType:nil subType:nil];
}
-(void)getCustomersOrderDetail{
    __weak __typeof(self)weakSelf = self;
    [self showHud];
    [[VVNetWorkUtility netUtility]getCustomersOrderDetailsWithAccountId:[UserModel currentUser].customerId success:^(id result) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [self hideHud];
        if ([[result safeObjectForKey:@"success"]boolValue]) {
            strongSelf.cardId = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantIdcard"];
            strongSelf.name = [[result safeObjectForKey:@"data"] safeObjectForKey:@"applicantName"];
            
            if (strongSelf.cardId == nil) {
                [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
                return ;
            }
            [strongSelf gotoSign];
        }else{
            [MBProgressHUD showError:[result safeObjectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [MBProgressHUD showError:@"获取数据失败，请稍后再试"];
    }];
}


@end
