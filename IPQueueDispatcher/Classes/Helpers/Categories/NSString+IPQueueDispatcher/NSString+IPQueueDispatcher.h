//
//  NSString+IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSString (IPQueueDispatcher)

/**
 *  Performs a check if the given string is nil or zero-lengthed
 *
 *  @param string The string to be validated
 *
 *  @return BOOL result(YES if given string is not empty or nil)
 */
+ (BOOL)isNotEmpty:(NSString *)string;

/**
 *  Trims provided string
 *
 *  @return the trimmed string
 */
- (NSString *)trim;

@end