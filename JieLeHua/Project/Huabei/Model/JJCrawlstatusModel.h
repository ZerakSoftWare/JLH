//
//  JJCrawlstatusModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJCrawlstatusModel : NSObject
@property (nonatomic, assign) NSInteger CrawlStatus;
@property (nonatomic, assign) NSInteger StatusCode;
@property (nonatomic, copy) NSString *StatusDescription;
@end
