//
//  JJReturnedTableViewCell.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJReturnedTableViewCell.h"

@interface JJReturnedTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation JJReturnedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUpWithData:(JJCustomerBillDetailDataModel *)data
{
    if ([data.billPeriod isEqualToString:@"0"]) {
        self.titleContentLabel.text = @"平台推荐费";
        self.moneyLabel.text = [NSString stringWithFormat:@"%@元",data.reSumAmt];
    }
    else {
        self.titleContentLabel.text = [NSString stringWithFormat:@"%@/%@期",data.billPeriod,data.postLoanPeriod];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@元",data.reSumAmt];

    }
}
@end
