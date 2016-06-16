//
//  IPMessagePropertyEntity+CoreDataProperties.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessagePropertyEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPMessagePropertyEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *includeInURL;
@property (nullable, nonatomic, retain) id content;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *ommitEmptyValue;
@property (nullable, nonatomic, retain) IPMessageEntity *message;

@end

NS_ASSUME_NONNULL_END
