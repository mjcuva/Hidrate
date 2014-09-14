//
//  HiInitialSetupViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiInitialSetupViewController.h"
#import "HiAppDelegate.h"
#import "User.h"

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
    self.tableView.backgroundColor =
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"full-gradient-background.png"]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    NSManagedObjectContext *context =
    ((HiAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fr = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [fr setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fr error:NULL];
    
    if(fetchedObjects.count == 1){
        User *u = fetchedObjects[0];
        self.enterAge.text = [NSString stringWithFormat:@"%i", u.age];
        self.enterFeet.text = [NSString stringWithFormat:@"%i", u.feet];
        self.enterInches.text = [NSString stringWithFormat:@"%i", u.inches];
        self.enterWeight.text = [NSString stringWithFormat:@"%.02f", u.weight];
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.tableView setContentOffset:CGPointMake(0, 80) animated:YES];
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

- (IBAction) continue
{
    int age = [self.enterAge.text intValue];
    double weight = [self.enterWeight.text doubleValue];
    int feet = [self.enterFeet.text intValue];
    int inches = [self.enterInches.text intValue];
    if (age == 0 || weight == 0 || feet == 0 || inches == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Data"
                                                        message:@"You must complete all the fields"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    } else {
        NSManagedObjectContext *context =
            ((HiAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;

        NSFetchRequest *fr = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        [fr setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fr error:NULL];

        if (fetchedObjects.count > 0) {
            for (User *u in fetchedObjects) {
                [context deleteObject:u];
            }
        }

        User *u = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        u.feet = feet;
        u.inches = inches;
        u.weight = weight;
        u.age = age;
        if (self.genderControl.selectedSegmentIndex == 0) {
            u.gender = @"Male";
        } else {
            u.gender = @"Female";
        }

        u.centimeters = 30.480*u.feet + 2.54*u.inches;
        
        if( [u.gender isEqualToString:@"Female"]){
            u.bmr = 447.593
                + 9.247*(u.weight*0.453) //bmr weight factor with lb->kg conversion
                + 3.098*u.centimeters     //bmr height factor
                - 4.330*u.age;            //bmr age factor
            
            if( age < 4 )
                u.dailyWaterNeed = 0.93 * u.bmr;
            else if( age < 9)
                u.dailyWaterNeed = 1.06 * u.bmr;
            else if( age < 14)
                u.dailyWaterNeed = 1.05 * u.bmr;
            else if( age < 19)
                u.dailyWaterNeed = 1.15 * u.bmr;
            else if( age < 31)
                u.dailyWaterNeed = 1.23 * u.bmr;
            else if( age < 51)
                u.dailyWaterNeed = 1.35 * u.bmr;
            else if( age >= 51)
                u.dailyWaterNeed = 1.5 * u.bmr;
        }
        else{
            u.bmr = 88.362
            + 13.397*(u.weight*0.453) //bmr weight factor with lb->kg conversion
            + 4.799*u.centimeters     //bmr height factor
            - 5.677*u.age;            //bmr age factor
            
            if( age < 4 )
                u.dailyWaterNeed = 0.93 * u.bmr;
            else if( age < 9)
                u.dailyWaterNeed = 1.06 * u.bmr;
            else if( age < 14)
                u.dailyWaterNeed = 1.20 * u.bmr;
            else if( age < 19)
                u.dailyWaterNeed = 1.18 * u.bmr;
            else if( age < 31)
                u.dailyWaterNeed = 1.32 * u.bmr;
            else if( age < 51)
                u.dailyWaterNeed = 1.42 * u.bmr;
            else if( age >= 51)
                u.dailyWaterNeed = 1.54 * u.bmr;
            
        }
        
        [context save:NULL];

        [self performSegueWithIdentifier:@"showToday" sender:self];
    }
}

- (IBAction)unwindToSetup:(UIStoryboardSegue *)segue
{
}

@end
