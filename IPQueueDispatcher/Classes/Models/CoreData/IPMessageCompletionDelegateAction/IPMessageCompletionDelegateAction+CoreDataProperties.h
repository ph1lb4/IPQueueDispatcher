//
//  IPMessageCompletionDelegateAction+CoreDataProperties.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessageCompletionDelegateAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPMessageCompletionDelegateAction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *selector;
@property (nullable, nonatomic, retain) IPMessageEntity *message;

@end

NS_ASSUME_NONNULL_END
