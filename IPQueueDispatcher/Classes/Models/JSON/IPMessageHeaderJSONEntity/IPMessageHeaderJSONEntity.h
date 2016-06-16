//
//  IPMessageHeaderJSONEntity.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface IPMessageHeaderJSONEntity : NSObject
@property (nullable, nonatomic) NSString *content;
@property (nullable, nonatomic) NSString *name;
@property (nullable, nonatomic) NSNumber *ommitEmptyValue;

- (BOOL)isValid;

@end
