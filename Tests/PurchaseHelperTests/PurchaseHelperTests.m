//
//  PurchaseHelperTests.m
//  PurchaseHelperTests
//
//  Created by Paul Schifferer on 10/31/15.
//  Copyright © 2015 Pilgrimage Software. All rights reserved.
//

#import <XCTest/XCTest.h>
@import PurchaseHelper;


@interface PurchaseHelperTests : XCTestCase {

@private
    PurchaseHelper* _helper;
}

@end

@implementation PurchaseHelperTests

- (void)setUp {
    [super setUp];

    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSSet<NSString*>* productIds = [NSSet setWithObjects:@"product1", @"product2", @"product3", nil];
    NSString* keychainAccount = @"MyIAPs";
    _helper = [[PurchaseHelper alloc] initWithProductIdentifiers:productIds
                                                 keychainAccount:keychainAccount];
    _helper.testMode = YES;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstantiate {
    NSSet<NSString*>* productIds = [NSSet setWithObjects:@"product1", @"product2", @"product3", nil];
    NSString* keychainAccount = @"MyIAPs";
    PurchaseHelper* helper = [[PurchaseHelper alloc] initWithProductIdentifiers:productIds
                                                                keychainAccount:keychainAccount];
    XCTAssertNotNil(helper, @"helper should have initialized");
    XCTAssertTrue(_helper.testMode, @"helper should be in test mode");
}

- (void)testRequestProducts {
    XCTAssertNotNil(_helper, @"helper should have initialized");


    [_helper requestProductsWithCompletionHandler:^(BOOL success, NSArray * _Nonnull products) {

    }];
}

- (void)testTestModePurchase {
    XCTAssertNotNil(_helper, @"helper should have initialized");

    BOOL purchased = [_helper productPurchased:@"whatever"];

    XCTAssertTrue(purchased, @"purchase check should have succeeded.");

}

@end
