//
//  VVAlertUtils.m
//  VCREDIT
//
//  Created by kevin on 15-3-5.
//  Copyright (c) 2015年  vcredit. All rights reserved.
//

#import "VVAlertUtils.h"

@implementation VVAlertUtils
#pragma mark -
#pragma mark - block 调用alertView
+ (VVAlertView*)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                            customView :(UIView *) view
                      cancelButtonTitle:(NSString *)cancelTitle
                      otherButtonTitles:(NSArray *)otherButtonTitles
                                    tag:(NSInteger)tag
                          completeBlock:(VVAlertViewBlock)block
{
  
  if (VV_IS_NIL(cancelTitle) && [otherButtonTitles count] < 1) {
    return nil;
  }
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    VVAlertView* alertView = [[VVAlertView alloc] initWithWindow:window];
  [alertView resetLayout];
  alertView.title = title;
  alertView.subtitle = message;
  alertView.customView = view;
  alertView.block = block;

  if (!VV_IS_NIL(cancelTitle)) {
    [alertView addButtonCancel:cancelTitle];
  }
  if ([otherButtonTitles count] > 0) {
    [alertView addOtherButtons:otherButtonTitles specialIndex:-1];
  }
    alertView.tag = tag;
//    if ([VVAlertView alertView].alertViewArr.count>1) {
//        VVAlertView *alert = [[VVAlertView alertView].alertViewArr firstObject];
        //    if (tag == 999) {
//        if (alert.tag !=999) {
//            [alert hideAlertViewAnimated:YES];
//        }
        //    }
//    }
  
  
    [VV_NC postNotificationName:@"endEditingKeyBoad" object:[VVAlertView alertView].alertViewArr];
    
    __block BOOL isLogin = NO;;
    [[VVAlertView alertView].alertViewArr enumerateObjectsUsingBlock:^(VVAlertView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.tag == 999){
            isLogin = YES;
            *stop = YES;
        }
    }];
    
    
    if (alertView.tag ==999) {
        [alertView removeAllAlert];
        [alertView showOrUpdateAnimated:YES];
        [[VVAlertView alertView].alertViewArr addObject:alertView];

        return alertView;
    }
    
   if (isLogin) {
        [[VVAlertView alertView].alertViewArr enumerateObjectsUsingBlock:^(VVAlertView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.tag != 999){
                [obj hideAlertViewAnimated:YES];
            }
        }];
    }else{
        [[VVAlertView alertView].alertViewArr addObject:alertView];
        [alertView showOrUpdateAnimated:YES];
    }
   
  return alertView;
}

#pragma mark - show alertView 只接收message 和cancelTitle参数
+ (VVAlertView *)showAlertViewWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle tag:(NSInteger)tag completeBlock:(VVAlertViewBlock)block {
  return  [self showAlertViewWithTitle:@"提示"
                               message:message
                            customView:nil
                     cancelButtonTitle:cancelTitle
                     otherButtonTitles:nil
                                   tag:tag
                         completeBlock:block];
}



@end
