//
//  HiTodayViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiTodayViewController.h"
#import "PTDBeanManager.h"

@interface HiTodayViewController () <PTDBeanManagerDelegate>
@property (strong, nonatomic) PTDBeanManager *beanManager;
@property (strong, nonatomic) PTDBean *connectedBean;
@property (weak, nonatomic) IBOutlet UIView *waterView;
@end

@implementation HiTodayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager{
    if(self.beanManager.state == BeanManagerState_PoweredOn){
        // if we're on, scan for advertisting beans
        [self.beanManager startScanningForBeans_error:nil];
    }
    else if (self.beanManager.state == BeanManagerState_PoweredOff) {
        // do something else
    }
}

// bean discovered
- (void)BeanManager:(PTDBeanManager*)beanManager didDiscoverBean:(PTDBean*)bean error:(NSError*)error{
    if (error) {
        return;
    }
    if (self.connectedBean == nil) {
        [self.beanManager connectToBean:bean error:nil];
        self.connectedBean = bean;
    }
}

- (void)BeanManager:(PTDBeanManager *)beanManager didDisconnectBean:(PTDBean *)bean error:(NSError *)error{
    [self.connectedBean setLedColor:nil];
}

// bean connected
- (void)BeanManager:(PTDBeanManager*)beanManager didConnectToBean:(PTDBean*)bean error:(NSError*)error{
    if (error) {
        return;
    }
    // do stuff with your bean
}

- (void)viewDidLoad
{
    [[self navigationItem] setHidesBackButton:YES];
    
    self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
}

- (IBAction)unwindToToday:(UIStoryboardSegue *)segue
{
}

@end
