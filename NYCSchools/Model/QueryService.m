//
//  QueryService.m
//  NYCSchools
//
//  Created by Gavin Li on 4/22/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import "QueryService.h"
#import "School.h"
#import "SATResult.h"

@interface QueryService ()

@property NSURLSession* defaultSession;
@property NSURLSessionDataTask* dataTask;
@property NSString* errorMessage;

@end

@implementation QueryService

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject];
        self.schools = [NSMutableArray array];
        self.scores = [NSMutableArray array];
    }
    return self;
}

- (void)parseJSONFrom:(NSString *)jsonUrl parsingSchool:(BOOL)parsingSchool completionClosure:(QueryResult)completion {
    self.errorMessage = nil;
    NSURL *url = [NSURL URLWithString:jsonUrl];
    
    __weak __typeof(self) weakSelf = self;
    self.dataTask =
    [self.defaultSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error) {
            weakSelf.errorMessage =
            [NSString stringWithFormat:@"%@/%@/%@", @"DataTask error: ", error.localizedDescription, @"\n"];
        } else if (data && response && [(NSHTTPURLResponse *)response statusCode] == 200) {
            //            NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            if (parsingSchool) {
                [weakSelf parseJSONDataToSchoolObj:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![[NSThread currentThread] isMainThread]) {
                        NSLog(@"Not in main thread--completion handler");
                    }
                    completion(weakSelf.schools, weakSelf.errorMessage);
                });
            } else {
                
                [weakSelf parseJSONDataToScoreObj:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![[NSThread currentThread] isMainThread]) {
                        NSLog(@"Not in main thread--completion handler");
                    }
                    completion(weakSelf.scores, weakSelf.errorMessage);
                });
            }
        }
    }];
    
    [self.dataTask resume];
}

- (void)parseJSONDataToSchoolObj:(NSData *)data {
    [self.schools removeAllObjects];
    
    NSError *jsonError = nil;
    NSArray* jsonSchools = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if (jsonError) {
        if (!self.errorMessage) {
            self.errorMessage = @"";
        }
        self.errorMessage =
        [NSString stringWithFormat:@"%@/%@/%@", self.errorMessage, jsonError.localizedDescription, @"\n"];
        return;
    }
    
    /*
     // Can check for the type of the top level object here. In our case, no need to check, as options:0.
     if ([jsonSchools isKindOfClass:[NSDictionary class]]) {
     NSDictionary *deserializedDictionary = (NSDictionary *)jsonSchools;
     } else if ([jsonSchools isKindOfClass:[NSArray class]]) {
     NSArray *deserializedArray = (NSArray *)jsonSchools;
     }
     */
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    for (NSDictionary *schoolInfo in jsonSchools) {
        School *aSchool = [[School alloc] init];
        aSchool.dbn = schoolInfo[@"dbn"];
        aSchool.name = schoolInfo[@"school_name"];
        aSchool.overview = schoolInfo[@"overview_paragraph"];
        aSchool.location = schoolInfo[@"location"];
        aSchool.phoneNumber = schoolInfo[@"phone_number"];
        aSchool.email = schoolInfo[@"school_email"];
        aSchool.website = schoolInfo[@"website"];
        aSchool.city = schoolInfo[@""];
        
        NSString *totalStudentsStr;
        if ([schoolInfo[@"total_students"] isEqual:[NSNull null]]) {
            totalStudentsStr = @"";
        } else {
            totalStudentsStr = [schoolInfo[@"total_students"] description];
        }
        aSchool.totalStudents = [[formatter numberFromString:totalStudentsStr] unsignedIntegerValue];
        
        [self.schools addObject:aSchool];
    }
}

- (void)parseJSONDataToScoreObj:(NSData *)data {
    [self.scores removeAllObjects];
    
    NSError *jsonError = nil;
    NSArray* jsonSchools = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if (jsonError) {
        if (!self.errorMessage) {
            self.errorMessage = @"";
        }
        self.errorMessage =
        [NSString stringWithFormat:@"%@/%@/%@", self.errorMessage, jsonError.localizedDescription, @"\n"];
        return;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    for (NSDictionary *scoreInfo in jsonSchools) {
        SATResult *aScore = [[SATResult alloc] init];
        aScore.dbn = scoreInfo[@"dbn"];
        
        NSString* numTestTakersStr = [scoreInfo[@"num_of_sat_test_takers"] description];
        NSString* readingAvgScoreStr = [scoreInfo[@"sat_critical_reading_avg_score"] description];
        NSString* mathAvgScoreStr = [scoreInfo[@"sat_math_avg_score"] description];
        NSString* writingAvgScoreStr = [scoreInfo[@"sat_writing_avg_score"] description];
        
        aScore.numTestTakers = [[formatter numberFromString:numTestTakersStr] unsignedIntegerValue];
        aScore.readingAvgScore = [[formatter numberFromString:readingAvgScoreStr] unsignedIntegerValue];
        aScore.mathAvgScore = [[formatter numberFromString:mathAvgScoreStr] unsignedIntegerValue];
        aScore.writingAvgScore = [[formatter numberFromString:writingAvgScoreStr] unsignedIntegerValue];
        
        [self.scores addObject:aScore];
    }
}

@end
