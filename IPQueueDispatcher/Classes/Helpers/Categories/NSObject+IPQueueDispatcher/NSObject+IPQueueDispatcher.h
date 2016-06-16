//
//  NSObject+IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (IPQueueDispatcher)

- (void)setPropertiesFromDictionary:(NSDictionary *)properties;

- (NSDictionary *)JSONKeyPathsByPropertyKey;

- (NSDictionary *)toDictionary;

- (void)addSafeKey:(NSString *)key
             value:(id)value
        collection:(NSMutableDictionary *)collection;

- (void)addSafeKey:(NSString *)key
             value:(id)value
        collection:(NSMutableDictionary *)collection;

@end
