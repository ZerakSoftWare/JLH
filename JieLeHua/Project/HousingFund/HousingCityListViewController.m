//
//  HousingCityListViewController.m
//  JieLeHua
//
//  Created by admin2 on 2017/8/16.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "HousingCityListViewController.h"
#import "HouseCityModel.h"
#import "LocateCityCommand.h"
#import "CommandManage.h"

#pragma mark Constants


#pragma mark - Class Extension

@interface HousingCityListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

//--搜索结果数据源
@property (strong, nonatomic) NSMutableArray *searchDataSource;

//--索引数据源
@property (strong, nonatomic) NSMutableArray *indexDataSource;

/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *allDataSource;

@property (assign, nonatomic) BOOL isSearch;

@property (nonatomic, strong) HouseCityModel *locationModel;

//--定位lab
@property (nonatomic, strong) UILabel *locationLab;

//--定位Btn
@property (nonatomic, strong) UIButton *locationBtn;

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation HousingCityListViewController


#pragma mark - Properties

- (UILabel *)locationLab {
    if (!_locationLab) {
        _locationLab = [[UILabel alloc] init];
        _locationLab.textColor = RGB(102, 102, 102);
        _locationLab.font = kFont_BarButtonItem_Title;
        _locationLab.text = @"正在定位";
    }
    return _locationLab;
}

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

- (NSMutableArray *)searchDataSource {
    if (!_searchDataSource) {
        _searchDataSource = [[NSMutableArray alloc] init];
    }
    return _searchDataSource;
}

- (NSMutableArray *)indexDataSource {
    if (!_indexDataSource) {
        _indexDataSource = [[NSMutableArray alloc] init];
    }
    return _indexDataSource;
}

- (NSMutableArray *)allDataSource {
    if (!_allDataSource) {
        _allDataSource = [[NSMutableArray alloc] init];
    }
    return _allDataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, vScreenWidth, vScreenHeight-64)];
         _tableView.sectionIndexColor = RGB(13, 136, 255);
        _tableView.delegate  = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 12, vScreenWidth, 36);
        _searchBar.delegate =  self;
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.barTintColor = RGB(241, 244, 246);
        _searchBar.placeholder = @"输入城市名称或首字母";
    }
    return _searchBar;
}

#pragma mark - Constructors


#pragma mark - Destructor

- (void)dealloc 
{
    
}


#pragma mark - Public Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isSearch)
    {
        return self.indexDataSource.count;
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
        return [self.allDataSource[section] count];
    }
    else
    {
        return self.searchDataSource.count;
    }
}

//--右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (!_isSearch)
    {
        return self.indexDataSource;
    }
    else
    {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
    header.backgroundColor = RGB(241, 244, 246);
    
    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 20)];
    sectionHeader.font = [UIFont systemFontOfSize:17];
    sectionHeader.textColor = kColor_Main_Color;
    sectionHeader.text = self.indexDataSource[section];
    [header addSubview:sectionHeader];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!_isSearch)
    {
        return 20;
    }
    else
    {
        return 0;
    }
}

//--索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

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
        HouseCityModel *obj = self.allDataSource[indexPath.section][indexPath.row];
        cell.textLabel.text = obj.CityName;
    }
    else
    {
        HouseCityModel *obj = self.searchDataSource[indexPath.row];
        cell.textLabel.text = obj.CityName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseCityModel *item;
    
    if (!_isSearch)
    {
        item = self.allDataSource[indexPath.section][indexPath.row];
    }
    else
    {
        item = self.searchDataSource[indexPath.row];
    }
    
    if (self.selectBlock)
    {
        self.selectBlock(item);
    }
    
    [self customPopViewController];
}

- (void)scrollViewDidScroll:(UITableView *)tableView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchBar becomeFirstResponder];
    [self.searchDataSource removeAllObjects];
    
    NSMutableArray *ary = [self searchWithSearchText:searchText];
    
    if (searchText.length == 0)
    {
        _isSearch = NO;
        [self.searchDataSource addObjectsFromArray:self.allDataSource];
    }
    else
    {
        _isSearch = YES;
        [self.searchDataSource addObjectsFromArray:ary];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchBar.frame = CGRectMake(0, 64, kScreenWidth, 44);
    self.navigationController.navigationBarHidden = NO;
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    self.isSearch = NO;
    [self.tableView reloadData];
}

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    HousingCityListViewController *instance = [[HousingCityListViewController alloc] init];
    return instance;
}

