//
//  JJOverDueTableViewCell.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/11.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJOverDueListModel.h"

@interface JJOverDueTableViewCell : UITableViewCell
- (void)setupOverdueCellWithData:(JJOverDueListDataModel *)data;
@end
