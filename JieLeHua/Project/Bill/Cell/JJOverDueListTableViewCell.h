//
//  JJOverDueTableViewCell.h
//  JieLeHua
//
//  Created by pingyandong on 2017/11/30.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJBillDetailModel.h"

@interface JJOverDueListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
- (void)setUpWithData:(JJCustomerBillDetailDataModel *)data;
@end
