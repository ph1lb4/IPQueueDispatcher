//
//  IPMessageCompletionActionJSONEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageCompletionActionJSONEntity.h"
#import "NSObject+IPQueueDispatcher.h"

@implementation IPMessageCompletionActionJSONEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"completionActionType":@"completionActionType",
             @"includeRawResponse":@"includeRawResponse",
             };
}

@end
