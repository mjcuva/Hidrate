//
//  HiTodayViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiTodayViewController.h"
#import "PTDBeanManager.h"
#import "HiAppDelegate.h"
#import "Day.h"
#import "User.h"

@interface HiTodayViewController ()<PTDBeanManagerDelegate, PTDBeanDelegate>
@property (strong, nonatomic) PTDBeanManager *beanManager;
@property (strong, nonatomic) PTDBean *connectedBean;
@property (weak, nonatomic) IBOutlet UIView *waterView;
@end

@implementation HiTodayViewController

const int LOW_WATER_PX = 383;
const int HIGH_WATER_DIFF_PX = 284;

- (void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager
{
    if (self.beanManager.state == BeanManagerState_PoweredOn) {
        // if we're on, scan for advertisting beans
        NSError *error;
        [self.beanManager startScanningForBeans_error:&error];
        if (error) {
            DDLogError(@"Error in beanManagerDidUpdateState: %@", error);
        }
    } else if (self.beanManager.state == BeanManagerState_PoweredOff) {
        // do something else
    }
}

// bean discovered
- (void)BeanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)bean error:(NSError *)error
{
    if (error) {
        return;
    }

    if (self.connectedBean == nil && [bean.name isEqualToString:@"The Big Bean"]) {
        NSError *error;
        [self.beanManager connectToBean:bean error:&error];
        if (error) {
            DDLogError(@"Error in didDiscoverBean: %@", error);
        }
        self.connectedBean = bean;
        bean.delegate = self;
    }
}

- (void)BeanManager:(PTDBeanManager *)beanManager didDisconnectBean:(PTDBean *)bean error:(NSError *)error
{
    [self.connectedBean setLedColor:nil];
}

// bean connected
- (void)BeanManager:(PTDBeanManager *)beanManager didConnectToBean:(PTDBean *)bean error:(NSError *)error
{
    if (error) {
        return;
    }
    // do stuff with your bean
    // Send twice due to bug
    [self fetchData];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(fetchData) userInfo:nil repeats:YES];
}

- (void)fetchData
{
    [self.connectedBean sendSerialString:@"0"];
    [self.connectedBean sendSerialString:@"0"];
}

- (void)bean:(PTDBean *)bean serialDataReceived:(NSData *)data
{
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    float drank = stringData.floatValue;

    float amt = drank / 7.5 / 60 * 33.8 * 2.4;

    Day *d = [self getToday];
    User *u = [self getUser];

    float newDrank = d.amountDrank + amt;
    d.amountDrank = newDrank;
    float inLiter = newDrank / 33.814;

    float percent = (inLiter / (u.dailyWaterNeed / 1000)) * 100;

    float left = (u.dailyWaterNeed / 1000) - inLiter;

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setWaterPercentConsumed:(int)percent];
        [self setBottlesRemaining:left];
    }];

    DDLogInfo(@"AMOUNT DRANK %f", d.amountDrank);

    [self saveDay:d];

    DDLogVerbose(@"Received data: %f", drank);
}

- (void)saveDay:(Day *)day
{
    NSManagedObjectContext *context =
        ((HiAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    [context save:NULL];
}

- (Day *)getToday
{
    NSManagedObjectContext *context =
        ((HiAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;

    NSCalendar *cal = [[NSCalendar alloc] init];
    NSDateComponents *components = [cal components:0 fromDate:[NSDate date]];
    int year = (int)[components year];
    int month = (int)[components month];
    int day = (int)[components day];

    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    fr.predicate = [NSPredicate predicateWithFormat:@"day=%i AND month=%i AND year=%i", day, month, year];

    NSArray *results = [context executeFetchRequest:fr error:NULL];
    if (results.count == 0) {
        Day *dayObj = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
        dayObj.day = day;
        dayObj.year = year;
        dayObj.month = month;
        dayObj.amountDrank = 0;
        [context save:NULL];
        return dayObj;
    } else {
        return results[0];
    }
}

- (User *)getUser
{
    NSManagedObjectContext *context =
        ((HiAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray *results = [context executeFetchRequest:fr error:NULL];
    return results[0];
}

- (void)viewDidLoad
{
    [[self navigationItem] setHidesBackButton:YES];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self]; });

    [[self navigationItem]
        setTitleView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidrate-logo-navbar.png"]]];
}

- (void)viewDidLayoutSubviews
{
    Day *today = [self getToday];
    User *u = [self getUser];
    if (today.amountDrank != 0) {
        int waterPercentConsumed = ((today.amountDrank / 33.814) / (u.dailyWaterNeed / 1000)) * 100;
        [self setWaterPercentConsumed:waterPercentConsumed];
        float left = (u.dailyWaterNeed / 1000) - (today.amountDrank / 33.814);
        [self setBottlesRemaining:left];
    }
}

- (void)setWaterPercentConsumed:(int)percent
{
    if (percent >= 100) {
        percent = 100;
        [[self checkmarkImage] setHidden:NO];
        [[self waterPercentLabel] setHidden:YES];
    } else {
        [[self waterPercentLabel] setText:[NSString stringWithFormat:@"%d%%", percent]];
        [[self checkmarkImage] setHidden:YES];
        [[self waterPercentLabel] setHidden:NO];
    }
    int waves_pos = LOW_WATER_PX - ((HIGH_WATER_DIFF_PX * percent) / 100);
    [[self wavesImage] setFrame:CGRectMake(26, waves_pos, 261, 302)];
}

- (void)setBottlesRemaining:(float)bottles
{
    int bottlesX4 = bottles * 4;
    int quarters = bottlesX4 % 4;
    NSString *quartersText = @"";
    if (quarters == 1) {
        quartersText = @"¼";
    } else if (quarters == 2) {
        quartersText = @"½";
    } else if (quarters == 3) {
        quartersText = @"¾";
    }

    NSString *bottleText;
    if (bottles <= 0.0) {
        bottleText = @"You're done!\nGreat job.";
    } else if (bottles < 1 && quarters == 0) {
        bottleText = @"Just a little\nbit more!";
    } else if (bottles < 1) {
        bottleText = [NSString stringWithFormat:@"Just %@ of a\nbottle left!", quartersText];
    } else if (bottles < 2 && quarters == 0) {
        bottleText = [NSString stringWithFormat:@"About %d%@ more\nbottle to go", (int)bottles, quartersText];
    } else {
        bottleText = [NSString stringWithFormat:@"About %d%@ more\nbottles to go", (int)bottles, quartersText];
    }
    [[self waterBottlesLabel] setText:bottleText];
}

- (IBAction)sendTestNotification:(UIButton *)sender
{
    DDLogVerbose(@"Sending test notification.");
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
    localNotification.alertBody = @"Hi! It's time to drink more water.";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (IBAction)clearTodayProgress:(UIButton *)sender
{
    Day *d = [self getToday];
    User *u = [self getUser];
    d.amountDrank = 0;
    [self saveDay:d];
    [self setWaterPercentConsumed:0];
    float left = (u.dailyWaterNeed / 1000) - (d.amountDrank / 33.814);
    [self setBottlesRemaining:left];
}

- (IBAction)unwindToToday:(UIStoryboardSegue *)segue
{
}

@end
