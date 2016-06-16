//
//  IPQueueDispatcher.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPQueueDispatcher.h"
#import <MagicalRecord/MagicalRecord.h>
#import "IPMessageEntity.h"
#import "IPNetworkLayer.h"

NSString * const IPQueueDispatcherName = @"com.queuedispatcher.ip";

@interface IPQueueDispatcher()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) dispatch_queue_t executionQueue;
@property (nonatomic, strong, readwrite) NSArray *errorCodes;
@end

@implementation IPQueueDispatcher

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                          managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super init];
    if (self) {
        [self setQueue:[[NSOperationQueue alloc] init]];
        [self setExecutionQueue:dispatch_queue_create([IPQueueDispatcherName UTF8String], NULL)];
        [self setErrorCodes:@[@400,@403,@404,@500]];
        [self setManagedObjectContext:context];
        [self setManagedObjectModel:model];
        [self setNetworkLayer:[IPNetworkLayer new]];
    }
    return self;
}

#pragma mark - Helpers

- (NSBundle *)getBundle
{
    if (![self bundle]){
        [self setBundle:[NSBundle bundleForClass:[self class]]];
    }
    return [self bundle];
}

#pragma mark - Execute InQueue

- (void)executeInPrivateQueue:(void (^)(void))block
{
    if (block){
        dispatch_async([self executionQueue], ^{
            block();
        });
    }
}

#pragma mark - Fetch Requests

- (NSFetchRequest *)retrieveFetchRequestWithID:(IPFetchRequests)fetchRequestID
{
    NSFetchRequest *fetchRequest = nil;
    switch (fetchRequestID) {
        case IPFetchRequestHighPriorityMessages:fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"IPFetchRequestHighPriorityMessages"];break;
        case IPFetchRequestLowPriorityMessages:fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"IPFetchRequestLowPriorityMessages"];break;
        case IPFetchRequestGreaterOrEqualThanNormal:fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"IPFetchRequestGreaterOrEqualThanNormal"];break;
        case IPFetchRequestNormalPriorityMessages:fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"IPFetchRequestNormalPriorityMessages"];break;
        default:fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:@"IPFetchRequestCollectValidMessages"];break;
    }
    return fetchRequest;
}

- (NSString *)fetchRequestStringID:(IPFetchRequests)fetchRequestID
{
    NSString *result = @"";
    switch (fetchRequestID) {
        case IPFetchRequestHighPriorityMessages:result = @"IPFetchRequestHighPriorityMessages";break;
        case IPFetchRequestLowPriorityMessages:result = @"IPFetchRequestLowPriorityMessages";break;
        case IPFetchRequestGreaterOrEqualThanNormal:result = @"IPFetchRequestGreaterOrEqualThanNormal";break;
        case IPFetchRequestNormalPriorityMessages:result = @"IPFetchRequestNormalPriorityMessages";break;
        default:result = @"IPFetchRequestCollectValidMessages";break;
    }
    return result;
}

#pragma mark - Collect Messages

- (void)collectMessagesWithFetchRequestID:(IPFetchRequests)fetchRequestID
{
    __weak typeof(self) weakSelf = self;
    [self executeInPrivateQueue:^{
        NSFetchRequest *fetchRequest = [weakSelf retrieveFetchRequestWithID:fetchRequestID];
        NSArray<IPMessageEntity *> *messages = @[];
        if (fetchRequest){
            NSError *error = nil;
            messages = [weakSelf.managedObjectContext executeFetchRequest:fetchRequest
                                                                    error:&error];
            if (error){
                NSLog(@"[E]Error occured while trying to retrieve data for request ID [%@]",[weakSelf fetchRequestStringID:fetchRequestID]);
                messages = @[];
            } else if ([messages count] > 0){
                NSLog(@"[I] %@ messages collected and are preparing for execution",@([messages count]));
                [weakSelf executeMessages:messages];
            } else {
                NSLog(@"[I] No messages found");
            }
        }
    }];
}

- (void)processMessages:(NSArray<IPMessageEntity *> *)messages
{
    for (IPMessageEntity *message in messages){
        
    }
}

#pragma mark - Handle Queue

- (void)executeMessages:(NSArray<IPMessageEntity *> *)messages
{
    
}

#pragma mark - Triggers

- (void)highPriorityMessageAdded
{
    [self collectMessagesWithFetchRequestID:IPFetchRequestHighPriorityMessages];
}

@end