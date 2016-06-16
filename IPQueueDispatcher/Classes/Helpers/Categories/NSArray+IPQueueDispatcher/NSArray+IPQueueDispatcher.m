//
//  NSArray+IPQueueDispatcher.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "NSArray+IPQueueDispatcher.h"

@implementation NSArray (IPQueueDispatcher)

- (NSArray *)addObject:(id)object
{
    NSArray *result = self;
    if (object){
        NSMutableArray *temp = [self mutableCopy];
        [temp addObject:object];
        result = [NSArray arrayWithArray:temp];
    }
    return result;
}

@end