//
//  IPQueueDispatcherBaseTestCase.h
//  IPQueueDispatcher
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//  Copyright © 2016 Ilias Pavlidakis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <IPQueueDispatcher/IPQueueDispatcherHeader.h>

@interface IPQueueDispatcherBaseTestCase : XCTestCase
@property (nonatomic) NSInteger expectationFulFillment;

- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(XCWaitCompletionHandler)handler;

@end