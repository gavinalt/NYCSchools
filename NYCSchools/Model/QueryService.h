//
//  QueryService.h
//  NYCSchools
//
//  Created by Gavin Li on 4/22/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QueryService : NSObject

typedef void (^QueryResult)(NSMutableArray*, NSString*);

@property NSMutableArray* schools;
@property NSMutableArray* scores;

- (void)parseJSONFrom:(NSString *)jsonUrl parsingSchool:(BOOL)parsingSchool completionClosure:(QueryResult)completion;

- (void)parseJSONDataToSchoolObj:(NSData *)data;
- (void)parseJSONDataToScoreObj:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
