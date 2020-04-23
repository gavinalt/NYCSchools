//
//  SchoolDetailVC.m
//  NYCSchools
//
//  Created by Gavin Li on 4/23/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import "SchoolDetailVC.h"
#import "School.h"
#import "SATResult.h"
#import "QueryService.h"

@interface SchoolDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *overview;
@property (weak, nonatomic) IBOutlet UILabel *numStudents;
@property (weak, nonatomic) IBOutlet UILabel *satScore;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *website;

@end

@implementation SchoolDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.school.name;
    [self configureView:self.school];
}

- (void)configureView:(School *)school {
    self.name.text = [NSString stringWithFormat:@"%@%@", @"Name: ", school.name];
    self.overview.text = [NSString stringWithFormat:@"%@%@", @"Overview: ", school.overview];
    self.numStudents.text = [NSString stringWithFormat:@"%@%lu", @"Number of Students: ", (unsigned long)school.totalStudents];
    self.location.text = [NSString stringWithFormat:@"%@%@", @"Address: ", school.location];
    self.phoneNumber.text = [NSString stringWithFormat:@"%@%@", @"Phone Number: ", school.phoneNumber];
    self.website.text = [NSString stringWithFormat:@"%@%@", @"Website: ", school.website];
    
    self.satScore.text = [NSString stringWithFormat:@"%@%@", @"SAT Score: ", [self getSATScoreFor:school.dbn]];
}

- (NSString *)getSATScoreFor:(NSString *)schoolDbn {
    NSString *printableSATScore = @"";
    if (self.scores) {
        for (SATResult *aScore in self.scores) {
            if ([aScore.dbn isEqualToString:self.school.dbn]) {
                printableSATScore =
                [NSString stringWithFormat:@"\nReading: %lu, Math: %lu, Writing: %lu", (unsigned long)aScore.readingAvgScore, (unsigned long)aScore.mathAvgScore, (unsigned long)aScore.writingAvgScore];
                break;
            }
        }
    }
    return printableSATScore;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.KVOContext && context == self.KVOContext && [keyPath isEqualToString:@"satScoreList"]) {
        NSArray *passedScores = [change objectForKey:@"new"];
        self.scores = passedScores;
        self.satScore.text = [NSString stringWithFormat:@"%@%@", @"SAT Score: ", [self getSATScoreFor:self.school.dbn]];
        
        @try {
            [object removeObserver:self forKeyPath:keyPath];
        }
        @catch (NSException * __unused exception) {}
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
