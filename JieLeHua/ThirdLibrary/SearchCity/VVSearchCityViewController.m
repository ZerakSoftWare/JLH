//
//  VVSearchCityViewController.m
//  O2oApp
//
//  Created by YuZhongqi on 16/4/21.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVSearchCityViewController.h"
#import "ChineseString.h"
#import "ZYPinYinSearch.h"
#import "VVSearchCityModel.h"
//#import "VVDistributionStoreViewController.h"

#import "LocateCityCommand.h"
#import "CommandManage.h"
#import "JJCityListRequest.h"


@interface VVSearchCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
/**<排序前的整个数据源*/
@property(nonatomic,strong) NSArray *dataSource;
@property(nonatomic,weak) UITableView * tableView;
@property(nonatomic,weak) UISearchBar * searchBar;
@property (assign, nonatomic) BOOL isSearch;
/**<搜索结果数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;
/**<索引数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;
/**<排序后的整个数据源*/
@property (strong, nonatomic) NSArray *allDataSource;

/**
 *  定位mode
 */
@property (nonatomic, strong) ChineseString *locationMode;

/**
 *  定位按钮
 */
@property (nonatomic, strong) UIButton *locationBtn;

@end

@implementation VVSearchCityViewController

- (UIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setTitle:@"GPS定位" forState:UIControlStateNormal];
        [_locationBtn setTitleColor:VVColor(13, 136, 256) forState:UIControlStateNormal];
        [_locationBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_locationBtn addTarget:self action:@selector(getLocationString) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationBtn;
}

- (ChineseString *)locationMode {
    if (!_locationMode) {
        _locationMode = [[ChineseString alloc] init];
    }
    return _locationMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VVWhiteColor;
    [self setNavigationBarTitle:@"城市查询"];

    if (_loanViewController) {
        [self setNavigationBarTitle:@"选择城市"];
    }
    
    [self setupBackButton:@"btn_nav_bar_return" and:nil];
    
    [self setupSubView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self loadData];
}

-(void)setupBackButton:(NSString*)imageName and:(NSString*)highLightedImageName{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highLightedImageName] forState:UIControlStateHighlighted];
    btn.backgroundColor = VVclearColor;
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(18, 28, 27, 27);
    [_navigationBar addSubview:btn];
    
}

-(void)backBtnClick
{
    if (_loanViewController) {
        [self customPopViewController];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)loadData
{
    JJCityListRequest *request = [[JJCityListRequest alloc] init];
    JJRequestAccessory *accessory = [[JJRequestAccessory alloc] initWithShowVC:self];
    [request addAccessory:accessory];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        NSDictionary *result = request.responseJSONObject;
        if ([result[@"code"] integerValue] == 200) {
            
            NSString *jsonStr = [result safeObjectForKey:@"data"];
            
            NSData* data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
            
            if (resultArr.count == 0) {
                [MBProgressHUD bwm_showTitle:@"对不起，暂不支持城市查询"
                                      toView:self.view
                                   hideAfter:1.2f];
                return ;
            }
            _dataSource = resultArr;
            //搜索结果数据源
            _searchDataSource = [NSMutableArray new];
            
            //获取索引的首字母
            _indexDataSource = [ChineseString IndexArray:resultArr];
            
            //对原数据进行排序重新分组
            _allDataSource = [ChineseString LetterSortArray:resultArr];
            
            [_tableView reloadData];
            [self getLocationString];
            
        }else if ([result[@"code"] integerValue]>=600&&[result[@"code"] integerValue]<700){
            
            [MBProgressHUD bwm_showTitle:result[@"message"]
                                  toView:self.view
                               hideAfter:1.2f];
            
        }else{
            
        }

    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        
    }];
    
}

-(void)setupSubView
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0, 64 + 44, vScreenWidth, vScreenHeight-44 - 20 - 40);
    tableView.delegate  = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UISearchBar *searchBar = [[ UISearchBar alloc]init];
    searchBar.frame = CGRectMake(0, 64, vScreenWidth, 44);
    searchBar.delegate =  self;
    searchBar.barTintColor = [UIColor colorWithHexString:@"F1F1F1"];
    searchBar.placeholder = @"输入城市名称或者拼音查询";
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    //设置cancelbutton汉子效果 没出来啊＝＝＝＝＝
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isSearch)
    {
        return _indexDataSource.count + 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_isSearch)
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return [_allDataSource[section - 1] count];
        }
    }
    else
    {
        return _searchDataSource.count;
    }
}

//头部索引标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!_isSearch)
    {
        if (section == 0)
        {
            return nil;
        }
        else
        {
            return _indexDataSource[section - 1];
        }
    }
    else
    {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isSearch)
    {
        if (indexPath.section == 0)
        {
            return  46;
        }
        else
        {
            return 48;
        }
    }
    else
    {
        return 48;
    }
}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!_isSearch)
    {
       return _indexDataSource;
    }
    else
    {
        return nil;
    }
}

