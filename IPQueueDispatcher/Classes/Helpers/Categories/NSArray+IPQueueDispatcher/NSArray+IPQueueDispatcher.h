//
//  NSArray+IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (IPQueueDispatcher)

/**
 *  Insert and object to an array and returns the resulted array. Initial object stays untouched
 *
 *  @param object the object to add on the array
 *
 *  @return the new array created from a copy of the current object and appended with the new object
 */
- (NSArray *)addObject:(id)object;

@end