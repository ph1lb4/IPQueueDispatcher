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
@property (nonatomic)IPMessageURLJSONEntity  * _Nullable  url;
@property (nonatomic)NSArray<IPMessageHeaderJSONEntity *> * _Nullable headers;
@property (nonatomic)NSArray<IPMessagePropertyJSONEntity *> * _Nullable properties;
@property (nonatomic)IPMessageSerializerJSONEntity * _Nullable serializer;
@property (nonatomic)NSArray<IPMessageCompletionDelegateActionJSONEntity *> * _Nullable delegateActions;
@property (nonatomic)NSArray<IPMessageCompletionNotificationJSONAction *> * _Nullable notificationActions;

#pragma mark - URL

- (void)setBaseURL:(NSString * _Nullable)baseURL
              path:(NSString * _Nullable)path;

- (void)setPath:(NSString * _Nullable)path;

#pragma mark - Headers

- (void)addHeaders:(NSDictionary * _Nullable)headers
   ommitEmptyValue:(BOOL)ommitEmptyValue;

- (void)addHeaderForKey:(NSString * _Nullable)key
                  value:(NSString * _Nullable)value
        ommitEmptyValue:(BOOL)ommitEmptyValue;

#pragma mark - Properties

- (void)addProperties:(NSDictionary * _Nullable)propeties
         includeInURL:(BOOL)includeInURL
      ommitEmptyValue:(BOOL)ommitEmptyValue;

- (void)addPropertyForKey:(NSString * _Nullable)key
                    value:(id _Nullable)value
             includeInURL:(BOOL)includeInURL
          ommitEmptyValue:(BOOL)ommitEmptyValue;

- (void)addPropertyForKey:(NSString * _Nullable)key
                    value:(id _Nullable)value;

#pragma mark - Serializer

- (void)setJSONtoJSONSerializers;

- (void)setJSONtoXMLSerializers;

- (void)setRequestSerializer:(NSInteger)requestSerializerId
        responseSerializerId:(NSInteger)responseSerializerId;

- (void)setRequestSerializerClass:(NSString * _Nullable)requestSerializerClass
          responseSerializerClass:(NSString * _Nullable)responseSerializerClass;

#pragma mark - Delegate Actions

- (void)addDelegateAction:(NSString * _Nullable)selector
       includeRawResponse:(BOOL)includeRawResponse;

- (void)addNotificationAction:(NSString * _Nullable)notificationName
           includeRawResponse:(BOOL)includeRawResponse;

#pragma mark - Helpers

- (NSDictionary * _Nullable)propertiesAsDictionary;

@end