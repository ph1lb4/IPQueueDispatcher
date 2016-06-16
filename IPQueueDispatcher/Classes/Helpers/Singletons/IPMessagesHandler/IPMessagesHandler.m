//
//  IPMessagesHandler.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessagesHandler.h"
#import <MagicalRecord/MagicalRecord.h>
#import "IPQueueDispatcher.h"
#import "IPScheduler.h"
#import "NSObject+IPQueueDispatcher.h"
#pragma mark - JSON Entities
#import "IPMessageJSONEntity.h"
#import "IPMessageURLJSONEntity.h"
#import "IPMessageHeaderJSONEntity.h"
#import "IPMessagePropertyJSONEntity.h"
#import "IPMessageSerializerJSONEntity.h"
#import "IPMessageCompletionDelegateActionJSONEntity.h"
#import "IPMessageCompletionNotificationJSONAction.h"
#pragma mark - CoreData Entities
#import "IPMessageEntity.h"
#import "IPMessageURLEntity.h"
#import "IPMessageHeaderEntity.h"
#import "IPMessagePropertyEntity.h"
#import "IPMessageSerializerEntity.h"
#import "IPMessageCompletionDelegateAction.h"
#import "IPMessageCompletionNotificationAction.h"

NSString * const IPQueueDispatcherBundleIdentifier = @"com.cocoapods.IPQueueDispatcher";
NSString * const IPQueueDispatcherStore = @"IPQueueDispatcher.sqlite";
NSString * const IPQueueDispatcherModel = @"IPQueueDispatcherModel";
NSString * const IPQueueDispatcherModelExtension = @"momd";

@interface IPMessagesHandler()
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistenStoreCoordinator;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) IPQueueDispatcher *dispatcher;
@property (nonatomic, strong, readwrite) IPScheduler *scheduler;
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation IPMessagesHandler

static IPMessagesHandler *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
    });
    
    return SINGLETON;
}

- (id)init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    if (self = [super init]){
        [self initializeCoreData];
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

#pragma mark - Configure Core Data

- (void)initializeCoreData
{
    NSURL *modelURL = [[self getBundle] URLForResource:IPQueueDispatcherModel
                                         withExtension:IPQueueDispatcherModelExtension];
    [self setManagedObjectModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]];
    NSAssert([self managedObjectModel]!=nil, @"Managed object model didn't created");
    [self setPersistenStoreCoordinator:[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]]];
    NSAssert([self persistenStoreCoordinator]!=nil, @"PersistentStore Coordinator didn't created");
    [self setManagedObjectContext:[NSManagedObjectContext MR_contextWithStoreCoordinator:[self persistenStoreCoordinator]]];
    NSAssert([self managedObjectContext]!=nil, @"Managed Object Context didn't created");
    [self.persistenStoreCoordinator MR_addAutoMigratingSqliteStoreNamed:IPQueueDispatcherStore];
    NSLog(@"[I]%@ URL [%@]",IPQueueDispatcherStore,[[[[self.persistenStoreCoordinator URLForPersistentStore:[[self.persistenStoreCoordinator persistentStores] firstObject]] absoluteString] stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"file://" withString:@""]);
}

- (void)initialize
{
    if (![self scheduler]){
        [self setScheduler:[[IPScheduler alloc] initWithInterval:[self interval]]];
    }
    [self setDispatcher:[[IPQueueDispatcher alloc] initWithManagedObjectContext:[NSManagedObjectContext MR_contextWithParent:[self managedObjectContext]]
                                                             managedObjectModel:[self managedObjectModel]]];
}

#pragma mark - Scheduler

- (void)setCustomScheduler:(IPScheduler *)scheduler
{
    [self setScheduler:scheduler];
}

#pragma mark - Messages

- (void)addMessages:(NSArray<IPMessageJSONEntity *> *)messages
{
    __weak typeof(self) weakSelf = self;
    __block BOOL containsHighPriorityMessage = NO;
    [self.managedObjectContext MR_saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (IPMessageJSONEntity *message in messages){
            if (!containsHighPriorityMessage && [[message priority] integerValue] == IPMessagePriorityHigh){
                containsHighPriorityMessage = YES;
            }
            IPMessageEntity *messageEntity = [IPMessageEntity MR_createEntityInContext:localContext];
            [messageEntity setPropertiesFromDictionary:[message toDictionary]];
            if ([message url]){
                IPMessageURLEntity *urlEntity = [IPMessageURLEntity MR_createEntityInContext:localContext];
                [urlEntity setPropertiesFromDictionary:[message.url toDictionary]];
                [messageEntity setUrl:urlEntity];
            }
            if ([message serializer]){
                IPMessageSerializerEntity *serializerEntity = [IPMessageSerializerEntity MR_createEntityInContext:localContext];
                [serializerEntity setPropertiesFromDictionary:[message.serializer toDictionary]];
                [messageEntity setSerializers:serializerEntity];
            }
            if ([message headers]){
                for (IPMessageHeaderJSONEntity *header in [message headers]){
                    IPMessageHeaderEntity *headerEntity = [IPMessageHeaderEntity MR_createEntityInContext:localContext];
                    [headerEntity setPropertiesFromDictionary:[header toDictionary]];
                    [messageEntity addHeadersObject:headerEntity];
                }
            }
            if ([message properties]){
                for (IPMessageHeaderJSONEntity *property in [message properties]){
                    IPMessagePropertyEntity *propertyEntity = [IPMessagePropertyEntity MR_createEntityInContext:localContext];
                    [propertyEntity setPropertiesFromDictionary:[property toDictionary]];
                    [messageEntity addPropertiesObject:propertyEntity];
                }
            }
            if ([message delegateActions]){
                for (IPMessageCompletionDelegateActionJSONEntity *action in [message delegateActions]){
                    IPMessageCompletionDelegateAction *actionEntity = [IPMessageCompletionDelegateAction MR_createEntityInContext:localContext];
                    [actionEntity setPropertiesFromDictionary:[action toDictionary]];
                    [messageEntity addDelegateActionsObject:actionEntity];
                }
            }
            if ([message notificationActions]){
                for (IPMessageCompletionNotificationJSONAction *action in [message notificationActions]){
                    IPMessageCompletionNotificationAction *actionEntity = [IPMessageCompletionNotificationAction MR_createEntityInContext:localContext];
                    [actionEntity setPropertiesFromDictionary:[action toDictionary]];
                    [messageEntity addNotificationActionsObject:actionEntity];
                }
            }
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave && !error){
            NSLog(@"[I]%@ inserted successfully.",@([messages count]));
            if (containsHighPriorityMessage){
                [weakSelf.dispatcher highPriorityMessageAdded];
            }
        } else if (error){
            NSLog(@"[E]%@ error while inserting %@ messages.",error,@([messages count]));
        }
    }];
}

@end