//
//  VVUserInfoModel.h
//  O2oApp
//
//  Created by chenlei on 16/4/30.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//


@interface VVModelUSerInfoRole : NSObject
@property (copy,nonatomic) NSString * id;
@property (copy,nonatomic) NSString * name;
@property (copy,nonatomic) NSString * type;

@end

@interface VVModelUSerInfoData : NSObject
@property (copy,nonatomic) NSString * accountId;
@property (copy,nonatomic) NSString * name;
@property (copy,nonatomic) NSString * email;
@property (copy,nonatomic) NSString * mobile;
@property (copy,nonatomic) NSString * headUrl;
@property (copy,nonatomic) NSString * key;
@property (copy,nonatomic) NSString * marketingStatus;
@property (copy,nonatomic) NSString * createTime;

//@property (nonatomic,assign) NSInteger  messageNum;//全局记录消息已经拉取的个数
@property (strong,nonatomic)VVModelUSerInfoRole * role;

@end

@interface VVUserInfoModel : NSObject
@property (copy,nonatomic) NSString * accessToken;
@property (copy,nonatomic) NSString * IM_token;
@property (copy,nonatomic) NSString * tips;

@property (strong,nonatomic)VVModelUSerInfoData * data;


- (id)initWithDisk;
- (void)clear;
- (void)synchronize;



@end


