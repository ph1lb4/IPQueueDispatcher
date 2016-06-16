//
//  IPMessageJSONEntity.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@class IPMessageURLJSONEntity, IPMessageHeaderJSONEntity, IPMessagePropertyJSONEntity, IPMessageSerializerJSONEntity, IPMessageCompletionDelegateActionJSONEntity, IPMessageCompletionNotificationJSONAction, NSManagedObjectID;

@interface IPMessageJSONEntity : NSObject

typedef NS_ENUM(NSInteger, IPMessagePriority) {
    IPMessagePriorityLow = 0,
    IPMessagePriorityNormal,
    IPMessagePriorityHigh,
};

typedef NS_ENUM(NSInteger, IPMessageProtocol) {
    IPMessageProtocolGET = 0,
    IPMessageProtocolPOST,
    IPMessageProtocolPUT,
    IPMessageProtocolDELETE,
};

@property (nullable, nonatomic) NSManagedObjectID *objectID;
@property (nullable, nonatomic) NSNumber *actionID;
@property (nullable, nonatomic) NSDate *createdAt;
@property (nullable, nonatomic) NSDate *endedAt;
@property (nullable, nonatomic) NSNumber *isInvalid;
@property (nullable, nonatomic) NSNumber *isSticky;
@property (nullable, nonatomic) NSNumber *isUnique;
@property (nullable, nonatomic) NSDate *lastTriedAt;
@property (nullable, nonatomic) NSNumber *maximumTries;
@property (nullable, nonatomic) NSNumber *needsAuthentication;
@property (nullable, nonatomic) NSNumber *priority;
@property (nullable, nonatomic) NSNumber *protocol;
@property (nullable, nonatomic) NSNumber *timesTried;
@property (nullable, nonatomic) NSString *uid;
@property (nonatomic)IPMessageURLJSONEntity *url;
@property (nonatomic)NSArray<IPMessageHeaderJSONEntity *> *headers;
@property (nonatomic)NSArray<IPMessagePropertyJSONEntity *> *properties;
@property (nonatomic)IPMessageSerializerJSONEntity *serializer;
@property (nonatomic)NSArray<IPMessageCompletionDelegateActionJSONEntity *> *delegateActions;
@property (nonatomic)NSArray<IPMessageCompletionNotificationJSONAction *> *notificationActions;

#pragma mark - URL

- (void)setBaseURL:(NSString *)baseURL
              path:(NSString *)path;

- (void)setPath:(NSString *)path;

#pragma mark - Headers

- (void)addHeaders:(NSDictionary *)headers
   ommitEmptyValue:(BOOL)ommitEmptyValue;

- (void)addHeaderForKey:(NSString *)key
                  value:(NSString *)value
        ommitEmptyValue:(BOOL)ommitEmptyValue;

#pragma mark - Properties

- (void)addProperties:(NSDictionary *)propeties
         includeInURL:(BOOL)includeInURL
      ommitEmptyValue:(BOOL)ommitEmptyValue;

- (void)addPropertyForKey:(NSString *)key
                    value:(id)value
             includeInURL:(BOOL)includeInURL
          ommitEmptyValue:(BOOL)ommitEmptyValue;

- (void)addPropertyForKey:(NSString *)key
                    value:(id)valuel;

#pragma mark - Serializer

- (void)setJSONtoJSONSerializers;

- (void)setJSONtoXMLSerializers;

- (void)setRequestSerializer:(NSInteger)requestSerializerId
        responseSerializerId:(NSInteger)responseSerializerId;

- (void)setRequestSerializerClass:(NSString *)requestSerializerClass
          responseSerializerClass:(NSString *)responseSerializerClass;

#pragma mark - Delegate Actions

- (void)addDelegateAction:(NSString *)selector
       includeRawResponse:(BOOL)includeRawResponse;

- (void)addNotificationAction:(NSString *)notificationName
           includeRawResponse:(BOOL)includeRawResponse;

#pragma mark - Helpers

- (NSDictionary *)propertiesAsDictionary;

@end