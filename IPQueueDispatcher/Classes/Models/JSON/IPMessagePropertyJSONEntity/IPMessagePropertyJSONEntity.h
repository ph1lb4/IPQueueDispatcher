//
//  IPMessagePropertyJSONEntity.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface IPMessagePropertyJSONEntity : NSObject
@property (nullable, nonatomic) NSNumber *includeInURL;
@property (nullable, nonatomic) id content;
@property (nullable, nonatomic) NSString *name;
@property (nullable, nonatomic) NSNumber *ommitEmptyValue;

- (BOOL)isValid;

@end