#pragma --tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
 
    cell.textLabel.textColor = VVColor(102, 102, 102);
    cell.textLabel.font = [UIFont systemFontOfSize:17];

    if (!_isSearch)
    {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            UITableViewCell *newCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"new"];
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vScreenWidth, 46)];
            view1.backgroundColor = VVWhiteColor;
            UILabel *locationLab = [[UILabel alloc]init];
            
            if (self.locationMode.string.length)
            {
                locationLab.text = self.locationMode.string;
            }
            else
            {
                locationLab.text = @"正在定位";
            }
            
            locationLab.font = [UIFont systemFontOfSize:17.f];
            locationLab.textColor = VVColor(102, 102, 102);
            newCell.backgroundColor = VVColor(241, 244, 246);
            [view1 addSubview:locationLab];
            
            [locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(view1);
                make.left.equalTo(@12);
            }];
            
            [view1 addSubview:self.locationBtn];
            
            [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(view1);
                make.left.equalTo(locationLab.mas_right).with.offset(12);
            }];
            
            [newCell addSubview:view1];
            newCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return newCell;
        }
        else
        {
            ChineseString *obj = _allDataSource[indexPath.section - 1][indexPath.row];
            cell.textLabel.text = obj.string;
        }
    }
    else
    {
        NSDictionary *dic = _searchDataSource[indexPath.row];
        cell.textLabel.text = dic[@"CityName"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *city , *cityCode;
    if (!_isSearch)
    {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            if (!self.locationMode.cityCode.length) {
                return;
            }
            
            city = self.locationMode.string;
            cityCode = self.locationMode.cityCode;
        }
        else
        {
            ChineseString *obj = _allDataSource[indexPath.section - 1][indexPath.row];
            cityCode = obj.cityCode;
            city = obj.string;
        }
    }
    else
    {
        NSDictionary *dic = _searchDataSource[indexPath.row];
        
        city = dic[@"CityName"];
        cityCode = [NSString stringWithFormat:@"%@",dic[@"CityCode"]];
    }

    if (_loanViewController) {
        
        [self customPopViewController];
        if (self.selectedRowInfo)
        {
            _selectedRowInfo(city,cityCode,nil);
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];

        if (self.selectedRowInfo)
        {
            _selectedRowInfo(city,cityCode,nil);
        }
    }
}

//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchBar becomeFirstResponder];
    [_searchDataSource removeAllObjects];
    NSArray *ary ;
    ary = [ZYPinYinSearch searchWithOriginalArray:_dataSource andSearchText:searchText andSearchByPropertyName:@"CityName"];
    if (searchText.length == 0)
    {
        _isSearch = NO;
        [_searchDataSource addObjectsFromArray:_allDataSource];
    }
    else
    {
        _isSearch = YES;
        [_searchDataSource addObjectsFromArray:ary];
    }
    
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}



//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [searchBar becomeFirstResponder];
//    
//    for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
//        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
//            UIButton * cancel =(UIButton *)view;
//            [cancel setTitle:@"取消" forState:UIControlStateNormal];
//            [cancel setTitle:@"取消" forState:UIControlStateHighlighted];
//            [cancel  setTintColor:[UIColor blackColor]];
//            [cancel.titleLabel setTextColor:[UIColor blackColor]];
//        }
//    }
//    
//    [UIView animateWithDuration:0.3 animations:^{
////        self.navigationController.navigationBarHidden = YES;
//        
//        _searchBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
//        _searchBar.showsCancelButton = YES;
//    }];
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _searchBar.frame = CGRectMake(0, 64, kScreenWidth, 44);
    self.navigationController.navigationBarHidden = NO;
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _isSearch = NO;
    [self.tableView reloadData];
}


- (void)loadStoreInfo:(NSString *)city success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [self showHud];
    [[VVNetWorkUtility netUtility]getCommonQueryStoresWithCity:city success:^(id result){
        [self hideHud];
        if (success) {
            success(result);
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [MBProgressHUD bwm_showTitle:[self strFromErrCode:error]
                              toView:self.view
                           hideAfter:1.2f];
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UITableView *)tableView
{
    [_searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLocationString
{
    LocateCityCommand *cityCmd = [LocateCityCommand command];
    cityCmd.timeOutDefault = 60.0;
    [CommandManage excuteCommand:cityCmd completeBlock:^(id<Command> cmd) {
        
        switch (cityCmd.responseStatus) {
            case LocateCitySuccess: //定位成功
            {
                NSArray *ary = [ZYPinYinSearch searchWithOriginalArray:_dataSource andSearchText:cityCmd.cityName andSearchByPropertyName:@"CityName"];
                
                for (NSDictionary *dic in ary)
                {
                    NSString *cityName = dic[@"CityName"];
                    NSString *provinceName;
                    
                    if (![dic[@"ProvinceName"] isEqual:[NSNull null]])
                    {
                        provinceName = dic[@"ProvinceName"];
                    }
                    else
                    {
                        provinceName = cityName;
                    }
                    
                    if([cityName hasPrefix:cityCmd.cityName] && [provinceName hasPrefix:cityCmd.stateName])
                    {
                        self.locationMode.cityCode = [NSString stringWithFormat:@"%@",dic[@"CityCode"]];
                        self.locationMode.string = cityName;
                        break;
                    }
                }
            }
                break;
            case LocateCityFail:   //定位失败

            case LocateCityAddressFail:  //获取详细地址信息失败

            case LocateCityServiceUnable: //定位服务不可用

            case LocateCityUserDenied:  //用户不允许定位
                
            default:
                self.locationMode.cityCode = @"";
                self.locationMode.string = @"定位失败";
                break;
        }
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

@end
