//
//  JJVersionSourceManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/5/15.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

/*版本管理*/
@interface JJVersionSourceManager : NSObject
+ (JJVersionSourceManager *)versionSourceManager;
/**
 * versionSource 0:完整版 1:h5 2:极速版  4:新用户未选择极速还是完整版
 */
@property (nonatomic, copy) NSString *versionSource;
#pragma mark - 开始极速申请beginApply
- (void)startFastApplyWithView:(UIView *)view;
@end
