//
//  IPNetworkLayer.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPNetworkLayer.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+IPQueueDispatcher.h"
#import "Macros.h"
#pragma mark - CoreData Entities
#import "IPMessageEntity.h"
#import "IPMessageURLEntity.h"
#import "IPMessageHeaderEntity.h"
#import "IPMessagePropertyEntity.h"
#import "IPMessageSerializerEntity.h"
#import "IPMessageCompletionDelegateAction.h"
#import "IPMessageCompletionNotificationAction.h"
#pragma mark - JSON Entities
#import "IPMessageJSONEntity.h"
#import "IPMessageURLJSONEntity.h"
#import "IPMessageHeaderJSONEntity.h"
#import "IPMessagePropertyJSONEntity.h"
#import "IPMessageSerializerJSONEntity.h"
#import "IPMessageCompletionDelegateActionJSONEntity.h"
#import "IPMessageCompletionNotificationJSONAction.h"

@interface IPNetworkLayer ()
@property (nonatomic) AFHTTPSessionManager *manager;
@property (nonatomic, getter=isReauthenticating) BOOL reauthenticating;
@property (nonatomic, readwrite) NSString *baseURL;
@end

@implementation IPNetworkLayer

- (instancetype)initWithDelegate:(id<IPNetworkLayerProtocol>)delegate
                         baseURL:(NSString *)baseURL
{
    if (self = [super init])
    {
        [self setDelegate:delegate];
        [self setBaseURL:baseURL];
        [self setManager:[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseURL]]]];
        
        __weak typeof(self) weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (weakSelf){
                NSLog(@"Changed");
            }
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    return [self initWithDelegate:nil baseURL:baseURL];
}

- (BOOL)isReachable
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

- (void)stopAll
{
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)pauseAll
{
    if ([[self.manager operationQueue] operationCount]){
        [[[self.manager operationQueue] operations] makeObjectsPerformSelector:@selector(suspend)];
    }
}

- (void)resume
{
    if ([[self.manager operationQueue] operationCount]){
//        [[[[self.manager operationQueue] operations] firstObject] resume];
    }
}

#pragma mark - Response format

- (id)formatResponseObject:(id)responseObject
                  actionID:(NSNumber *)actionID
{
    return responseObject;
}

#pragma mark - Perform Requests

- (void)executeMessageJSON:(IPMessageJSONEntity *)message
                   success:(IPNetworkLayerSuccessBlock)success
                   failure:(IPNetworkLayerFailureBlock)failure
{
    [self applyMessageJSONSerializers:[message serializer]];
    [self applyJSONHeaders:[message headers]];
    if ([[message needsAuthentication] boolValue]){
        [self prepareAuthenticationData:[message.url path]];
    }
    
    IPNetworkLayerSuccessBlock successBlock = [self successBlock:message
                                                         success:success];
    IPNetworkLayerFailureBlock failureBlock = [self failureBlock:message
                                                         success:success
                                                         failure:failure];
    switch ([[message protocol] integerValue]) {
        case IPMessageProtocolPOST:[self.manager POST:[message.url path]
                                           parameters:[message propertiesAsDictionary]
                                             progress:nil
                                              success:successBlock
                                              failure:failureBlock];break;
        case IPMessageProtocolPUT:[self.manager PUT:[message.url path]
                                         parameters:[message propertiesAsDictionary]
                                            success:successBlock
                                            failure:failureBlock];break;
        case IPMessageProtocolDELETE:[self.manager DELETE:[message.url path]
                                               parameters:[message propertiesAsDictionary]
                                                  success:successBlock
                                                  failure:failureBlock];break;
        default:[self.manager GET:[message.url path]
                       parameters:[message propertiesAsDictionary]
                         progress:nil
                          success:successBlock
                          failure:failureBlock];break;
    }
}

#pragma mark - Serializers

