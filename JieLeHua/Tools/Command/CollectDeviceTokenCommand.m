//
//  CollectDeviceTokenCommand.m
//  JieLeHua
//
//  Created by kuang on 2017/3/8.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "CollectDeviceTokenCommand.h"
#import "UMBindDriveTokeRequest.h"

@implementation CollectDeviceTokenCommand

- (void)execute
{
    if (VV_IS_NIL(VV_SHDAT.deviceToken)) {
        return;
    }
    
    NSDictionary *param = @{
                            @"customerId":[UserModel currentUser].customerId,
                            @"deviceToken": VV_SHDAT.deviceToken,
                            @"system":@"ios"
                            };
    
    UMBindDriveTokeRequest *bindTokenRequest = [[UMBindDriveTokeRequest alloc] initWithParam:param];
    [bindTokenRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        [self done];
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [self done];
    }];
}

@end
