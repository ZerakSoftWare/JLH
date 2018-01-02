//
//  JJOrderTableViewCell.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/9/27.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UILabel *detialLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UILabel *weixinLab;

@end
