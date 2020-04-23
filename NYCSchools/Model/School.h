//
//  School.h
//  NYCSchools
//
//  Created by Gavin Li on 4/21/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface School : NSObject 

@property NSString* dbn;
@property NSString* name;
@property NSString* overview;
@property NSString* location;
@property NSString* phoneNumber;
@property NSString* email;
@property NSString* website;
@property NSUInteger totalStudents;
@property NSString* city;

@end

NS_ASSUME_NONNULL_END
