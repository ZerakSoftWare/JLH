//
//  JJSelectBankTableViewCell.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^endSelect)(NSString *,NSString *);
@interface JJSelectBankTableViewCell : UITableViewCell
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, copy) endSelect endSelectBlock;
@property (weak, nonatomic) IBOutlet UITextField *bankNameField;

@end
