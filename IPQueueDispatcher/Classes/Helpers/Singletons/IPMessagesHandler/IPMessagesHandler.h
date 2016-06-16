//
//  IPMessagesHandler.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@class IPQueueDispatcher, IPScheduler, IPMessageJSONEntity;

@interface IPMessagesHandler : NSObject

@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, strong) NSString *baseURL;

+ (IPMessagesHandler*)sharedInstance;

- (void)initialize;

#pragma mark - Scheduler

- (void)setCustomScheduler:(IPScheduler *)scheduler;

#pragma mark - Messages

- (void)addMessages:(NSArray<IPMessageJSONEntity *> *)messages;

@end