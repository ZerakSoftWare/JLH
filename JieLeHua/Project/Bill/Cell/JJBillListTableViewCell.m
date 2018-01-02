//
//  JJBillListTableViewCell.m
//  JieLeHua
//
//  Created by pingyandong on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "JJBillListTableViewCell.h"

@interface JJBillListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *drawDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *drawMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnMoneyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@end

@implementation JJBillListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupUIWithData:(JJBillListDataModel *)data
{
    if (data.isOverDue == 1) {
        //FF3130
        self.statusLabel.backgroundColor = [UIColor colorWithHexString:@"FF3130"];
        self.statusLabel.text = @"     逾期";
    }
    else{
        if (data.cloanStatus == 1) {
            //0E88FF
            self.statusLabel.backgroundColor = [UIColor colorWithHexString:@"0E88FF"];
            self.statusLabel.text = @"     正常";
        }else{
            self.statusLabel.backgroundColor = [UIColor colorWithHexString:@"7ED322"];
            self.statusLabel.text = @"     已还清";
        }
    }
    self.drawDateLabel.text = [data.loanStartTime substringToIndex:10];
    self.drawMoneyLabel.text = [NSString stringWithFormat:@"￥%@",data.drawMoney];
    if (data.cloanStatus == 0) {
        self.returnMoneyDateLabel.text = @"已还清";
        self.returnMoneyDateLabel.textColor = [UIColor blackColor];
        self.returnMoneyDateLabel.font = [UIFont boldSystemFontOfSize:21];
    }else{
        self.returnMoneyDateLabel.text = [NSString stringWithFormat:@"%@号",[[data.repayDate substringFromIndex:8] substringToIndex:2]];
    }
    self.periodLabel.text = [NSString stringWithFormat:@"%@期",data.postLoanPeriod];
}
@end
