//
//  IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>
#import "IPNetworkLayerProtocol.h"

@class NSManagedObjectContext, NSManagedObjectModel, IPNetworkLayer, IPBackEndLayer;

FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultMessageKey;
FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultFormattedResponseKey;
FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultRawResponseKey;
FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultErrorKey;

@interface IPQueueDispatcher : NSObject<IPNetworkLayerProtocol>

typedef NS_ENUM(NSInteger, IPFetchRequests) {
    IPFetchRequestCollectValidMessages = 0,
    IPFetchRequestHighPriorityMessages,
    IPFetchRequestLowPriorityMessages,
    IPFetchRequestGreaterOrEqualThanNormal,
    IPFetchRequestNormalPriorityMessages,
    IPFetchRequestStickyMessages,
};

@property (nonatomic, strong) IPNetworkLayer *networkLayer;
@property (nonatomic, strong) IPBackEndLayer *backEndLayer;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                          managedObjectModel:(NSManagedObjectModel *)model;

- (void)highPriorityMessageAdded;

@end