//
//  IPMessageURLJSONEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageURLJSONEntity.h"
#import "NSObject+IPQueueDispatcher.h"

@implementation IPMessageURLJSONEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"baseURL":@"baseURL"
             ,@"path":@"path"};
}

@end
