//
//  JJOverDueTableViewCell.m
//  JieLeHua
//
//  Created by pingyandong on 2017/3/11.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJOverDueTableViewCell.h"

@interface JJOverDueTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueDetailLabel;

@end

@implementation JJOverDueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupOverdueCellWithData:(JJOverDueListDataModel *)data
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@/%@期",@(data.billPeriod),@(data.postLoanPeriod)];
    self.overdueDetailLabel.text = [NSString stringWithFormat:@"%.2f元   已逾期",data.dueSumamt];
}

@end
