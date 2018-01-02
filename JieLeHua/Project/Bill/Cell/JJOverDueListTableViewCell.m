//
//  JJOverDueTableViewCell.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/30.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJOverDueListTableViewCell.h"

@interface JJOverDueListTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation JJOverDueListTableViewCell

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
    self.desLabel.text = @"";
    if ([data.billPeriod isEqualToString:@"0"]) {
        self.titleContentLabel.text = @"平台推荐费";
        self.desLabelHeight.constant = 8.5;
        self.moneyLabel.text = [NSString stringWithFormat:@"%@元",data.dueSumamt];
    }
    else {
        self.desLabelHeight.constant = 8.5;
        self.titleContentLabel.text = [NSString stringWithFormat:@"%@/%@期",data.billPeriod,data.postLoanPeriod];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",data.dueSumamt];
}

@end
