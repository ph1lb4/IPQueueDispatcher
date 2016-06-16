//
//  IPMessageSerializerEntity+CoreDataProperties.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessageSerializerEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IPMessageSerializerEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *responseSerializerID;
@property (nullable, nonatomic, retain) NSString *requestSerializerClass;
@property (nullable, nonatomic, retain) NSNumber *requestSerializerID;
@property (nullable, nonatomic, retain) NSString *responseSerializerClass;
@property (nullable, nonatomic, retain) IPMessageEntity *message;

@end

NS_ASSUME_NONNULL_END
