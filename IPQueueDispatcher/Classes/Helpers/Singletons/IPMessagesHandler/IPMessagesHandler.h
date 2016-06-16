//
//  IPMessagesHandler.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@class IPQueueDispatcher, IPScheduler, IPMessageJSONEntity, IPNetworkLayer, IPBackEndLayer;

@interface IPMessagesHandler : NSObject

@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistenStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) IPQueueDispatcher *dispatcher;
@property (nonatomic, strong, readonly) IPScheduler *scheduler;
@property (nonatomic, strong, readonly) IPNetworkLayer *networkLayer;
@property (nonatomic, strong, readonly) IPBackEndLayer *backEndLayer;

+ (IPMessagesHandler*)sharedInstance;

- (void)initialize;

#pragma mark - Scheduler

- (void)setCustomScheduler:(IPScheduler *)scheduler;

#pragma mark - Network Layer

- (void)setCustomNetworkLayer:(IPNetworkLayer *)networkLayer;

#pragma mark - BackEnd Layer

- (void)setCustomBackEndLayer:(IPBackEndLayer *)backEndLayer;

#pragma mark - Messages

- (void)addMessages:(NSArray<IPMessageJSONEntity *> *)messages;

@end