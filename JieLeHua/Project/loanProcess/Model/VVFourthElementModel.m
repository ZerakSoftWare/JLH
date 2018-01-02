//
//  VVFourthElementModel.m
//  O2oApp
//
//  Created by chenlei on 16/10/18.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVFourthElementModel.h"

@implementation VVFourthElementModel
- (instancetype)initWithBankCardType:(NSString *)bankCardType
                        bankCardName:(NSString *)bankCardName
                         bankCardNum:(NSString *)bankCardNum
                      bankCardMobile:(NSString *)bankCardMobile
                   bankCardMobileSMS:(NSString *)bankCardMobileSMS
                    faceCompareScore:(NSString *)faceCompareScore
               bankIDHandImageBase64:(NSString *)bankIDHandImageBase64{
    self = [super init];
    if (self) {
        _bankCardType = bankCardType;
        _bankCardName = bankCardName;
        _bankCardNum = bankCardNum;
        _bankCardMobile = bankCardMobile;
        _bankIDHandImageBase64 = bankIDHandImageBase64;
        _bankCardMobileSMS = bankCardMobileSMS;
        _faceCompareScore = faceCompareScore;
          }
    return self;
}

@end
