//
//  JJcouponListCell.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/11/29.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJcouponListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end
