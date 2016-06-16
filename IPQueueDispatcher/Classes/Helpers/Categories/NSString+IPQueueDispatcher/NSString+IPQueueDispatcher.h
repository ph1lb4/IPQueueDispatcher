//
//  NSString+IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSString (IPQueueDispatcher)

+ (BOOL)isNotEmpty:(NSString *)string;

- (NSString *)trim;

- (NSString *)MD5String;

@end