//
//  SATResult.h
//  NYCSchools
//
//  Created by Gavin Li on 4/23/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SATResult : NSObject

@property NSString * dbn;
@property NSUInteger numTestTakers;
@property NSUInteger readingAvgScore;
@property NSUInteger mathAvgScore;
@property NSUInteger writingAvgScore;

@end

NS_ASSUME_NONNULL_END
