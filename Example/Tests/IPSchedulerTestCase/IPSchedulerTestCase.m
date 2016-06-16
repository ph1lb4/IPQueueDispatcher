//
//  IPSchedulerTestCase.m
//  IPQueueDispatcher
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//  Copyright © 2016 Ilias Pavlidakis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IPQueueDispatcherBaseTestCase.h"

@interface IPTestScheduler : IPScheduler

@end

@implementation IPTestScheduler

- (void)prepareMessages
{
    IPMessageJSONEntity *message1 = [IPMessageJSONEntity new];
    [message1 setPath:@"/ip"];
    [message1 addHeaderForKey:@"testHeader" value:@"testHeaderValue" ommitEmptyValue:YES];
    [message1 addPropertyForKey:@"testProperty" value:@"testPropertyValue"];
    [message1 setJSONtoJSONSerializers];
    [message1 addNotificationAction:@"kIPTestNotificationSchedulerActionFinished" includeRawResponse:YES];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [self addScheduledMessage:message1];
    [super prepareMessages];
}

@end

@interface IPSchedulerTestCase : IPQueueDispatcherBaseTestCase
@property (nonatomic) NSInteger executionsCount;
@property (nonatomic) NSInteger expectedExecutionsCount;
@property (nonatomic) XCTestExpectation *expectation;
@end

@implementation IPSchedulerTestCase

- (void)setUp {
    [[IPMessagesHandler sharedInstance] setCustomScheduler:[[IPTestScheduler alloc] initWithInterval:5.0f]];
    [super setUp];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schedulerWillRun:)
                                                 name:@"kIPSchedulerWillRun"
                                               object:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSchedule {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schedulerWillRun:)
                                                 name:@"kIPSchedulerWillRun"
                                               object:nil];
    self.expectedExecutionsCount = 2;
    [self setExpectationFulFillment:([[IPMessagesHandler sharedInstance] interval] * self.expectedExecutionsCount)];
    self.expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Scheduler was executed %@ times in %@ seconds",
                                                         @([self expectationFulFillment]),
                                                         @([[IPMessagesHandler sharedInstance] interval])]];
    [self waitForExpectationsWithCommonTimeoutUsingHandler:nil];
}

- (void)testSchedulerAddMesages
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schedulerWillAddMessages:)
                                                 name:@"kIPSchedulerWillRun"
                                               object:nil];
    self.expectedExecutionsCount = 200;
    [self setExpectationFulFillment:([[IPMessagesHandler sharedInstance] interval] * self.expectedExecutionsCount * 1000)];
    self.expectation = [self expectationWithDescription:@"Scheduler has 2 messages to be added"];
    [self waitForExpectationsWithCommonTimeoutUsingHandler:nil];
}

#pragma mark -

- (void)schedulerWillRun:(NSNotification *)notification
{
    self.executionsCount += 100;
    if (self.executionsCount == self.expectedExecutionsCount){
        [self.expectation fulfill];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)schedulerWillAddMessages:(NSNotification *)notification
{
    if ([[[[IPMessagesHandler sharedInstance] scheduler] performSelector:@selector(scheduledMessages)] count] == 2){
        [self.expectation fulfill];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


@end
