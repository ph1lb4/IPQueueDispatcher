//
//  IPMessageEntity+CoreDataProperties.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IPMessageEntity+CoreDataProperties.h"

@implementation IPMessageEntity (CoreDataProperties)

@dynamic actionID;
@dynamic createdAt;
@dynamic endedAt;
@dynamic isInvalid;
@dynamic isSticky;
@dynamic isUnique;
@dynamic lastTriedAt;
@dynamic maximumTries;
@dynamic needsAuthentication;
@dynamic path;
@dynamic priority;
@dynamic protocol;
@dynamic timesTried;
@dynamic uid;
@dynamic headers;
@dynamic delegateActions;
@dynamic notificationActions;
@dynamic properties;
@dynamic serializers;
@dynamic url;

@end
