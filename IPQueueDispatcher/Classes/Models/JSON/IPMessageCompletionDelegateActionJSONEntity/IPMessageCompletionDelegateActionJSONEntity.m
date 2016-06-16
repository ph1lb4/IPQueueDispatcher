//
//  IPMessageCompletionDelegateActionJSONEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageCompletionDelegateActionJSONEntity.h"
#import "NSObject+IPQueueDispatcher.h"
#import "NSDictionary+IPQueueDispatcher.h"

@implementation IPMessageCompletionDelegateActionJSONEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [[super JSONKeyPathsByPropertyKey] addObjectsFromDictionary:@{@"selector":@"selector"}];
}

@end