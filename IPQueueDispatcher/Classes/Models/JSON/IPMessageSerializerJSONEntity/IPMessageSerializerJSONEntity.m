//
//  IPMessageSerializerJSONEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageSerializerJSONEntity.h"
#import "NSObject+IPQueueDispatcher.h"

@implementation IPMessageSerializerJSONEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"responseSerializerID":@"responseSerializerID",
             @"requestSerializerClass":@"requestSerializerClass",
             @"requestSerializerID":@"requestSerializerID",
             @"responseSerializerClass":@"responseSerializerClass",
             };
}

@end
