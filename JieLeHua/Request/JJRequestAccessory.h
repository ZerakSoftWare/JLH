//
//  JJRequestAccessory.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/9.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJRequestAccessory : NSObject<KZRequestAccessory>
- (instancetype) initWithShowVC:(UIViewController *)vc;
- (instancetype) initWithShowView:(UIView *)view;
- (void)changeHudText:(NSString *)string;

@end
