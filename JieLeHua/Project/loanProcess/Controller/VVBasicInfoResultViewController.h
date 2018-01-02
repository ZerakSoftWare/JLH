//
//  VVBasicInfoResultViewController.h
//  O2oApp
//
//  Created by chenlei on 16/5/12.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import "VVBaseViewController.h"
#import "VVCreditBaseViewController.h"
@interface VVBasicInfoResultViewController : VVCreditBaseViewController

@property(nonatomic,assign)CGFloat lableTop;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)BOOL btnHidden;
@property(nonatomic,assign)BOOL qrHidden;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,assign)BOOL isMineController;
@property(nonatomic,copy)NSString *noStore;

@end
