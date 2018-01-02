//
//  JJBillAndNotiCountManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJBillAndNotiCountManager : NSObject
+ (instancetype)sharedBillAndNotiCountManager;

/*
 * 根据对应用户的时间戳获取消息和账单的小红点状态
 */
- (void)updateNotiCount;

//保存
- (void)saveTimeStamp;

//更新首页右上角按钮
- (void)updateHomeRightBtnHidden:(BOOL)hidden;

//是否显示账单小红点
- (BOOL)showBillRed;

//是否显示消息小红点
- (BOOL)showMessageRed;

///清除小红点状态
- (void)clearRedStatus;

///账单已读
- (void)clearBillStatus;

///消息已读
- (void)clearMessageStatus;
@end
