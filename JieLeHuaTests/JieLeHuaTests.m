//
//  JieLeHuaTests.m
//  JieLeHuaTests
//
//  Created by YuZhongqi on 16/12/21.
//  Copyright © 2016年 Vcredict. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KZNetworking.h"
@interface JieLeHuaTests : XCTestCase

@end

@implementation JieLeHuaTests

- (void)setUp {
    [super setUp];
    [self testHttp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testHttp
{
    
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
