//
//  JJUnionPayWebViewController.h
//  JieLeHua
//
//  Created by YuZhongqi on 2017/11/10.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import "VVWebAppViewController.h"
typedef void (^PaySuccess)(BOOL isSuccess);

@interface JJUnionPayWebViewController : VVWebAppViewController
@property(nonatomic,copy) PaySuccess paySuccess ;

@end
