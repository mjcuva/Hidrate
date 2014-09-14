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

@interface HiTodayViewController ()<PTDBeanManagerDelegate, PTDBeanDelegate>
@property (strong, nonatomic) PTDBeanManager *beanManager;
@property (strong, nonatomic) PTDBean *connectedBean;
@property (weak, nonatomic) IBOutlet UIView *waterView;
@end

@implementation HiTodayViewController

const int LOW_WATER_PX = 383;
const int HIGH_WATER_DIFF_PX = 284;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(fetchData) userInfo:nil repeats:YES];
    [bean setLedColor:nil];
    
}

- (void)fetchData{
    [self.connectedBean sendSerialString:@"DATA PLZ"];
    [self.connectedBean sendSerialString:@"DATA PLZ"];
}

- (void)bean:(PTDBean *)bean serialDataReceived:(NSData *)data
{
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    float drank = stringData.floatValue * 2;
    
    Day *d = [self getToday];
    
    float newDrank = d.amountDrank + drank;
    float inLiter = newDrank / 33.814;
    
    float percent = (inLiter/2.2) * 100;
    [self setWaterPercentConsumed:(int)percent];
    
    DDLogVerbose(@"Received data: %f", drank);
}

- (Day *)getToday{
    NSManagedObjectContext *context = ((HiAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSCalendar *cal = [[NSCalendar alloc] init];
    NSDateComponents *components = [cal components:0 fromDate:[NSDate date]];
    int year = (int)[components year];
    int month = (int)[components month];
    int day = (int)[components day];
    
    
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    fr.predicate = [NSPredicate predicateWithFormat:@"day=%i AND month=%i AND year=%i", day, month, year];
    
    NSArray *results = [context executeFetchRequest:fr error:NULL];
    if(results.count == 0){
        Day *dayObj = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
        dayObj.day = day;
        dayObj.year = year;
        dayObj.month = month;
        dayObj.amountDrank = 0;
        [context save:NULL];
        return dayObj;
    }else{
        return results[0];
    }
}

- (void)viewDidLoad
{
    [[self navigationItem] setHidesBackButton:YES];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self]; });
    
    Day *today = [self getToday];
    if(today.amountDrank != 0){
        [self setWaterPercentConsumed:(2.2/today.amountDrank) * 100];
    }
    
}

- (void)setWaterPercentConsumed:(int)percent
{
    [[self waterPercentLabel] setText:[NSString stringWithFormat:@"%d%%", percent]];
    int waves_pos = LOW_WATER_PX - ((HIGH_WATER_DIFF_PX * percent) / 100);
    [[self wavesImage] setFrame:CGRectMake(26, waves_pos, 261, 302)];
    [self.waterPercentLabel setNeedsDisplay];
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
        bottleText = [NSString stringWithFormat:@"Just %d%@ of a\nbottle left!", (int)bottles, quartersText];
    } else if (bottles < 2 && quarters == 0) {
        bottleText = [NSString stringWithFormat:@"About %d%@ more\nbottle to go", (int)bottles, quartersText];
    } else {
        bottleText = [NSString stringWithFormat:@"About %d%@ more\nbottles to go", (int)bottles, quartersText];
    }
    [[self waterBottlesLabel] setText:bottleText];
}

- (IBAction)unwindToToday:(UIStoryboardSegue *)segue
{
}

@end
