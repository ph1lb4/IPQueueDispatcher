//
//  NSDictionary+IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (IPQueueDispatcher)

/**
 *  Insert the specific key-value pair in the dictionary
 *
 *  @param object The object to add
 *  @param key    The key to relate with that object
 *
 *  @return the newly created dictionary. The initial object stays untouched
 */
- (NSDictionary *)addObject:(id)object
                     forKey:(NSString *)key;

/**
 *  Insert objects from given dictionary to initial object
 *
 *  @param dictionary The source dictionary
 *
 *  @return The newly created dictionary. The initial object stays untouched
 */
- (NSDictionary *)addObjectsFromDictionary:(NSDictionary *)dictionary;

@end
