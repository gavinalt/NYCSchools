//
//  NYCSchoolsTests.m
//  NYCSchoolsTests
//
//  Created by Gavin Li on 4/21/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QueryService.h"
#import "SATResult.h"

@interface NYCSchoolsTests : XCTestCase

@end

@implementation NYCSchoolsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testQueryService {
    QueryService *queryService = [[QueryService alloc] init];
    
    NSString *json = @"[{"
    "\"dbn\": \"02M374\","
    "\"school_name\": \"GRAMERCY ARTS HIGH SCHOOL\","
    "\"num_of_sat_test_takers\": \"60\","
    "\"sat_critical_reading_avg_score\": \"391\","
    "\"sat_math_avg_score\": \"391\","
    "\"sat_writing_avg_score\": \"394\""
    "}]";
    NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [queryService parseJSONDataToScoreObj:jsonData];
    SATResult *aScore = [queryService.scores objectAtIndex:0];
    XCTAssertTrue([aScore.dbn isEqualToString:@"02M374"]);
    XCTAssertEqual(aScore.numTestTakers, 60);
    XCTAssertEqual(aScore.readingAvgScore, 391);
    XCTAssertEqual(aScore.mathAvgScore, 391);
    XCTAssertEqual(aScore.writingAvgScore, 394);
}

@end
