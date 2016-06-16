//
//  IPMessageCompletionAction+CoreDataProperties.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessageCompletionAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPMessageCompletionAction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *completionActionType;
@property (nullable, nonatomic, retain) NSNumber *includeRawResponse;

@end

NS_ASSUME_NONNULL_END
