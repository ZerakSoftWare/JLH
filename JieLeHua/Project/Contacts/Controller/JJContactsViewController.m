//
//  ViewController.m
//  BeautyAddressBook
//
//  Created by 余华俊 on 15/10/22.
//  Copyright © 2015年 hackxhj. All rights reserved.
//

#import "JJContactsViewController.h"
#import "XHJAddressBook.h"
#import  "PersonModel.h"
#import "PersonCell.h"

@interface JJContactsViewController()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) PersonModel *people;
@end

#define  mainWidth [UIScreen mainScreen].bounds.size.width
#define  mainHeigth  [UIScreen mainScreen].bounds.size.height
@implementation JJContactsViewController
{
    UITableView *_tableShow;
    XHJAddressBook *_addBook;
}

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    JJContactsViewController *instance = [[JJContactsViewController alloc] init];
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpNavigation];
    _sectionTitles=[NSMutableArray new];
    _tableShow=[[UITableView alloc]initWithFrame:CGRectMake(0, (iPhoneX ? 88 : 64), mainWidth, mainHeigth-(iPhoneX ? 88 : 64))];
    _tableShow.delegate=self;
    _tableShow.dataSource=self;
    [self.view addSubview:_tableShow];
    _tableShow.sectionIndexBackgroundColor=[UIColor clearColor];
    _tableShow.sectionIndexColor = [UIColor blackColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        [self initData];
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [self setTitleList];
                          [_tableShow reloadData];
                      });
    });
    
    
}

-(void)setUpNavigation{
    [self setNavigationBarTitle:@"通讯录"];
    [self addBackButton];
}

-(void)setTitleList
{
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[theCollation sectionTitles]];
    NSMutableArray * existTitles = [NSMutableArray array];
    for(int i=0;i<[_listContent count];i++)//过滤 就取存在的索引条标签
    {
        PersonModel *pm=_listContent[i][0];
        for(int j=0;j<_sectionTitles.count;j++)
        {
            if(pm.sectionNumber==j)
                [existTitles addObject:self.sectionTitles[j]];
        }
    }
    
    
    
    
    [self.sectionTitles removeAllObjects];
    self.sectionTitles =existTitles;
    
}


-(NSMutableArray*)listContent
{
    if(_listContent==nil)
    {
        _listContent=[NSMutableArray new];
    }
    return _listContent;
}
-(void)initData
{
    _addBook=[[XHJAddressBook alloc]init];
    self.listContent=[_addBook getAllPerson];
    if(_listContent==nil)
    {
        NSLog(@"数据为空或通讯录权限拒绝访问，请到系统开启");
        return;
    }
    
}

//几个  section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listContent count];
    
}
//对应的section有多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_listContent objectAtIndex:(section)] count];
    
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//section的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(self.sectionTitles==nil||self.sectionTitles.count==0)
        return nil;
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    NSString *sectionStr=[self.sectionTitles objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer=@"addressCell";
    PersonCell *personcell=(PersonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if(personcell==nil)
    {
        personcell=[[PersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
    }
    
    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
    _people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    [personcell setData:_people];
    
    return personcell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
    self.people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    if (_getTelBlock) {
        _getTelBlock(_people.tel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIApplication *app = [UIApplication sharedApplication];
    if (buttonIndex == 1)
    {
        [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
    }else if (buttonIndex == 2)
    {
        
    }
}



//开启右侧索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
