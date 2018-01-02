//
//  VVCreditBaseInfoModel.h
//  O2oApp
//
//  Created by chenlei on 16/4/25.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//


@interface VVCreditBaseInfoModel : NSObject

@property (copy,nonatomic) NSString * custName;//姓名
@property (copy,nonatomic) NSString * idcard;

@property (copy,nonatomic) NSString * salary;// 工资
@property (copy,nonatomic) NSString * revenueType;// 打款方式
@property(nonatomic,copy)NSString * aftertaxSalary;//打卡工资
@property(nonatomic,copy)NSString * cashSalary;//现金工资

@property (copy,nonatomic) NSString * socialMonth;//社保
@property (copy,nonatomic) NSString * accumulationFundMonth;//公积金
@property (copy,nonatomic) NSString * socialBase;//公积金基数
@property (copy,nonatomic) NSString * city;
@property (copy,nonatomic) NSString * houseHold; //是否本地
@property (copy,nonatomic) NSString * storeId;//门店
@property (copy,nonatomic) NSString * storeName;//门店名字

@property (copy,nonatomic) NSString * idcardImageObverse;//正面
@property (copy,nonatomic) NSString * idcardImageReverse;//反面
@property (nonatomic, copy) NSString *idcardImageHand;//手持身份证

@property (copy,nonatomic) NSString * verificationDataFull;//活体

@property (copy,nonatomic) NSString * industryType;//行业
@property (copy,nonatomic) NSString * localMortgage;//按揭住房
@property (copy,nonatomic) NSString * jobType;//行业


//上传服务器的
@property (copy,nonatomic) NSString * education;//学历
@property(nonatomic,strong) NSString * industry;
@property(nonatomic,strong) NSString * liveCity;
@property(nonatomic,strong) NSString * liveCityName;
@property (copy,nonatomic) NSString * marriage;//婚姻
@property(nonatomic,strong) NSString *monthCardSalary;
@property(nonatomic,strong) NSString *monthCashSalary;
@property(nonatomic,assign) NSInteger payFundSocial;
@property(nonatomic,strong) NSString *profession;
@property(nonatomic,strong) NSString *loansUse;

//基本嘻嘻 (申请按钮返回)
@property(nonatomic,strong) NSString *educationCode;
@property(nonatomic,strong) NSString *marriageCode;
@property(nonatomic,strong) NSString * industryCode;
@property(nonatomic,strong) NSString *professionCode;
//@property(nonatomic,strong) NSString *monthCardSalary;
//@property(nonatomic,strong) NSString *monthCashSalary;
@property(nonatomic,assign) NSInteger isPayFundSocial;
//@property(nonatomic,strong) NSString * liveCityName;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *loanUseCode;


//accumulationFundMonth = 6;
//applyMoney = 12345;
//applyTime = "2016-05-06 06:45:45";
//city = "\U82cf\U5dde";
//createTime = "2016-05-06 06:45:45";
//custName = "\U9648\U78ca";
//customer =         {
//    customerId = 18210008037;
//};
//education = "NEWEDUCATION/ZZ";
//houseHold = "HOUSEHOLD/FEIBENDIJI";
//idcard = 342222198510196417;
//marriage = "NEWMARRIAGE/YH";
//modifyTime = "2016-05-06 06:45:45";
//orderId = 54;
//orderNum = "18210008037-1462517145001";
//orderStatus = 1;
//salary = 234;
//social = 0;
//socialBase = 234;
//socialMonth = 3;


@end
