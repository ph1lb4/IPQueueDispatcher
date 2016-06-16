//
//  IPMessageSerializerEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageSerializerEntity.h"
#import "IPMessageEntity.h"

@implementation IPMessageSerializerEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"responseSerializerID":@"responseSerializerID",
             @"requestSerializerClass":@"requestSerializerClass",
             @"requestSerializerID":@"requestSerializerID",
             @"responseSerializerClass":@"responseSerializerClass",
             };
}

@end
