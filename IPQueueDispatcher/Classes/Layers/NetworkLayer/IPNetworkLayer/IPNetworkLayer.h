//
//  IPNetworkLayer.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>
#import "IPNetworkLayerProtocol.h"

@interface IPNetworkLayer : NSObject

typedef void (^IPNetworkLayerSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^IPNetworkLayerFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@property (nonatomic, readonly) NSString *baseURL;
@property (nonatomic) id<IPNetworkLayerProtocol> delegate;

- (instancetype)initWithBaseURL:(NSString *)baseURL;

#pragma mark - Queue Handlers

- (void)stopAll;

- (void)pauseAll;

- (void)resume;

#pragma mark - Response format

- (id)formatResponseObject:(id)responseObject
                  actionID:(NSNumber *)actionID;

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