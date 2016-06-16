//
//  IPQueueDispatcherBaseTestCase.m
//  IPQueueDispatcher
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//  Copyright © 2016 Ilias Pavlidakis. All rights reserved.
//

#import "IPQueueDispatcherBaseTestCase.h"

@implementation IPQueueDispatcherBaseTestCase

- (void)setUp {
    [super setUp];
    [self setExpectationFulFillment:20];
    [[IPMessagesHandler sharedInstance] setBaseURL:@"https://httpbin.org/"];
    [[IPMessagesHandler sharedInstance] setInterval:5.0f];
    [[IPMessagesHandler sharedInstance] initialize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kBaseSchedulerStart" object:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(XCWaitCompletionHandler)handler {
    [self waitForExpectationsWithTimeout:[self expectationFulFillment]
                                 handler:handler];
}

- (void)testObjectsCreation {
    XCTAssertNotNil([[IPMessagesHandler sharedInstance] scheduler],@"Scheduler cannot be nil");
    XCTAssertNotNil([[IPMessagesHandler sharedInstance] networkLayer],@"NetworkLayer cannot be nil");
    XCTAssertNotNil([[IPMessagesHandler sharedInstance] backEndLayer],@"BackEndLayer cannot be nil");
    XCTAssertNotNil([[IPMessagesHandler sharedInstance] dispatcher],@"Dispatcher cannot be nil");
    XCTAssertNotNil([[IPMessagesHandler sharedInstance] persistenStoreCoordinator],@"PersistenStoreCoordinator cannot be nil");
    XCTAssertNotNil([[IPMessagesHandler sharedInstance] managedObjectModel],@"ManagedObjectModel cannot be nil");
    XCTAssertNotNil([[IPMessagesHandler sharedInstance] managedObjectContext],@"ManagedObjectContext cannot be nil");
}

- (void)testDelegates {
    XCTAssertEqual([[[IPMessagesHandler sharedInstance] dispatcher] networkLayer], [[IPMessagesHandler sharedInstance] networkLayer], @"Network layer on dispatcher is different that on MessagesHandler");
    XCTAssertEqual([[[[IPMessagesHandler sharedInstance] dispatcher] networkLayer] delegate], [[IPMessagesHandler sharedInstance] dispatcher], @"Network layer delegate is not dispatcher");
    XCTAssertEqual([[[IPMessagesHandler sharedInstance] dispatcher] backEndLayer], [[IPMessagesHandler sharedInstance] backEndLayer], @"BackEndLayer layer on dispatcher is different that on MessagesHandler");
}

@end
