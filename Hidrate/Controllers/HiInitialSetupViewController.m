//
//  HiInitialSetupViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiInitialSetupViewController.h"

@interface HiInitialSetupViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UITextField *enterAge;
@property (weak, nonatomic) IBOutlet UITextField *enterWeight;
@property (weak, nonatomic) IBOutlet UITextField *enterFeet;
@property (weak, nonatomic) IBOutlet UITextField *enterInches;
@end

@implementation HiInitialSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[self navigationItem] setHidesBackButton:YES];
}

- (IBAction)continue {
    NSLog(@"HERE");
}

@end
