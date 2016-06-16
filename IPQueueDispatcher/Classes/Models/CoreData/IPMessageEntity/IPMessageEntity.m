//
//  IPMessageEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageEntity.h"
#import "IPMessageCompletionDelegateAction.h"
#import "IPMessageCompletionNotificationAction.h"
#import "IPMessageHeaderEntity.h"
#import "IPMessagePropertyEntity.h"
#import "IPMessageSerializerEntity.h"
#import "IPMessageURLEntity.h"
#import "NSObject+IPQueueDispatcher.h"
#pragma mark - JSON Models
#import "IPMessageJSONEntity.h"
#import "IPMessageURLJSONEntity.h"
#import "IPMessageHeaderJSONEntity.h"
#import "IPMessagePropertyJSONEntity.h"
#import "IPMessageSerializerJSONEntity.h"
#import "IPMessageCompletionDelegateActionJSONEntity.h"
#import "IPMessageCompletionNotificationJSONAction.h"

@implementation IPMessageEntity

- (NSDictionary *)propertiesAsDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for  (IPMessagePropertyEntity *property in [self properties]){
        if ([property isValid]){
            [result setObject:[property content]
                       forKey:[property name]];
        }
    }
    return [NSDictionary dictionaryWithDictionary:result];
}

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"actionID":@"actionID",
             @"createdAt":@"createdAt",
             @"endedAt":@"endedAt",
             @"isInvalid":@"isInvalid",
             @"isSticky":@"isSticky",
             @"isUnique":@"isUnique",
             @"lastTriedAt":@"lastTriedAt",
             @"maximumTries":@"maximumTries",
             @"needsAuthentication":@"needsAuthentication",
             @"priority":@"priority",
             @"protocol":@"protocol",
             @"timesTried":@"timesTried",
             @"uid":@"uid",
             };
}

- (IPMessageJSONEntity *)toJSONObject
{
    IPMessageJSONEntity *messageEntity = [IPMessageJSONEntity new];
    [messageEntity setObjectID:[self objectID]];
    [messageEntity setPropertiesFromDictionary:[self toDictionary]];
    if ([self url]){
        IPMessageURLJSONEntity *urlEntity = [IPMessageURLJSONEntity new];
        [urlEntity setPropertiesFromDictionary:[self.url toDictionary]];
    }
    if ([self serializers]){
        IPMessageSerializerJSONEntity *serializerEntity = [IPMessageSerializerJSONEntity new];
        [serializerEntity setPropertiesFromDictionary:[self.serializers toDictionary]];
    }
    if ([self headers]){
        for (IPMessageHeaderEntity *header in [self headers]){
            [messageEntity addHeaderForKey:[header name]
                                     value:[header content]
                           ommitEmptyValue:[[header ommitEmptyValue] boolValue]];
        }
    }
    if ([self properties]){
        for (IPMessageHeaderEntity *property in [self properties]){
            [messageEntity addPropertyForKey:[property name]
                                       value:[property content]
                                includeInURL:NO
                             ommitEmptyValue:[[property ommitEmptyValue] boolValue]];
        }
    }
    if ([self delegateActions]){
        for (IPMessageCompletionDelegateAction *action in [self delegateActions]){
            [messageEntity addDelegateAction:[action selector]
                          includeRawResponse:[[action includeRawResponse] boolValue]];
        }
    }
    if ([self notificationActions]){
        for (IPMessageCompletionNotificationAction *action in [self notificationActions]){
            [messageEntity addNotificationAction:[action notificationName]
                              includeRawResponse:[[action includeRawResponse] boolValue]];
        }
    }
    return messageEntity;
}

@end
