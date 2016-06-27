//
//  IPScheduler.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPScheduler.h"
#import "IPMessagesHandler.h"
#import "IPMessageJSONEntity.h"

@interface IPScheduler()
@property (nonatomic, readwrite) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray<IPMessageJSONEntity *> *scheduledMessages;
@end

@implementation IPScheduler

- (instancetype)initWithInterval:(NSTimeInterval)inteval
{
    if (self = [super init])
    {
        [self setInterval:inteval];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startExecution:)
                                                     name:@"kBaseSchedulerStart"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopExecution:)
                                                     name:@"kBaseSchedulerStop"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(forceRun:)
                                                     name:@"kIOForceSchedulerRun"
                                                   object:nil];
    }
    return self;
}

#pragma mark - Execution

- (void)start
{
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:[self interval]
                                                    target:self
                                                  selector:@selector(scheduledExecution:)
                                                  userInfo:nil
                                                   repeats:YES]];
}

- (void)stop
{
    [self.timer invalidate];
    [self setTimer:nil];
}

#pragma mark - Timer Tick

- (void)scheduledExecution:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kIPSchedulerWillRun"
                                                        object:nil];
    [self prepareMessages];
    if ([self scheduledMessages]){
        [[IPMessagesHandler sharedInstance] addMessages:[self scheduledMessages]];
        [self setScheduledMessages:[NSMutableArray new]];
    }
}

#pragma mark - Add Scheduled Messages

- (void)addScheduledMessage:(IPMessageJSONEntity *)message
{
    if (!message) return;
    if (![self scheduledMessages]) {
        [self setScheduledMessages:[NSMutableArray new]];
    }
    [self.scheduledMessages addObject:message];
}

- (void)prepareMessages
{
    NSLog(@"[I]IPScheduler::prepareMessage not implemented.");
}

#pragma mark - NSNotifications

- (void)forceRun:(NSNotification *)notification
{
    NSLog(@"[I]IPScheduler forced to run!");
    [self scheduledExecution:[self timer]];
}

- (void)startExecution:(NSNotification *)notification
{
    [self start];
    NSLog(@"[I]IPScheduler started!");
}

- (void)stopExecution:(NSNotification *)notification
{
    [self stop];
    NSLog(@"[I]IPScheduler stopped!");
}

@end