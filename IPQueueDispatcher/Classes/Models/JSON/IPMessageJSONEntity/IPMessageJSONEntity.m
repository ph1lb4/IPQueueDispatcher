//
//  IPMessageJSONEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageJSONEntity.h"
#import "IPMessageURLJSONEntity.h"
#import "IPMessageHeaderJSONEntity.h"
#import "IPMessagePropertyJSONEntity.h"
#import "IPMessageSerializerJSONEntity.h"
#import "IPMessageCompletionDelegateActionJSONEntity.h"
#import "IPMessageCompletionNotificationJSONAction.h"
#import "IPMessagesHandler.h"
#import "NSArray+IPQueueDispatcher.h"
#import "NSObject+IPQueueDispatcher.h"

@implementation IPMessageJSONEntity

- (instancetype)init
{
    if (self = [super init]){
        [self setUid:[[NSUUID UUID] UUIDString]];
        [self setCreatedAt:[NSDate date]];
        [self setMaximumTries:@3];
        [self setNeedsAuthentication:@(YES)];
        [self setPriority:@(IPMessagePriorityNormal)];
        [self setProtocol:@(IPMessageProtocolGET)];
    }
}

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"actionID":@"actionID",
             @"createdAt":@"createdAt",
             @"endedAt":@"endedAt",
             @"isInvalid":@"isInvalid",
             @"isSticky":@"isSticky",
             @"isUnique":@"isUnique",
             @"lastTriedAt":@"lastTriedAt",
             @"maximumTries":@"maximumTries",
             @"needsAuthentication":@"needsAuthentication",
             @"priority":@"priority",
             @"protocol":@"protocol",
             @"timesTried":@"timesTried",
             @"uid":@"uid",
             };
}

#pragma mark - URL

- (void)setBaseURL:(NSString *)baseURL
              path:(NSString *)path
{
    [self setUrl:[IPMessageURLJSONEntity new]];
    [self.url setBaseURL:baseURL];
    [self.url setPath:path];
}

- (void)setPath:(NSString *)path
{
    [self setBaseURL:[[IPMessagesHandler sharedInstance] baseURL]
                path:path];
}

#pragma mark - Headers

- (void)addHeaders:(NSDictionary *)headers
   ommitEmptyValue:(BOOL)ommitEmptyValue
{
    for (NSString *key in [headers allKeys]){
        [self addHeaderForKey:key
                        value:headers[key]
              ommitEmptyValue:ommitEmptyValue];
    }
}

- (void)addHeaderForKey:(NSString *)key
                  value:(NSString *)value
        ommitEmptyValue:(BOOL)ommitEmptyValue
{
    if (key){
        IPMessageHeaderJSONEntity *header = [IPMessageHeaderJSONEntity new];
        [header setName:key];
        [header setContent:value];
        [header setOmmitEmptyValue:@(ommitEmptyValue)];
        if (![self headers]){
            [self setHeaders:@[header]];
        } else {
            [self setHeaders:[self.headers addObject:header]];
        }
    }
}

#pragma mark - Properties

- (void)addProperties:(NSDictionary *)propeties
         includeInURL:(BOOL)includeInURL
      ommitEmptyValue:(BOOL)ommitEmptyValue
{
    for (NSString *key in [propeties allKeys]){
        [self addPropertyForKey:key
                          value:propeties[key]
                   includeInURL:includeInURL
                ommitEmptyValue:ommitEmptyValue];
    }
}

- (void)addPropertyForKey:(NSString *)key
                    value:(id)value
             includeInURL:(BOOL)includeInURL
          ommitEmptyValue:(BOOL)ommitEmptyValue
{
    if (key){
        IPMessagePropertyJSONEntity *property = [IPMessagePropertyJSONEntity new];
        [property setName:key];
        [property setContent:value];
        [property setIncludeInURL:@(includeInURL)];
        [property setOmmitEmptyValue:@(ommitEmptyValue)];
        if (![self properties]){
            [self setProperties:@[property]];
        } else {
            [self setProperties:[self.properties addObject:property]];
        }
    }
}

- (void)addPropertyForKey:(NSString *)key
                    value:(id)value
{
    [self addPropertyForKey:key
                      value:value
               includeInURL:NO
            ommitEmptyValue:YES];
}

#pragma mark - Serializer

- (void)setJSONtoJSONSerializers
{
    [self setRequestSerializer:IPMessageRequestSerializerTypeJSON
          responseSerializerId:IPMessageResponseSerializerTypeJSON];
}

- (void)setJSONtoXMLSerializers
{
    [self setRequestSerializer:IPMessageRequestSerializerTypeJSON
          responseSerializerId:IPMessageResponseSerializerTypeXML];
}

- (void)setRequestSerializer:(NSInteger)requestSerializerId
        responseSerializerId:(NSInteger)responseSerializerId
{
    [self setSerializer:[IPMessageSerializerJSONEntity new]];
    [self.serializer setRequestSerializerID:@(requestSerializerId)];
    [self.serializer setResponseSerializerID:@(responseSerializerId)];
}

- (void)setRequestSerializerClass:(NSString *)requestSerializerClass
          responseSerializerClass:(NSString *)responseSerializerClass
{
    [self setSerializer:[IPMessageSerializerJSONEntity new]];
    [self.serializer setRequestSerializerClass:requestSerializerClass];
    [self.serializer setResponseSerializerClass:responseSerializerClass];
}

#pragma mark - Delegate Actions

- (void)addDelegateAction:(NSString *)selector
       includeRawResponse:(BOOL)includeRawResponse
{
    if (selector){
        IPMessageCompletionDelegateActionJSONEntity *action = [IPMessageCompletionDelegateActionJSONEntity new];
        [action setSelector:selector];
        [action setIncludeRawResponse:@(includeRawResponse)];
        if (![self delegateActions]){
            [self setDelegateActions:@[action]];
        } else {
            [self setDelegateActions:[self.delegateActions addObject:action]];
        }
    }
}

- (void)addNotificationAction:(NSString *)notificationName
           includeRawResponse:(BOOL)includeRawResponse
{
    if (notificationName){
        IPMessageCompletionNotificationJSONAction *action = [IPMessageCompletionNotificationJSONAction new];
        [action setNotificationName:notificationName];
        [action setIncludeRawResponse:@(includeRawResponse)];
        if (![self notificationActions]){
            [self setNotificationActions:@[action]];
        } else {
            [self setNotificationActions:[self.notificationActions addObject:action]];
        }
    }
}

#pragma mark - Helpers

- (NSDictionary *)propertiesAsDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for  (IPMessagePropertyJSONEntity *property in [self properties]){
        if ([property isValid]){
            [result setObject:[property content]
                       forKey:[property name]];
        }
    }
    return [NSDictionary dictionaryWithDictionary:result];
}


@end