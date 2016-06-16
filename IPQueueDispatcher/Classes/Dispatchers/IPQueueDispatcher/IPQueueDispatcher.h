//
//  IPQueueDispatcher.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext, NSManagedObjectModel, IPNetworkLayer;

@interface IPQueueDispatcher : NSObject

typedef NS_ENUM(NSInteger, IPFetchRequests) {
    IPFetchRequestCollectValidMessages = 0,
    IPFetchRequestHighPriorityMessages,
    IPFetchRequestLowPriorityMessages,
    IPFetchRequestGreaterOrEqualThanNormal,
    IPFetchRequestNormalPriorityMessages,
    IPFetchRequestStickyMessages,
};

@property (nonatomic, strong) IPNetworkLayer *networkLayer;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                          managedObjectModel:(NSManagedObjectModel *)model;

- (void)highPriorityMessageAdded;

@end