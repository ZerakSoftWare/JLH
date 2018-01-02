//
//  CheckUpdateCommand.m
//  JieLeHua
//
//  Created by kuang on 2017/3/8.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import "CheckUpdateCommand.h"
#import "CheckUpdateRequest.h"

@implementation CheckUpdateCommand

- (void)execute
{
    CheckUpdateRequest *request = [[CheckUpdateRequest alloc] init];
    [request startWithBlockSuccess:^(__kindof KZBaseRequest *request) {
        if ([[request.responseJSONObject safeObjectForKey:@"success"] integerValue] == 1)
        {
            NSDictionary *dic = [request.responseJSONObject safeObjectForKey:@"data"];
            if (dic == nil) {
                return ;
            }
            int updateMethod = [dic[@"updateMethod"] intValue];
            switch (updateMethod) {
                case 0:
                {
                    self.updateType = NoUpdate;
                }
                    break;
                case 1:
                {
                    self.updateType = MustUpdate;
                    self.updateUrl = dic[@"url"];
                }
                    break;
                case 2:
                {
                    self.updateType = UpdatePrompt;
                    self.updateUrl = dic[@"url"];
                }
                    break;
                default:
                    self.updateType = UnKnownUpadte;
                    break;
            }
        }
        else
        {
            self.updateType = UnKnownUpadte;
        }
        
        [self done];
    } failure:^(__kindof KZBaseRequest *request, NSError *error) {
        self.updateType = UnKnownUpadte;
        [self done];
    }];
}

@end
