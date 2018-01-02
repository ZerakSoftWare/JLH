//
//  VVSearchCityModel.h
//  O2oApp
//
//  Created by YuZhongqi on 16/4/30.
//  Copyright © 2016年 YuZhongqi. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface VVSearchCityModel : NSObject
//@property(nonatomic,strong) NSString *saleId;
///**
// *  门店名称
// */
//@property(nonatomic,strong) NSString * storeName;
///**
// *  城市名称
// */
//@property(nonatomic,strong) NSString  *city ;
///**
// *  门店地址
// */
//@property(nonatomic,strong) NSString * address;
///**
// *  
// */
//@property(nonatomic,strong) NSString * fullName;
///**
// *  销售人员手机号
// */
//@property(nonatomic,strong) NSString * mobile;
//
///**
// *  存储销售人员信息的数组
// */
//@property(nonatomic,strong) NSArray * sales;
///**
// *  销售人员姓名
// */
//@property(nonatomic,copy) NSString * saleName;
//
//
//@property(nonatomic,strong) NSString * storeAddress;
///**
// *  销售电话
// */
//@property(nonatomic,strong) NSString * saleMobile;
//@property(nonatomic,strong) NSString * storeId;
////**********************更多网店查询*******************/
/**
 *  门店地址
 */
@property(nonatomic,strong) NSString * store_address;
/**
 *  销售电话
 */
@property(nonatomic,strong) NSString * sale_mobile;
@property(nonatomic,strong) NSString * store_id;
@property(nonatomic,strong) NSString * store_name;

//**********************顾问界面的网点查询所对应的门店地址是否被选中的状态*******************/
@property(nonatomic,assign) BOOL isSelected;


@end



