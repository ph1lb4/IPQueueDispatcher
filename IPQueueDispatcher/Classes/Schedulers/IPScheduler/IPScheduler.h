//
//  IPScheduler.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@class IPQueueDispatcher, IPMessageJSONEntity;

@interface IPScheduler : NSObject

@property (nonatomic, readonly) NSTimeInterval interval;

- (instancetype _Nonnull)initWithInterval:(NSTimeInterval)inteval;

#pragma mark - Execution

- (void)start;

- (void)stop;

#pragma mark - Timer Tick

- (void)scheduledExecution:(NSTimer *_Nonnull)timer;

#pragma mark - Add Scheduled Messages

- (void)addScheduledMessage:(IPMessageJSONEntity *_Nonnull)message;

- (void)prepareMessages;

@end
