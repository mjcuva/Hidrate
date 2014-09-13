//
//  HiHistoryTableViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiHistoryTableViewController.h"
#import "HiAppDelegate.h"

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
    
    NSManagedObjectContext *context = ((HiAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Day"];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    fr.sortDescriptors = @[dateSort];
    
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
    if (section == 0) {
        return 1;
    } else {
        return self.days.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    if ([indexPath section] == 0) {
        [[cell textLabel] setText:@"7 day streak"];
        [[cell detailTextLabel] setText:@"Awesome!"];
        return cell;
    }

    BOOL dayWasSuccess = (arc4random() % 5) < 4;
    int dayWaterAmount;
    if (dayWasSuccess) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        dayWaterAmount = 100;
    } else {
        dayWaterAmount = arc4random() % 100;
    }
    [[cell textLabel] setText:[self.days[indexPath.item] description]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d%%", dayWaterAmount]];
    return cell;
}

@end
