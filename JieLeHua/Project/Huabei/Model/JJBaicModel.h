//
//  JJBaicModel.h
//  JieLeHua
//
//  Created by pingyandong on 2017/3/6.
//  Copyright © 2017年 Vcredict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJBaicResultModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *AccountName;
@property (nonatomic, copy) NSString *RealName;
@property (nonatomic, copy) NSString *isRealName;
@property (nonatomic, copy) NSString *DocumentType;
@property (nonatomic, copy) NSString *DocumentNo;
@property (nonatomic, copy) NSString *DocumentTime;
@property (nonatomic, copy) NSString *ValidityTime;
@property (nonatomic, copy) NSString *Email;
@property (nonatomic, copy) NSString *Mobile;
@property (nonatomic, copy) NSString *TaoBao;
@property (nonatomic, copy) NSString *RegTime;
@property (nonatomic, assign) NSInteger BankCount;
@property (nonatomic, assign) NSInteger AddressCount;
@property (nonatomic, copy) NSString *MemberGuarantee;
@property (nonatomic, assign) float AccountBalance;
@property (nonatomic, assign) float YuEbao;
@property (nonatomic, assign) float JiFenBao;
@property (nonatomic, assign) float ZhaoCaiBao;
@property (nonatomic, assign) float CunJinBao;
@property (nonatomic, assign) float JiJin;
@property (nonatomic, assign) float TaoLiCai;
@property (nonatomic, assign) float FlowersBalance;
@property (nonatomic, assign) float FlowerAvailable;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *BusIdentityCard;
@property (nonatomic, copy) NSString *BusName;
@property (nonatomic, copy) NSString *BusId;
@property (nonatomic, copy) NSString *BusType;
@property (nonatomic, copy) NSString *Token;
@property (nonatomic, copy) NSString *UserID;

@end

@interface JJBaicModel : NSObject
@property (nonatomic, assign) NSInteger CrawlStatus;
@property (nonatomic, copy) NSString *EndTime;
@property (nonatomic, strong)JJBaicResultModel *Result;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, assign) NSInteger StatusCode;
@property (nonatomic, copy) NSString *StatusDescription;
@property (nonatomic, copy) NSString *Token;
@property (nonatomic, assign) NSInteger nextProCode;

@end
