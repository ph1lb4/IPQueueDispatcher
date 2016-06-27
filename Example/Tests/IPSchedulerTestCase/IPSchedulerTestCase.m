//
//  IPSchedulerTestCase.m
//  IPQueueDispatcher
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//  Copyright © 2016 Ilias Pavlidakis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IPQueueDispatcherBaseTestCase.h"
#import "IPMessagesHandler.h"

@interface IPTestScheduler : IPScheduler
@property (nonatomic) NSInteger messagesToCreatePerCycle;
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
    for (NSInteger i=0 ; i < [self messagesToCreatePerCycle] ; i++){
        [self addScheduledMessage:message1];
    }
    [super prepareMessages];
}

@end

@interface IPSchedulerTestCase : IPQueueDispatcherBaseTestCase
@property (nonatomic) NSInteger executionsCount;
@property (nonatomic) NSInteger expectedExecutionsCount;
@property (nonatomic) NSInteger messagesToCreatePerCycle;
@property (nonatomic) XCTestExpectation *expectation;
@end

@implementation IPSchedulerTestCase

- (void)setUp {
    [self setMessagesToCreatePerCycle:20];
    self.expectedExecutionsCount = 5;
    IPTestScheduler *scheduler = [[IPTestScheduler alloc] initWithInterval:5.0f];
    [scheduler setMessagesToCreatePerCycle:[self messagesToCreatePerCycle]];
    [[IPMessagesHandler sharedInstance] setCustomScheduler:scheduler];
    [super setUp];
}

- (void)tearDown {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[IPMessagesHandler sharedInstance] dataLayer] performDeleteRequest:@"IPMessageEntity"
                                                               predicate:nil
                                                                 context:[[IPMessagesHandler sharedInstance] managedObjectContext]];
    [super tearDown];
}

- (void)testSchedule {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schedulerWillRun:)
                                                 name:@"kIPSchedulerWillRun"
                                               object:nil];
    [self setExpectationFulFillment:([[IPMessagesHandler sharedInstance] interval] * self.expectedExecutionsCount)];
    self.expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Scheduler was executed %@ times in %@ seconds",
                                                         @([self expectationFulFillment]),
                                                         @([[IPMessagesHandler sharedInstance] interval])]];
    [self waitForExpectationsWithCommonTimeoutUsingHandler:nil];
}

- (void)testSchedulerAddAHundredMesages
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messagesWhereAdded:)
                                                 name:IPMessagesHandlerAddMessagesCompleted
                                               object:nil];
    [self setExpectationFulFillment:([[IPMessagesHandler sharedInstance] interval] * self.expectedExecutionsCount + 5)];
    self.expectation = [self expectationWithDescription:@"testSchedulerAddAHundredMesages was successful"];
    self.executionsCount = 0;
    [self waitForExpectationsWithCommonTimeoutUsingHandler:nil];
}

#pragma mark -

- (void)schedulerWillRun:(NSNotification *)notification
{
    self.executionsCount += 1;
    if (self.executionsCount == self.expectedExecutionsCount){
        [self.expectation fulfill];
    }
}

- (void)messagesWhereAdded:(NSNotification *)notification
{
    self.executionsCount += 1;
    NSInteger messagesCount = [[IPMessagesHandler sharedInstance] numberOfScheduledMessagesInStore];
    NSInteger expectedMessagesCount = self.executionsCount * self.messagesToCreatePerCycle;
    XCTAssertTrue(messagesCount==expectedMessagesCount,@"The number of scheduled messaged in store is not consistent [Expected:%@],[Found:%@]",
                  @(expectedMessagesCount),
                  @(messagesCount));
    if (self.executionsCount == self.expectedExecutionsCount){
        [self.expectation fulfill];
    }
}

@end
