//
//  HiWelcomeViewController.m
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "HiWelcomeViewController.h"

@interface HiWelcomeViewController ()

@end

@implementation HiWelcomeViewController

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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"txt"];
    NSError *error;
    NSString *introText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        DDLogError(@"Error loading intro text: %@", error);
    }
    [[self introTextLabel] setText:introText];
}

@end
