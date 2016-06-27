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

/**
 *  Executed message will be stored under that on the posted notification
 */
FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultMessageKey;

/**
 *  Formatted received response will be stored under that on the posted notification
 */
FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultFormattedResponseKey;

/**
 *  Raw receievd response will be stored under that on the posted notification
 */
FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultRawResponseKey;

/**
 *  Message's execution error will be stored under that on the posted notification
 */
FOUNDATION_EXPORT NSString *const IPQueueDispatcherDelegateResultErrorKey;

/**
 *  This class is responsible to create & maintain & execute a serial queue where objects of type IPMessageJSONEntity can be added
 */
@interface IPQueueDispatcher : NSObject<IPNetworkLayerProtocol>

/**
 *  Defines the type of messages the dispatcher will retrieve
 */
typedef NS_ENUM(NSInteger, IPFetchRequests) {
    /**
     *  As valid message you can consider any message that isInvalid flag is NO and the object is either sticky or endedAt field is nil OR maximumTries value is less than timesTried
     */
    IPFetchRequestCollectValidMessages = 0,
    /**
     *  High priority mesages are those who have the priority property assigned to IPMessagePriorityHigh
     */
    IPFetchRequestHighPriorityMessages,
    /**
     *  Low priority mesages are those who have the priority property assigned to IPMessagePriorityLow
     */
    IPFetchRequestLowPriorityMessages,
    /**
     *  GreaterOrEqual than normal priority mesages are those who have the priority property assigned to IPMessagePriorityNormal or IPMessagePriorityHigh
     */
    IPFetchRequestGreaterOrEqualThanNormal,
    /**
     *  Normal priority mesages are those who have the priority property assigned to IPMessagePriorityNormal
     */
    IPFetchRequestNormalPriorityMessages,
    /**
     *  Sticky messages are those that have the isSticky property assigned to YES
     */
    IPFetchRequestStickyMessages,
};

/**
 *  The responsible object to handle the network connections. Overridable
 */
@property (nonatomic, strong) IPNetworkLayer *networkLayer;

/**
 *  The responsible object to handle response delegates. Overridable
 */
@property (nonatomic, strong) IPBackEndLayer *backEndLayer;

/**
 *  Initializes a dispatcher object with the given model name and context
 *
 *  @param context The NSManagedObjectContext to use for reading and updating message objects on the storage
 *  @param model   The NSManagedObjectModel to use that describes the message objec representation on the storage and the related NSFetchRequests
 *
 *  @return the newly created instance
 */
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                          managedObjectModel:(NSManagedObjectModel *)model NS_DESIGNATED_INITIALIZER;

/**
 *  A trigger function that notifies the dispatcher that HighPriority messaged were added and require immediate execution
 */
- (void)highPriorityMessageAdded;

@end