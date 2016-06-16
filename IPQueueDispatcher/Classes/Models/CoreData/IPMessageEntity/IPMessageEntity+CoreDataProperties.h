//
//  IPMessageEntity+CoreDataProperties.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessageEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPMessageEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *actionID;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSDate *endedAt;
@property (nullable, nonatomic, retain) NSNumber *isInvalid;
@property (nullable, nonatomic, retain) NSNumber *isSticky;
@property (nullable, nonatomic, retain) NSNumber *isUnique;
@property (nullable, nonatomic, retain) NSDate *lastTriedAt;
@property (nullable, nonatomic, retain) NSNumber *maximumTries;
@property (nullable, nonatomic, retain) NSNumber *needsAuthentication;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) NSNumber *priority;
@property (nullable, nonatomic, retain) NSNumber *protocol;
@property (nullable, nonatomic, retain) NSNumber *timesTried;
@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSSet<IPMessageHeaderEntity *> *headers;
@property (nullable, nonatomic, retain) NSSet<IPMessageCompletionDelegateAction *> *delegateActions;
@property (nullable, nonatomic, retain) NSSet<IPMessageCompletionNotificationAction *> *notificationActions;
@property (nullable, nonatomic, retain) NSSet<IPMessagePropertyEntity *> *properties;
@property (nullable, nonatomic, retain) IPMessageSerializerEntity *serializers;
@property (nullable, nonatomic, retain) IPMessageURLEntity *url;

@end

@interface IPMessageEntity (CoreDataGeneratedAccessors)

- (void)addHeadersObject:(IPMessageHeaderEntity *)value;
- (void)removeHeadersObject:(IPMessageHeaderEntity *)value;
- (void)addHeaders:(NSSet<IPMessageHeaderEntity *> *)values;
- (void)removeHeaders:(NSSet<IPMessageHeaderEntity *> *)values;

- (void)addDelegateActionsObject:(IPMessageCompletionDelegateAction *)value;
- (void)removeDelegateActionsObject:(IPMessageCompletionDelegateAction *)value;
- (void)addDelegateActions:(NSSet<IPMessageCompletionDelegateAction *> *)values;
- (void)removeDelegateActions:(NSSet<IPMessageCompletionDelegateAction *> *)values;

- (void)addNotificationActionsObject:(IPMessageCompletionNotificationAction *)value;
- (void)removeNotificationActionsObject:(IPMessageCompletionNotificationAction *)value;
- (void)addNotificationActions:(NSSet<IPMessageCompletionNotificationAction *> *)values;
- (void)removeNotificationActions:(NSSet<IPMessageCompletionNotificationAction *> *)values;

- (void)addPropertiesObject:(IPMessagePropertyEntity *)value;
- (void)removePropertiesObject:(IPMessagePropertyEntity *)value;
- (void)addProperties:(NSSet<IPMessagePropertyEntity *> *)values;
- (void)removeProperties:(NSSet<IPMessagePropertyEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
