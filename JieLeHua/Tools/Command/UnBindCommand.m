//
//  UnBindCommand.m
//  JieLeHua
//
//  Created by kuang on 2017/3/14.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "UnBindCommand.h"
#import "UnBindRequest.h"

@implementation UnBindCommand

- (void)execute
{
    UnBindRequest *unBindTokenRequest = [[UnBindRequest alloc] init];
    [unBindTokenRequest startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        [self done];
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        [self done];
    }];
}

@end
