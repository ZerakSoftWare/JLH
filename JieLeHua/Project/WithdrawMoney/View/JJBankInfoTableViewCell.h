//
//  JJBankInfoTableViewCell.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^endEditText)(NSString *);
@interface JJBankInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) endEditText endEditBlock;
@end
