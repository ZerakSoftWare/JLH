//
//  OnlineServiceViewController.h
//  JieLeHua
//
//  Created by admin on 2017/11/13.
//Copyright © 2017年 Vcredit. All rights reserved.
//

#import "HDMessageViewController.h"

#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface OnlineServiceViewController : HDMessageViewController<HDMessageViewControllerDelegate, HDMessageViewControllerDataSource>


#pragma mark - Properties


#pragma mark - Constructors

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

- (void)userAccountDidLoginFromOtherDevice;

#pragma mark - Static Methods


#pragma mark - Instance Methods


@end
