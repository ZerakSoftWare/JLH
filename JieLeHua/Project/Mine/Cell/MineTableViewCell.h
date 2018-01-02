//
//  MineTableViewCell.h
//  JieLeHua
//
//  Created by admin on 17/3/2.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lab;

@property (nonatomic, strong) UIImageView *leftImg;

@property (nonatomic, strong) UIView *bottomSeparateLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
