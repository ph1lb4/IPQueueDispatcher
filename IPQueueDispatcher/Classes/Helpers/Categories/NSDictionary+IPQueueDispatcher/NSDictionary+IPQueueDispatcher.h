//
//  NSDictionary+IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IPQueueDispatcher)

- (NSArray *)addObject:(id)object
                forKey:(NSString *)key;

- (NSDictionary *)addObjectsFromDictionary:(NSDictionary *)dictionary;

@end
