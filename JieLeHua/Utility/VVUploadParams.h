//
//  XXUploadParams.h
//  XXCash
//
//  Created by 胡阳 on 16/3/11.
//  Copyright © 2016年 胡阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVUploadParams : NSObject

@property (nonatomic, copy) NSString *fileName ;
@property (nonatomic, copy) NSString *name ;
@property (nonatomic, copy) NSString *mineType ;
@property (nonatomic, strong) NSData *data ;

@end
