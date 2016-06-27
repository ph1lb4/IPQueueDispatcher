//
//  NSObject+IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (IPQueueDispatcher)

/**
 *  Set object's properties from dictionary keys-values paris
 *
 *  @param properties the dictionary containing as keys the properties' names to update with contained values
 */
- (void)setPropertiesFromDictionary:(NSDictionary *)properties;

/**
 *  Used when converting from to dictionary using - toDictionary function. Defines the keys to set for each object's property
 *
 *  @return propertyName-key dictionary
 */
- (NSDictionary *)JSONKeyPathsByPropertyKey;

/**
 *  Convert's the current object to NSDictionary object based on - JSONKeyPathsByPropertyKey result
 *
 *  @return the resulted dictionary
 */
- (NSDictionary *)toDictionary;

/**
 *  Assures the object to be inseted is valid (not nil) and if it's performs the insertion with error handling
 *
 *  @param key        Key to be linked with provided object
 *  @param value      The object to be inserted. If nil object will be converted to [NSNull null] instance
 *  @param collection The collection we would like to update
 */
- (void)addSafeKey:(NSString *)key
             value:(id)value
        collection:(NSMutableDictionary *)collection;

@end