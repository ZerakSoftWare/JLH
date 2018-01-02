//
//  JJAuthenticationModel.h
//  JieLeHua
//
//  Created by YuZhongqi on 17/2/28.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJAuthenticationModel : NSObject




@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * mobileBillId;
@property(nonatomic,strong) NSString * mobileAddress;
@property(nonatomic,strong) NSString * mobile; 
@property(nonatomic,strong) NSString * idcardNo;
@property(nonatomic,strong) NSString * idcardImageReverseBase64;
@property(nonatomic,strong) NSString * idcardImageObverseBase64;
@property(nonatomic,strong) NSString * idcardImageBase64;
@property(nonatomic,strong) NSString * householdAddr;
@property(nonatomic,strong) NSString * faceBase64;
@property(nonatomic,strong) NSString * customerId;
@property(nonatomic,strong) NSString * creditAuthorizationBase64;
@property(nonatomic,strong) NSString * applyId;


//"applyId": 0,
//"creditAuthorizationBase64": "string",
//"customerId": 0,
//"faceBase64": "string",
//"householdAddr": "string",
//"idcardImageBase64": "string",
//"idcardImageObverseBase64": "string",
//"idcardImageReverseBase64": "string",
//"idcardNo": "string",
//"mobile": "string",
//"mobileAddress": "string",
//"mobileBillId": "string",
//"name": "string"


@end