- (void)applyMessageJSONSerializers:(IPMessageSerializerJSONEntity *)messageSerializers
{
    if ([NSString isNotEmpty:[messageSerializers requestSerializerClass]]) {
        Class serializerClass = NSClassFromString([messageSerializers requestSerializerClass]);
        if ([serializerClass respondsToSelector:@selector(serializer)]){
            SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self.manager setRequestSerializer:[serializerClass performSelector:@selector(serializer)]];);
        } else {
            switch ([[messageSerializers requestSerializerID] integerValue]) {
                case IPMessageRequestSerializerTypeJSON:[self.manager setRequestSerializer:[AFJSONRequestSerializer serializer]];break;
                case IPMessageRequestSerializerTypePropertyList:[self.manager setRequestSerializer:[AFPropertyListRequestSerializer serializer]];break;
                default:[self.manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];break;
            }
        }
    } else {
        switch ([[messageSerializers requestSerializerID] integerValue]) {
            case IPMessageRequestSerializerTypeJSON:[self.manager setRequestSerializer:[AFJSONRequestSerializer serializer]];break;
            case IPMessageRequestSerializerTypePropertyList:[self.manager setRequestSerializer:[AFPropertyListRequestSerializer serializer]];break;
            default:[self.manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];break;
        }
    }
    
    if ([NSString isNotEmpty:[messageSerializers responseSerializerClass]]) {
        Class serializerClass = NSClassFromString([messageSerializers responseSerializerClass]);
        if ([serializerClass respondsToSelector:@selector(serializer)]){
            SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self.manager setResponseSerializer:[serializerClass performSelector:@selector(serializer)]];);
        } else {
            switch ([[messageSerializers responseSerializerID] integerValue]) {
                case IPMessageResponseSerializerTypeJSON:[self.manager setResponseSerializer:[AFJSONResponseSerializer serializer]];break;
                case IPMessageResponseSerializerTypeXML:[self.manager setResponseSerializer:[AFXMLParserResponseSerializer serializer]];break;
                case IPMessageResponseSerializerTypePropertyList:[self.manager setResponseSerializer:[AFPropertyListResponseSerializer serializer]];break;
                case IPMessageResponseSerializerTypeImage:[self.manager setResponseSerializer:[AFImageResponseSerializer serializer]];break;
                case IPMessageResponseSerializerTypeCompound:[self.manager setResponseSerializer:[AFCompoundResponseSerializer serializer]];break;
                default:[self.manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];break;
            }
        }
    } else {
        switch ([[messageSerializers responseSerializerID] integerValue]) {
            case IPMessageResponseSerializerTypeJSON:[self.manager setResponseSerializer:[AFJSONResponseSerializer serializer]];break;
            case IPMessageResponseSerializerTypeXML:[self.manager setResponseSerializer:[AFXMLParserResponseSerializer serializer]];break;
            case IPMessageResponseSerializerTypePropertyList:[self.manager setResponseSerializer:[AFPropertyListResponseSerializer serializer]];break;
            case IPMessageResponseSerializerTypeImage:[self.manager setResponseSerializer:[AFImageResponseSerializer serializer]];break;
            case IPMessageResponseSerializerTypeCompound:[self.manager setResponseSerializer:[AFCompoundResponseSerializer serializer]];break;
            default:[self.manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];break;
        }
    }
}

#pragma mark - Headers

- (void)applyJSONHeaders:(NSArray<IPMessageHeaderJSONEntity *> *)headers
{
    for (IPMessageHeaderJSONEntity *header in headers){
        if ([header isValid]){
            [self.manager.requestSerializer setValue:[header name]
                                  forHTTPHeaderField:[header content]];
        }
    }
}

#pragma mark - Authentication

- (void)prepareAuthenticationData:(NSString *)path
{
    if ([self delegate] && [self.delegate conformsToProtocol:@protocol(IPNetworkLayerProtocol)])
    {
        [self.delegate authenticationDataForRequestSerializer:[self.manager requestSerializer]
                                                         path:(NSString *)path];
    }
}

#pragma mark - Result Blocks

- (IPNetworkLayerSuccessBlock)successBlock:(IPMessageJSONEntity *)message
                                   success:(IPNetworkLayerSuccessBlock)success
{
    __weak typeof(self) weakSelf = self;
    return ^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf delegateSuccessCallForPath:message
                                    response:responseObject];
        if (success){
            success(task,responseObject);
        }
    };
}

