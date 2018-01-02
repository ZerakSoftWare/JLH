//
//  JJAddBankCardRequest.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "JJBaseRequest.h"

/*{
"bankCode": "string",
"bankName": "string",
"bankPersonAccount": "string",
"bankPersonMobile": "string",
"bankPersonName": "string",
"createTime": "2017-03-07T03:04:08.984Z",
"customerBankId": 0,
"customerId": 0,
"enabledTime": "2017-03-07T03:04:08.984Z",
"isDrawMoneyBankcard": 0,
"isEnabled": 0,
"modifyTime": "2017-03-07T03:04:08.984Z",
"unenabledTime": "2017-03-07T03:04:08.984Z",
"url": "string"
}*/
@interface JJAddBankCardRequest : JJBaseRequest
- (instancetype)initWithParam:(NSDictionary *)param;
@end
