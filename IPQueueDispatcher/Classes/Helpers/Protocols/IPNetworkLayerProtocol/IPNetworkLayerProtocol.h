//
//  IPNetworkLayerProtocol.h
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestSerializer, IPMessageJSONEntity;

/**
 *  <#Description#>
 */
@protocol IPNetworkLayerProtocol <NSObject>

@optional

#pragma mark - Response Results

/**
 *  Called on delegate on a successful network action
 *
 *  @param message                 The executed message object
 *  @param formattedResponseObject The formatted response
 *  @param responseObject          The unformatted response
 */
- (void)successfulOperation:(IPMessageJSONEntity *)message
    formattedResponseObject:(id)formattedResponseObject
             responseObject:(id)responseObject;

/**
 *  Called on delegate on a failed network action except from no internet connection errors
 *
 *  @param message The executed message object
 *  @param error   The error occured
 */
- (void)failedOperation:(IPMessageJSONEntity *)message
                  error:(NSError *)error;

/**
 *  Called on delegate on a no internet network action
 *
 *  @param message The executed message object
 */
- (void)noInternetOperation:(IPMessageJSONEntity *)message;

#pragma mark - Authentication

/**
 *  Called on the delegate
 *
 *  @param serializer <#serializer description#>
 *  @param path       <#path description#>
 */
- (void)authenticationDataForRequestSerializer:(AFHTTPRequestSerializer *)serializer
                                          path:(NSString *)path;

#pragma mark - Re Authentication

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (IPMessageJSONEntity *)reAuthenticate;

/**
 *  <#Description#>
 *
 *  @param message                 <#message description#>
 *  @param formattedResponseObject <#formattedResponseObject description#>
 *  @param responseObject          <#responseObject description#>
 */
- (void)successfulReAuthenticationOperation:(IPMessageJSONEntity *)message
                    formattedResponseObject:(id)formattedResponseObject
                             responseObject:(id)responseObject;

/**
 *  <#Description#>
 *
 *  @param message <#message description#>
 *  @param error   <#error description#>
 */
- (void)failedReAuthenticationOperation:(IPMessageJSONEntity *)message
                                  error:(NSError *)error;

@end