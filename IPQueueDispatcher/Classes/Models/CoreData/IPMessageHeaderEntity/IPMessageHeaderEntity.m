//
//  IPMessageHeaderEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageHeaderEntity.h"
#import "IPMessageEntity.h"
#import "NSString+IPQueueDispatcher.h"

@implementation IPMessageHeaderEntity

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
