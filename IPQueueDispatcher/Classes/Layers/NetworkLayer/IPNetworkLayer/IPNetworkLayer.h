//
//  IPNetworkLayer.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestSerializer, IPMessageJSONEntity;

@protocol IPNetworkLayerProtocol <NSObject>

@optional

- (IPMessageJSONEntity *)reAuthenticate;

- (void)reAuthenticatedSuccessfully:(id)responseObject;

- (void)reAuthenticatedFailed:(NSError *)error;

- (void)successfulOperation:(NSString *)path
                 identifier:(NSInteger)identifier
                   response:(id)response
                 parameters:(NSDictionary *)parameters;

- (void)failedOperation:(NSString *)path
             identifier:(NSInteger)identifier
                  error:(NSError *)error;

- (void)noInternetOperation:(NSString *)path
                 identifier:(NSInteger)identifier;

- (void)authenticationDataForRequestSerializer:(AFHTTPRequestSerializer *)serializer
                                          path:(NSString *)path;

@end

@interface IPNetworkLayer : NSObject

typedef void (^IPNetworkLayerSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^IPNetworkLayerFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@property (nonatomic) NSString *baseURL;
@property (nonatomic) id<IPNetworkLayerProtocol> delegate;

- (instancetype)initWithDelegate:(id<IPNetworkLayerProtocol>)delegate
                         baseURL:(NSString *)baseURL;

#pragma mark - Queue Handlers

- (void)stopAll;

- (void)pauseAll;

- (void)resume;

#pragma mark - Perform Requests

- (void)jsonGET:(NSString *)path
     identifier:(NSInteger)identifier
     parameters:(NSDictionary *)parameters
        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)jsonPOST:(NSString *)path
      identifier:(NSInteger)identifier
      parameters:(NSDictionary *)parameters
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)jsonPUT:(NSString *)path
     identifier:(NSInteger)identifier
     parameters:(NSDictionary *)parameters
        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)jsonDELETE:(NSString *)path
        identifier:(NSInteger)identifier
        parameters:(NSDictionary *)parameters
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end