- (IPNetworkLayerFailureBlock)failureBlock:(IPMessageJSONEntity *)message
                                   success:(IPNetworkLayerSuccessBlock)success
                                   failure:(IPNetworkLayerFailureBlock)failure
{
    __weak typeof(self) weakSelf = self;
    return ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)[task response] statusCode];
        if (statusCode == 401 && [message.actionID integerValue] != -9999) {
            [weakSelf reAuthenticate:message
                             success:success
                             failure:failure];
        } else {
            [weakSelf delegateFailedCallForPath:message
                                          error:error];
            if (failure){
                failure(task,error);
            }
        }
    };
}

- (void)reAuthenticate:(IPMessageJSONEntity *)message
               success:(IPNetworkLayerSuccessBlock)success
               failure:(IPNetworkLayerFailureBlock)failure
{
    if ([self delegate] && [self.delegate conformsToProtocol:@protocol(IPNetworkLayerProtocol)])
    {
        if (![self isReauthenticating]){
            [self pauseAll];
            [self setReauthenticating:YES];
            IPMessageJSONEntity *reAuthenticationMessage = [self.delegate reAuthenticate];
            if (reAuthenticationMessage){
                [reAuthenticationMessage setActionID:@(-9999)];
                [reAuthenticationMessage setNeedsAuthentication:@NO];
                
                __weak typeof(self) weakSelf = self;
                [self executeMessageJSON:reAuthenticationMessage
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     [weakSelf resume];
                                     [weakSelf setReauthenticating:NO];
                                     [weakSelf delegateSuccessReAuthenticationCall:reAuthenticationMessage
                                                                          response:responseObject];
                                     [weakSelf executeMessageJSON:message
                                                          success:success
                                                          failure:failure];
                                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     NSLog(@"[W]Reauthentication failed.");
                                     [weakSelf delegateFailedReAuthenticationCall:reAuthenticationMessage
                                                                            error:error];
                                     [weakSelf setReauthenticating:NO];
                                 }];
            }
        }
    }
}

#pragma mark - Result Operations

- (void)delegateSuccessCallForPath:(IPMessageJSONEntity *)message
                          response:(id)responseObject
{
    id formattedResponseObject = [self formatResponseObject:responseObject actionID:[message actionID]];
    if ([self delegate] && [self.delegate respondsToSelector:@selector(successfulOperation:formattedResponseObject:responseObject:)]){
        [self.delegate successfulOperation:message
                   formattedResponseObject:formattedResponseObject
                            responseObject:responseObject];
    } else {
        NSLog(@"[W]No delegate found for IPNetworkLayer instance");
    }
}

- (void)delegateFailedCallForPath:(IPMessageJSONEntity *)message
                            error:(NSError *)error
{
    if ([self delegate] && [self.delegate respondsToSelector:@selector(failedOperation:error:)]){
        [self.delegate failedOperation:message
                                 error:error];
    } else {
        NSLog(@"[W]No delegate found for IPNetworkLayer instance");
    }
}

- (void)delegateNoConnectionCallForPath:(IPMessageJSONEntity *)message
{
    if ([self delegate] && [self.delegate respondsToSelector:@selector(noInternetOperation:)]){
        [self.delegate noInternetOperation:message];
    } else {
        NSLog(@"[W]No delegate found for IPNetworkLayer instance");
    }
}

- (void)delegateSuccessReAuthenticationCall:(IPMessageJSONEntity *)reAuthenticationMessage
                                   response:(id)responseObject
{
    id formattedResponseObject = [self formatResponseObject:responseObject actionID:[reAuthenticationMessage actionID]];
    if ([self delegate] && [self.delegate respondsToSelector:@selector(successfulReAuthenticationOperation:formattedResponseObject:responseObject:)]){
        [self.delegate successfulReAuthenticationOperation:reAuthenticationMessage
                                   formattedResponseObject:formattedResponseObject
                                            responseObject:responseObject];
    } else {
        NSLog(@"[W]No delegate found for IPNetworkLayer instance");
    }
}

- (void)delegateFailedReAuthenticationCall:(IPMessageJSONEntity *)reAuthenticationMessage
                                     error:(NSError *)error
{
    if ([self delegate] && [self.delegate respondsToSelector:@selector(failedReAuthenticationOperation:error:)]){
        [self.delegate failedReAuthenticationOperation:reAuthenticationMessage
                                                 error:error];
    } else {
        NSLog(@"[W]No delegate found for IPNetworkLayer instance");
    }
    
}

@end
