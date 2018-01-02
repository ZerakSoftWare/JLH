//
//  MemberTableViewCell.h
//  JieLeHua
//
//  Created by admin on 2017/12/21.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JJMemberFeeBillModel;

typedef void (^RefundClickBlock)(void);

@interface MemberTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) JJMemberFeeBillModel *item;

@property (nonatomic, copy) RefundClickBlock clickOperation;

@property (nonatomic, strong) UIButton *applyRefundBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
