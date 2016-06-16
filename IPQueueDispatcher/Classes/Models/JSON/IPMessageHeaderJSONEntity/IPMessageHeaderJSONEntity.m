//
//  IPMessageHeaderJSONEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageHeaderJSONEntity.h"
#import "NSObject+IPQueueDispatcher.h"
#import "NSString+IPQueueDispatcher.h"

@implementation IPMessageHeaderJSONEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"content":@"content",
             @"name":@"name",
             @"ommitEmptyValue":@"ommitEmptyValue",
             };
}

- (BOOL)isValid
{
    BOOL result = YES;
    
    result = [NSString isNotEmpty:[self name]] && [NSString isNotEmpty:[self content]];
    if (!result && ![[self ommitEmptyValue] boolValue]){
        if (![NSString isNotEmpty:[self name]]){
            [self setName:[NSNull null]];
        }
        if (![NSString isNotEmpty:[self content]]){
            [self setContent:[NSNull null]];
        }
        result = YES;
    }
    return result;
}


@end
