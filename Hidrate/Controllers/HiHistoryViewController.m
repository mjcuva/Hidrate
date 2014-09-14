//
//  HiHistoryViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiHistoryViewController.h"

@interface HiHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HiHistoryViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 13 days of historical data
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dailyAmounts = @[ @100, @100, @100, @100, @100, @100, @100, @63, @45, @89, @100, @28, @4 ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];

    // Generate date history
    long dayNum = [indexPath row];
    NSNumber *dailyAmount = dailyAmounts[dayNum];
    if ([dailyAmount integerValue] == 100) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    // Generate a past date for each row
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:2014];
    [comp setMonth:9];
    [comp setDay:13];
    NSDate *today = [[NSCalendar currentCalendar] dateFromComponents:comp];
    NSDate *date = [today dateByAddingTimeInterval:-1 * 60 * 60 * 24 * dayNum];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d"];

    // Put text into cell
    [[cell textLabel] setText:[formatter stringFromDate:date]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d%%", (int)[dailyAmount integerValue]]];
    return cell;
}

@end