#pragma mark - Overridden Methods

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self setNavigationBarTitle:@"选择城市"];
    [self addBackButton];
    
    self.view.backgroundColor = RGB(241, 244, 246);
    
    [self LetterSortArray:self.dataSource];
    
    _isSearch = NO;
    
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
    
    [self.searchBar layoutSubviews];
    
    for (UIView *view in self.searchBar.subviews)
    {
        for (UITextField *textfield in view.subviews)
        {
            if ([textfield isKindOfClass:[UITextField class]]) {
                textfield.frame = CGRectMake(12, 0.0f, textfield.frame.size.width-24, 36);
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (void)LetterSortArray:(NSArray *)stringArr
{
    //分组存放首字母相同的string
    NSMutableArray *item = [NSMutableArray array];
    NSString *tempString ;
    //拼音分组
    for (HouseCityModel *object in stringArr)
    {
        NSArray *ary = [object.CityCode componentsSeparatedByString:@"_"];
        NSString *pinyin = [[ary lastObject] substringToIndex:1];

        if(![tempString isEqualToString:pinyin])
        {
            //分组
            item = [NSMutableArray array];
            [item addObject:object];
            [self.allDataSource addObject:item];
            //遍历
            tempString = pinyin;
            
            [self.indexDataSource addObject:pinyin];
        }
        else
        {
            //相同
            [item addObject:object];
        }
    }
}

- (void)initAndLayoutUI
{
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [self headView];
    
    [self getLocationString];
}

- (UIView *)headView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vScreenWidth, 106)];
    view.backgroundColor = RGB(241, 244, 246);
    
    [self.searchBar sizeToFit];
    [view addSubview:self.searchBar];
    
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, vScreenWidth, 46)];
    locationView.backgroundColor = [UIColor whiteColor];
    [view addSubview:locationView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLocationCityAction)];
    [locationView addGestureRecognizer:tapGes];
    
    [locationView addSubview:self.locationLab];
    [locationView addSubview:self.locationBtn];
    
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.locationLab.mas_right).offset(12);
    }];
    
    return view;
}

- (void)getLocationString
{
    self.locationLab.text = @"正在定位";
    
    LocateCityCommand *cityCmd = [LocateCityCommand command];
    cityCmd.timeOutDefault = 60.0;
    [CommandManage excuteCommand:cityCmd completeBlock:^(id<Command> cmd) {
        
        switch (cityCmd.responseStatus) {
            case LocateCitySuccess: //定位成功
            {
                self.locationLab.text = cityCmd.cityName;
                
                for (HouseCityModel *item in self.dataSource)
                {
                    BOOL nameIsEqual = [cityCmd.cityName isEqualToString:item.CityName];
                    
                    BOOL nameHasPrefix = [cityCmd.cityName hasPrefix:item.CityName];
                    
                    if (nameHasPrefix || nameIsEqual)
                    {
                        self.locationModel = item;
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
                self.locationLab.text = @"定位失败";
                break;
        }
    }];
}

//--选择定位的城市
- (void)selectLocationCityAction
{
    if (!self.locationModel)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                        message:@"请选择地级市"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [alert show];
        
        return;
    }

    if (self.selectBlock)
    {
        self.selectBlock(self.locationModel);
    }
    
    [self customPopViewController];
}

- (NSMutableArray *)searchWithSearchText:(NSString *)searchText
{
    NSMutableArray *ary = [NSMutableArray new];
    
    for (HouseCityModel *item in self.dataSource)
    {
        for (NSString *str in item.KeyWords)
        {
            if ([str hasPrefix:[searchText uppercaseString]])
            {
                [ary addObject:item];
                break;
            }
        }
    }
    
    return ary;
}

@end
