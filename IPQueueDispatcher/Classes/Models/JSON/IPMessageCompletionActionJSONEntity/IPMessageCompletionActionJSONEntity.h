//
//  IPMessageCompletionActionJSONEntity.h
//  Pods
//
//  Created by Ilias Pavlidakis on 15/06/2016.
//
//

#import <Foundation/Foundation.h>

@interface IPMessageCompletionActionJSONEntity : NSObject

typedef NS_ENUM(NSInteger, IPMessageCompetionActionType) {
    IPMessageCompetionActionTypeAll = 0,
    IPMessageCompetionActionTypeSuccess,
    IPMessageCompetionActionTypeFailure,
    IPMessageCompetionActionTypeNoConnection,
};

@property (nullable, nonatomic) NSNumber *completionActionType;
@property (nullable, nonatomic) NSNumber *includeRawResponse;
@end
