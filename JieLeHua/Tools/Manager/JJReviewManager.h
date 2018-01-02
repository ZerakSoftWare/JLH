//
//  JJReviewManager.h
//  JieLeHua
//
//  Created by pingyandong on 2017/6/28.
//  Copyright © 2017年 Vcredit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJReviewManager : NSObject
+ (JJReviewManager *)reviewManager;
@property (nonatomic, assign) BOOL reviewing;
@end
