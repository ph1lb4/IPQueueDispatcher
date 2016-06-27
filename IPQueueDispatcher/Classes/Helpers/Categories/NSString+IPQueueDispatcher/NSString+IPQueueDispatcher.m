//
//  NSString+IPQueueDispatcher.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "NSString+IPQueueDispatcher.h"

@implementation NSString (IPQueueDispatcher)

+ (BOOL)isNotEmpty:(NSString *)string
{
    return (![[NSNull null] isEqual:string] && [[string trim] length] > 0);
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end