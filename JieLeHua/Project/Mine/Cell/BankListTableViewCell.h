//
//  BankListTableViewCell.h
//  JieLeHua
//
//  Created by admin on 17/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankListDTO;

@interface BankListTableViewCell : UITableViewCell

@property (nonatomic, strong) BankListDTO *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
