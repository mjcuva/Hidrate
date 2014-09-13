//
//  HiHistoryTableViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiHistoryTableViewController.h"
#import "HiAppDelegate.h"
#import "Day.h"

@interface HiHistoryTableViewController ()
@property (strong, nonatomic) NSArray *days;
@end

@implementation HiHistoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSManagedObjectContext *context =
        ((HiAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Day"];
    NSSortDescriptor *daySort = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:NO];
    NSSortDescriptor *monthSort = [[NSSortDescriptor alloc] initWithKey:@"month" ascending:NO];
    NSSortDescriptor *yearSort = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:NO];
    fr.sortDescriptors = @[ daySort, monthSort, yearSort ];

    self.days = [context executeFetchRequest:fr error:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Current Streak";
    } else {
        return @"Past Hydration";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 1 row for streak, 14 rows of historical data
    if (section == 0) {
        return 1;
    } else {
        return 14;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];

    // First section is the streak, second section is the history data
    if ([indexPath section] == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[cell textLabel] setText:@"7 day streak"];
        [[cell detailTextLabel] setText:@"Awesome!"];
        return cell;
    }

    // Generate date history
    BOOL dayWasSuccess = (arc4random() % 5) < 4;
    long dayNum = [indexPath row];
    if (dayNum < 7) {
        dayWasSuccess = YES;
    } else if (dayNum == 7) {
        dayWasSuccess = NO;
    }

    // Generate amount of water drank for each day or add checkmark to 100% rows
    int dayWaterAmount;
    if (dayWasSuccess) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        dayWaterAmount = 100;
    } else {
        dayWaterAmount = arc4random() % 100;
    }

    // Generate a past date for each row
    NSDate *today = [NSDate date];
    NSDate *date = [today dateByAddingTimeInterval:-1 * 60 * 60 * 24 * (dayNum + 1)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d"];

    // Put text into cell
    [[cell textLabel] setText:[formatter stringFromDate:date]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d%%", dayWaterAmount]];
    return cell;
}

@end
