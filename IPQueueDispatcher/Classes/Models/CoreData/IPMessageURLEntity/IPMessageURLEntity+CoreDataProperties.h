//
//  IPMessageURLEntity+CoreDataProperties.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessageURLEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPMessageURLEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *baseURL;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) IPMessageEntity *message;

@end

NS_ASSUME_NONNULL_END
