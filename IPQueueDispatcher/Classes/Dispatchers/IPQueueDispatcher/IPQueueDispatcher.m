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
#import "IPMessageJSONEntity.h"
#import "IPMessageCompletionDelegateActionJSONEntity.h"
#import "IPMessageCompletionNotificationJSONAction.h"
#import "NSDictionary+IPQueueDispatcher.h"
#import "NSString+IPQueueDispatcher.h"
#import "IPBackEndLayer.h"

NSString * const IPQueueDispatcherName = @"com.queuedispatcher.ip";
NSString * const IPQueueDispatcherDelegateResultMessageKey = @"IPQueueDispatcherDelegateResultMessageKey";
NSString * const IPQueueDispatcherDelegateResultFormattedResponseKey = @"IPQueueDispatcherDelegateResultFormattedResponseKey";
NSString * const IPQueueDispatcherDelegateResultRawResponseKey = @"IPQueueDispatcherDelegateResultRawResponseKey";
NSString * const IPQueueDispatcherDelegateResultErrorKey = @"IPQueueDispatcherDelegateResultErrorKey";

@interface IPQueueDispatcher()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSBundle *bundle;
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

- (void)executeDelegateActions:(IPMessageJSONEntity *)message
       formattedResponseObject:(id)formattedResponseObject
                responseObject:(id)responseObject
                         error:(NSError *)error
             notificationTypes:(NSArray<NSNumber *> *)notificationTypes
{
    @try {
        if ([self backEndLayer] && [[message delegateActions] count] > 0){
            NSArray<IPMessageCompletionDelegateActionJSONEntity *> *actions = [[message notificationActions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.completionActionType IN %@",notificationTypes]];
            
            for (IPMessageCompletionDelegateActionJSONEntity *action in actions){
                SEL selector = NSSelectorFromString([action selector]);
                
                NSDictionary *result = @{IPQueueDispatcherDelegateResultMessageKey:message?:[NSNull null]};
                if (error){
                    result = [result addObject:error?:[NSNull null]
                                        forKey:IPQueueDispatcherDelegateResultErrorKey];
                } else {
                    result = [result addObject:formattedResponseObject?:[NSNull null]
                                        forKey:IPQueueDispatcherDelegateResultFormattedResponseKey];
                    if ([action includeRawResponse]){
                        result = [result addObject:responseObject?:[NSNull null]
                                            forKey:IPQueueDispatcherDelegateResultRawResponseKey];
                    }
                }
                
                if ([[self backEndLayer] respondsToSelector:selector]){
                    [self.backEndLayer performSelector:selector
                                            withObject:result];
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"[E]Exception while executing delegate action. %@",exception);
    }
}

- (void)executeNotificationActions:(IPMessageJSONEntity *)message
           formattedResponseObject:(id)formattedResponseObject
                    responseObject:(id)responseObject
                             error:(NSError *)error
                 notificationTypes:(NSArray<NSNumber *> *)notificationTypes
{
    @try {
        if ([[message notificationActions] count] > 0){
            NSArray<IPMessageCompletionNotificationJSONAction *> *actions = [[message notificationActions] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.completionActionType IN %@",notificationTypes]];
            
            for (IPMessageCompletionNotificationJSONAction *action in [message notificationActions]){
                if ([NSString isNotEmpty:[action notificationName]]){
                    NSDictionary *result = @{IPQueueDispatcherDelegateResultMessageKey:message?:[NSNull null]};
                    
                    if (error){
                        result = [result addObject:error?:[NSNull null]
                                            forKey:IPQueueDispatcherDelegateResultErrorKey];
                    } else {
                        result = [result addObject:formattedResponseObject?:[NSNull null]
                                            forKey:IPQueueDispatcherDelegateResultFormattedResponseKey];
                        if ([action includeRawResponse]){
                            result = [result addObject:responseObject?:[NSNull null]
                                                forKey:IPQueueDispatcherDelegateResultRawResponseKey];
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:[action notificationName]
                                                                        object:result];
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"[E]Exception while executing notification action. %@",exception);
    }
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

#pragma mark - IPNetworkLayerProtocol
#pragma mark - Response Results
- (void)successfulOperation:(IPMessageJSONEntity *)message
    formattedResponseObject:(id)formattedResponseObject
             responseObject:(id)responseObject
{
    if (message){
        [self executeDelegateActions:message
             formattedResponseObject:formattedResponseObject
                      responseObject:responseObject
                               error:nil
                   notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeSuccess)]];
        
        [self executeNotificationActions:message
                 formattedResponseObject:formattedResponseObject
                          responseObject:responseObject
                                   error:nil
                       notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeSuccess)]];
    }
}

- (void)failedOperation:(IPMessageJSONEntity *)message
                  error:(NSError *)error
{
    if (message){
        [self executeDelegateActions:message
             formattedResponseObject:nil
                      responseObject:nil
                               error:error
                   notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeFailure)]];
        
        [self executeNotificationActions:message
                 formattedResponseObject:nil
                          responseObject:nil
                                   error:error
                       notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeFailure)]];
    }
}

- (void)noInternetOperation:(IPMessageJSONEntity *)message
{
    if (message){
        [self executeDelegateActions:message
             formattedResponseObject:nil
                      responseObject:nil
                               error:nil
                   notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeNoConnection)]];
        
        [self executeNotificationActions:message
                 formattedResponseObject:nil
                          responseObject:nil
                                   error:nil
                       notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeNoConnection)]];
    }
}

#pragma mark - Authentication

- (void)authenticationDataForRequestSerializer:(AFHTTPRequestSerializer *)serializer
                                          path:(NSString *)path
{
    if ([self backEndLayer] && [self.backEndLayer respondsToSelector:@selector(authenticationDataForRequestSerializer:path:)]){
        [self.backEndLayer authenticationDataForRequestSerializer:serializer
                                                             path:path];
    }
}

#pragma mark - Re Authentication

- (IPMessageJSONEntity *)reAuthenticate
{
    if ([self backEndLayer] && [self.backEndLayer respondsToSelector:@selector(reAuthenticate)]){
        return [self.backEndLayer reAuthenticate];
    } else {
        return nil;
    }
}

- (void)successfulReAuthenticationOperation:(IPMessageJSONEntity *)message
                    formattedResponseObject:(id)formattedResponseObject
                             responseObject:(id)responseObject
{
    if (message){
        [self executeDelegateActions:message
             formattedResponseObject:formattedResponseObject
                      responseObject:responseObject
                               error:nil
                   notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeSuccess)]];
        
        [self executeNotificationActions:message
                 formattedResponseObject:formattedResponseObject
                          responseObject:responseObject
                                   error:nil
                       notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeSuccess)]];
    }
}

- (void)failedReAuthenticationOperation:(IPMessageJSONEntity *)message
                                  error:(NSError *)error
{
    if (message){
        [self executeDelegateActions:message
             formattedResponseObject:nil
                      responseObject:nil
                               error:error
                   notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeFailure)]];
        
        [self executeNotificationActions:message
                 formattedResponseObject:nil
                          responseObject:nil
                                   error:error
                       notificationTypes:@[@(IPMessageCompetionActionTypeAll),@(IPMessageCompetionActionTypeFailure)]];
    }
}

@end