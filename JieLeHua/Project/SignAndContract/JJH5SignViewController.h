//
//  JJH5SignViewController.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "VVWebAppViewController.h"
typedef void (^DrawSignSuccessBlock)();
@interface JJH5SignViewController : VVWebAppViewController
@property(nonatomic,copy)DrawSignSuccessBlock signSuccBlock;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *name;

//--是否是修改银行卡
@property (nonatomic, assign) BOOL isModifyBank;

@end
