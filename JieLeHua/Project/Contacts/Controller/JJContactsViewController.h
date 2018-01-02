//
//  ViewController.h
//  BeautyAddressBook
//
//  Created by 余华俊 on 15/10/22.
//  Copyright © 2015年 hackxhj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetTelBlock)(NSString*tel);
@interface JJContactsViewController : VVBaseViewController

@property(nonatomic,strong)NSMutableArray *listContent;
@property(nonatomic,copy) GetTelBlock getTelBlock ;
@end

