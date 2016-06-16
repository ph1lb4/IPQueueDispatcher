//
//  IPMessageURLEntity.m
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import "IPMessageURLEntity.h"
#import "IPMessageEntity.h"

@implementation IPMessageURLEntity

- (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"baseURL":@"baseURL"
             ,@"path":@"path"};
}

@end
