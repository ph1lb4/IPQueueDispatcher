//
//  IPMessageCompletionNotificationJSONAction.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageCompletionNotificationJSONAction.h"
#import "NSObject+IPQueueDispatcher.h"
#import "NSDictionary+IPQueueDispatcher.h"

@implementation IPMessageCompletionNotificationJSONAction

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [[super JSONKeyPathsByPropertyKey] addObjectsFromDictionary:@{@"notificationName":@"notificationName"}];
}

@end