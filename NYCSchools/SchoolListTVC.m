//
//  SchoolListTVC.m
//  NYCSchools
//
//  Created by Gavin Li on 4/21/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

#import "SchoolListTVC.h"
#import "SchoolDetailVC.h"
#import "SchoolTableViewCell.h"
#import "School.h"
#import "SATResult.h"
#import "QueryService.h"

@class SchoolDetailVC;

@interface SchoolListTVC ()

@property NSMutableArray* schoolList;
@property NSArray* satScoreList;
@property QueryService* schoolQueryService;
@property QueryService* scoreQueryService;

@end

@implementation SchoolListTVC

static void* globalKVOContext = &globalKVOContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.clearsSelectionOnViewWillAppear = NO; // preserve selection between presentations
    self.title = @"NYC Schools";
    
    self.schoolQueryService = [[QueryService alloc] init];
    [self.schoolQueryService
     parseJSONFrom:@"https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
     parsingSchool:YES
     completionClosure:^void (NSMutableArray* parsedSchools, NSString* errorMessage) {
        self.schoolList = parsedSchools;
        if (errorMessage) {
            NSLog(@"QueryService Error = %@", errorMessage);
        }
        [self.tableView reloadData];
    }];
    
    self.scoreQueryService = [[QueryService alloc] init];
    [self.scoreQueryService
     parseJSONFrom:@"https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
     parsingSchool:NO
     completionClosure:^void (NSMutableArray* parsedScores, NSString* errorMessage) {
        self.satScoreList = [parsedScores copy];
        if (errorMessage) {
            NSLog(@"QueryService Error = %@", errorMessage);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.schoolList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"schoolTableCell" forIndexPath:indexPath];
    
    School *curSchool = [self.schoolList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = curSchool.name;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"showSchoolDetails"]) {
         NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
         if (selectedIndexPath != nil) {
             SchoolDetailVC *dvc = [segue destinationViewController];
             School *curSchool = [self.schoolList objectAtIndex:selectedIndexPath.row];
             dvc.school = curSchool;
             
             [self addObserver:dvc forKeyPath:@"satScoreList" options:NSKeyValueObservingOptionNew context:globalKVOContext];
             dvc.KVOContext = globalKVOContext;
             if (self.satScoreList) {
                 dvc.scores = self.satScoreList;
                 [self removeObserver:dvc forKeyPath:@"satScoreList"];
             }
         }
     }
 }

@end
