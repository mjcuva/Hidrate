//
//  HiTodayViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiTodayViewController.h"

@interface HiTodayViewController ()

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

- (void)setWaterPercentConsumed:(int)percent
{
    [[self waterPercentLabel] setText:[NSString stringWithFormat:@"%d%%", percent]];
    int waves_pos = LOW_WATER_PX - ((HIGH_WATER_DIFF_PX * percent) / 100);
    [[self wavesImage] setFrame:CGRectMake(26, waves_pos, 261, 302)];
}

- (IBAction)debugSliderChanged:(UISlider *)sender
{
    [self setWaterPercentConsumed:[sender value]];
}

- (IBAction)unwindToToday:(UIStoryboardSegue *)segue
{
}

@end
