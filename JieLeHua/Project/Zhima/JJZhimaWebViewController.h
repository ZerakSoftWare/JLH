//
//  JJZhimaWebViewController.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "VVWebAppViewController.h"
typedef void (^AuthorizationSuccessBlock)(NSString *score);

@interface JJZhimaWebViewController : VVWebAppViewController
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *name;
@property(nonatomic,copy) AuthorizationSuccessBlock authorizationSuccessBlockSuccBlock;

@end
