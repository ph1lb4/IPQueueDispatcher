//
//  IPMessagePropertyJSONEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessagePropertyJSONEntity.h"
#import "NSObject+IPQueueDispatcher.h"
#import "NSString+IPQueueDispatcher.h"

@implementation IPMessagePropertyJSONEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"content":@"content",
             @"name":@"name",
             @"includeInURL":@"includeInURL",
             @"ommitEmptyValue":@"ommitEmptyValue",
             };
}

- (BOOL)isValid
{
    BOOL result = YES;
    
    result = [NSString isNotEmpty:[self name]] && [NSString isNotEmpty:[self content]];
    if (!result && ![[self ommitEmptyValue] boolValue]){
        if (![NSString isNotEmpty:[self name]]){
            [self setName:@""];
        }
        if (![NSString isNotEmpty:[self content]]){
            [self setContent:@""];
        }
        result = YES;
    }
    return result;
}

@end
