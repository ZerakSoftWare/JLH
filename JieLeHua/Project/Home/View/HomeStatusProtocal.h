//
//  HomeStatusProtocal.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/7.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#ifndef HomeStatusProtocal_h
#define HomeStatusProtocal_h


#endif /* HomeStatusProtocal_h */

@protocol HomeStatusProtocal <NSObject>
- (void)clickBtnWithStatus:(HomeStatus)status;
@optional
- (void)startApplyWithStatus:(ApplySource)source;
- (void)presentIncrease;
@end
