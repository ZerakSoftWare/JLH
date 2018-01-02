//
//  JJConnectionRelationshipViewController.m
//  JieLeHua
//
//  Created by YuZhongqi on 2017/8/30.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJConnectionRelationshipViewController.h"
#import "JJConnectionRelationshipCell.h"

@interface JJConnectionRelationshipViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;


@end

@implementation JJConnectionRelationshipViewController

static NSString *const connectionRelationshipCell = @"connectionRelationshipCell";

-(NSArray *)relationShipArr{
    if (!_relationShipArr) {
        _relationShipArr = [[NSArray alloc]init];
    }
    return _relationShipArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"联系人关系"];
    [self addBackButton];
    [self setUpSubview];
}


-(void)setUpSubview{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = VVWhiteColor;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource  = self;
    [tableView registerNib:[UINib nibWithNibName:@"JJConnectionRelationshipCell" bundle:nil] forCellReuseIdentifier:connectionRelationshipCell];
    tableView.frame =  CGRectMake(0, 0, vScreenWidth, vScreenHeight );
    tableView.height = self.relationShipArr.count * 44;
    [_scrollView addSubview:tableView];
    self.tableView = tableView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * relationShip = self.relationShipArr[indexPath.row];;
    if(self.connectionblock){
        _connectionblock(relationShip);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.relationShipArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JJConnectionRelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:connectionRelationshipCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.relationShipArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}





@end
