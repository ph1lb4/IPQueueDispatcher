//
//  IPQueueDispatcherProtocol.h
//  Pods
//
//  Created by Ilias Pavlidakis on 16/06/2016.
//
//

#import <Foundation/Foundation.h>

@protocol IPQueueDispatcherProtocol <NSObject>

- (void)defaultAction:(IPMessageJSONEntity *)message
formattedResponseObject:(id)formattedResponseObject
       responseObject:(id)responseObject;

@end