//
//  IPNetworkLayerProtocol.h
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestSerializer, IPMessageJSONEntity;

@protocol IPNetworkLayerProtocol <NSObject>

@optional

#pragma mark - Response Results

- (void)successfulOperation:(IPMessageJSONEntity *)message
    formattedResponseObject:(id)formattedResponseObject
             responseObject:(id)responseObject;

- (void)failedOperation:(IPMessageJSONEntity *)message
                  error:(NSError *)error;

- (void)noInternetOperation:(IPMessageJSONEntity *)message;

#pragma mark - Authentication

- (void)authenticationDataForRequestSerializer:(AFHTTPRequestSerializer *)serializer
                                          path:(NSString *)path;

#pragma mark - Re Authentication

- (IPMessageJSONEntity *)reAuthenticate;

- (void)successfulReAuthenticationOperation:(IPMessageJSONEntity *)message
                    formattedResponseObject:(id)formattedResponseObject
                             responseObject:(id)responseObject;

- (void)failedReAuthenticationOperation:(IPMessageJSONEntity *)message
                                  error:(NSError *)error;

@end