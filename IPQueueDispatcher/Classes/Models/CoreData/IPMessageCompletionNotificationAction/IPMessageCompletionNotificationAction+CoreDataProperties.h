//
//  IPMessageCompletionNotificationAction+CoreDataProperties.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessageCompletionNotificationAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPMessageCompletionNotificationAction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *notificationName;
@property (nullable, nonatomic, retain) IPMessageEntity *message;

@end

NS_ASSUME_NONNULL_END
