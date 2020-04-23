//
//  SchoolDetailVC.h
//  NYCSchools
//
//  Created by Gavin Li on 4/23/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class School;

@interface SchoolDetailVC : UIViewController

@property School *school;
@property NSArray *scores;
@property void *KVOContext;

- (void)configureView:(School *)school;

- (NSString *)getSATScoreFor:(NSString *)schoolDbn;

@end

NS_ASSUME_NONNULL_END
