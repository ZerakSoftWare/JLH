//
//  VVVcreditSignWebViewController.h
//  O2oApp
//
//  Created by chenlei on 16/7/11.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVWebAppViewController.h"
typedef void (^SignSuccessBlock)(NSString*persomalImageBase64);

@interface VVVcreditSignWebViewController : VVWebAppViewController
@property(nonatomic,copy)SignSuccessBlock signSuccBlock;
@end
