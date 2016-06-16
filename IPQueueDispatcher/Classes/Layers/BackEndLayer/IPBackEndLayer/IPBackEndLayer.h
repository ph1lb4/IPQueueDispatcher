//
//  IPBackEndLayer.h
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#import <Foundation/Foundation.h>
#import "IPNetworkLayerProtocol.h"

@class IPDataLayer;

@interface IPBackEndLayer : NSObject<IPNetworkLayerProtocol>

@property (nonatomic, strong) IPDataLayer *dataLayer;

#pragma mark - Notification Helpers

- (void)registerForNoticationListener:(NSString *)notificationName
                             selector:(NSString *)selector;

@end