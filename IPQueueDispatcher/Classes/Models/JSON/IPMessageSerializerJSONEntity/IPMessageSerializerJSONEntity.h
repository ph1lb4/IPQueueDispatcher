//
//  IPMessageSerializerJSONEntity.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface IPMessageSerializerJSONEntity : NSObject

typedef NS_ENUM(NSInteger, IPMessageRequestSerializerType) {
    IPMessageRequestSerializerTypeHTTP = 0,
    IPMessageRequestSerializerTypeJSON,
    IPMessageRequestSerializerTypePropertyList,
};

typedef NS_ENUM(NSInteger, IPMessageResponseSerializerType) {
    IPMessageResponseSerializerTypeHTTP = 0,
    IPMessageResponseSerializerTypeJSON,
    IPMessageResponseSerializerTypeXML,
    IPMessageResponseSerializerTypePropertyList,
    IPMessageResponseSerializerTypeImage,
    IPMessageResponseSerializerTypeCompound,
};

@property (nullable, nonatomic) NSNumber *responseSerializerID;
@property (nullable, nonatomic) NSString *requestSerializerClass;
@property (nullable, nonatomic) NSNumber *requestSerializerID;
@property (nullable, nonatomic) NSString *responseSerializerClass;
@end