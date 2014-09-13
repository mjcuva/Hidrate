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
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"full-gradient-background.png"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    [self.tableView setContentOffset:CGPointMake(0, 80) animated:YES];
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}


- (IBAction)continue {
    int age = [self.enterAge.text intValue];
    double weight = [self.enterWeight.text doubleValue];
    int feet = [self.enterFeet.text intValue];
    int inches = [self.enterInches.text intValue];
    if(age == 0 || weight == 0 || feet == 0 || inches == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Data" message:@"You must complete all the fields" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }else{
        [self performSegueWithIdentifier:@"showToday" sender:self];
    }
}

@end
