//
//  VVBasePreviewView.m
//  O2oApp
//
//  Created by chenlei on 16/11/3.
//  Copyright © 2016年  Vcredit.com. All rights reserved.
//

#import "VVBasePreviewView.h"
#import "VVBasicDataModel.h"
#define kHorizenInset (([UIScreen mainScreen].bounds.size.width - 270)/2)

@implementation VVBasePreviewView

#pragma  mark 基本信息预览
+ (UIView *)basePreview:(VVCreditBaseInfoModel *)modelInfo{
    __block NSString *gongjijin =@"";
    __block NSString *education =@"";
    __block NSString *marriage =@"";
    __block NSString *profession = @"";

    
//    NSDictionary *educationDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
//    NSArray *educationArr = educationDic[@"education"];
//    [educationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
//        if ([basicModel.dicCode isEqualToString:modelInfo.education]) {
//            education  = basicModel.dicName;
//            educationValue = basicModel.seq;
//            *stop = YES;
//        }else if ([basicModel.dicName isEqualToString:modelInfo.education]){
//            educationValue = basicModel.seq;
//            *stop = YES;
//        }
//    }];
//
//    NSDictionary *marriageDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
//    NSArray *marriageArr = marriageDic[@"marriage"];
//    [marriageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
//        if ([basicModel.dicCode isEqualToString: modelInfo.marriage]) {
//            marriage  = basicModel.dicName;
//            *stop = YES;
//        }
//    }];
    
    
    NSDictionary *educationDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    NSArray *educationArr = educationDic[@"education"];
    
    [educationArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
        if ([basicModel.dicCode isEqualToString: modelInfo.educationCode]) {
            education  = basicModel.dicName;
            *stop = YES;
        }
    }];
    
    
    NSDictionary *marriageDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    NSArray *marriageArr = marriageDic[@"marriage"];
    [marriageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
        if ([basicModel.dicCode isEqualToString: modelInfo.marriageCode]) {
           marriage  = basicModel.dicName;
            *stop = YES;
        }
    }];
    
    NSDictionary *professionDic = [NSDictionary dictionaryWithContentsOfFile:[VVPathUtils basicPlistPath]];
    NSArray *professionArr = professionDic[@"customerType"];
    [professionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VVBasicDataModel* basicModel = [VVBasicDataModel mj_objectWithKeyValues:obj ];
        if ([basicModel.dicCode isEqualToString: modelInfo.professionCode]) {
            profession  = basicModel.dicName;
            *stop = YES;
        }
    }];

    NSArray * arr = @[@{@"title":@"教育程度",
                        @"value":VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.education)?@"hidden": VV_SHDAT.creditBaseInfoModel.education,
                        @"textColor":VV_COL_RGB(0x666666)},
                      @{ @"title":@"婚姻状况",
                         @"value":VV_IS_NIL( VV_SHDAT.creditBaseInfoModel.marriage)?@"hidden": VV_SHDAT.creditBaseInfoModel.marriage,
                         @"textColor":VV_COL_RGB(0x666666)},
                      @{@"title":@"所属行业",
                        @"value":VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.industry)?@"hidden":VV_SHDAT.creditBaseInfoModel.industry,
                        @"textColor":VV_COL_RGB(0x666666)},
                      @{@"title":@"职业",
                        @"value":VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.profession)?@"hidden":VV_SHDAT.creditBaseInfoModel.profession,
                        @"textColor":VV_COL_RGB(0x666666)},
                      @{@"title":@"月收入(打卡)",
                        @"value": [VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.monthCardSalary)?@"hidden":VV_SHDAT.creditBaseInfoModel.monthCardSalary stringByAppendingString: @"元" ],
                        @"textColor":[VV_SHDAT.creditBaseInfoModel.monthCashSalary intValue]<1000?VV_COL_RGB(0x666666):VV_COL_RGB(0x666666)},
                      @{@"title":@"月收入(现金)",
                        @"value": [VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.monthCashSalary)?@"hidden":VV_SHDAT.creditBaseInfoModel.monthCashSalary stringByAppendingString: @"元" ],
                        @"textColor":[modelInfo.monthCashSalary intValue]<1000?VV_COL_RGB(0x666666):VV_COL_RGB(0x666666)},
                      @{@"title":@"缴纳公积金或社保",
                        @"value": VV_SHDAT.creditBaseInfoModel.isPayFundSocial ==0?@"未缴纳":@"已缴纳",
                        @"textColor":VV_SHDAT.creditBaseInfoModel.isPayFundSocial ==0?[UIColor globalThemeColor]:VV_COL_RGB(0x666666)},
                      @{@"title":@"贷款用途",
                        @"value":VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.loansUse)?@"hidden":VV_SHDAT.creditBaseInfoModel.loansUse,
                        @"textColor":VV_COL_RGB(0x666666)},
                      @{@"title":@"所在城市",
                        @"value":VV_IS_NIL(VV_SHDAT.creditBaseInfoModel.liveCityName)?@"hidden":VV_SHDAT.creditBaseInfoModel.liveCityName,
                        @"textColor":VV_COL_RGB(0x666666)}
                      ];
    

    UIView *preview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-kHorizenInset*2, 100)];
    
    __block CGFloat height = 0;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(15, height, (kScreenWidth-kHorizenInset*2), 26)];
        leftLable.text = [dic objectForKey:@"title"];
        leftLable.textAlignment = NSTextAlignmentLeft;
        leftLable.textColor = VV_COL_RGB(0x999999);
        leftLable.font = [UIFont systemFontOfSize:15];
        CGSize textSize = [leftLable.text sizeWithFont:[UIFont systemFontOfSize:15]];
        [preview addSubview:leftLable];
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(textSize.width+10+15, height, (kScreenWidth-kHorizenInset*2)-textSize.width-25-15, leftLable.height)];
        rightLable.text = [dic objectForKey:@"value"];
        if ([[dic objectForKey:@"value"] hasPrefix:@"hidden"]) {
            rightLable.text =@"";
            rightLable.frame = CGRectMake(leftLable.right+15, height, (kScreenWidth-kHorizenInset*2)/2-20, 0);
            rightLable.hidden = YES;
            
            leftLable.text = @"";
            leftLable.frame = CGRectMake(20, height, (kScreenWidth-kHorizenInset*2)/2, 0);
            leftLable.hidden = YES;
            
        }
        rightLable.textAlignment = NSTextAlignmentRight;
        rightLable.textColor = [dic objectForKey:@"textColor"];
        rightLable.font = [UIFont systemFontOfSize:15];
        [preview addSubview:rightLable];
        height +=rightLable.height;
        
    }];
    preview.frame =  CGRectMake(0, 0, kScreenWidth-kHorizenInset*2, height);
    return preview;
}

@end
