//
//  VVFourthElementModel.h
//  O2oApp
//
//  Created by chenlei on 16/10/18.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVFourthElementModel : NSObject

@property(nonatomic,copy) NSString * bankCardType;
@property(nonatomic,copy) NSString * bankCardName;
@property(nonatomic,copy) NSString * bankCardNum;
@property(nonatomic,copy) NSString * bankCardMobile;
@property(nonatomic,copy) NSString * bankCardMobileSMS;
@property(nonatomic,copy) NSString * faceCompareScore;
@property(nonatomic,copy) NSString * bankIDHandImageBase64;
- (instancetype)initWithBankCardType:(NSString *)bankCardType
                        bankCardName:(NSString *)bankCardName
                         bankCardNum:(NSString *)bankCardNum
                        bankCardMobile:(NSString *)bankCardMobile
                        bankCardMobileSMS:(NSString *)bankCardMobileSMS
                        faceCompareScore:(NSString *)faceCompareScore
                        bankIDHandImageBase64:(NSString *)bankIDHandImageBase64;

@end
