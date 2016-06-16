//
//  IPBackEndLayer.m
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#import "IPBackEndLayer.h"
#import "NSString+IPQueueDispatcher.h"

@implementation IPBackEndLayer

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Helpers

- (void)registerForNoticationListener:(NSString *)notificationName
                             selector:(NSString *)selector
{
    if ([NSString isNotEmpty:notificationName] && [NSString isNotEmpty:selector]){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:NSSelectorFromString(selector)
                                                     name:notificationName
                                                   object:nil];
    }
}

#pragma mark - Authentication

- (void)authenticationDataForRequestSerializer:(AFHTTPRequestSerializer *)serializer
                                          path:(NSString *)path
{
    NSLog(@"[W]authenticationDataForRequestSerializer:path is not implemented");
}

#pragma mark - Re Authentication

- (IPMessageJSONEntity *)reAuthenticate
{
    NSLog(@"[W]reAuthenticate is not implemented");
}

@end