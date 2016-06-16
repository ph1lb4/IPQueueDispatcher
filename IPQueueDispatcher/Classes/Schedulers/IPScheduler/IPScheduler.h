//
//  IPScheduler.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@class IPQueueDispatcher;

@interface IPScheduler : NSObject

@property (nonatomic, readonly) NSTimeInterval interval;

- (instancetype _Nonnull)initWithInterval:(NSTimeInterval)inteval;

#pragma mark - Execution

- (void)start;

- (void)stop;

@end
