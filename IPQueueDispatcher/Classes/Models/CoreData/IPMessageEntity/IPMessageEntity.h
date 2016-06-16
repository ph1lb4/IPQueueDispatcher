//
//  IPMessageEntity.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IPMessageCompletionDelegateAction, IPMessageCompletionNotificationAction, IPMessageHeaderEntity, IPMessagePropertyEntity, IPMessageSerializerEntity, IPMessageURLEntity, IPMessageJSONEntity;

NS_ASSUME_NONNULL_BEGIN

@interface IPMessageEntity : NSManagedObject

- (NSDictionary *)propertiesAsDictionary;

- (IPMessageJSONEntity *)toJSONObject;

@end

NS_ASSUME_NONNULL_END

#import "IPMessageEntity+CoreDataProperties.h"
