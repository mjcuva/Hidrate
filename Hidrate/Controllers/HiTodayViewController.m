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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)debugSliderChanged:(UISlider *)sender
{
    [[self waterPercentLabel] setText:[NSString stringWithFormat:@"%d%%", (int)[sender value]]];
}

- (IBAction)unwindToToday:(UIStoryboardSegue *)segue
{
}

@end
