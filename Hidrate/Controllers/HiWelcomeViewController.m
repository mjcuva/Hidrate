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

- (void)viewDidLoad{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"full-gradient-background.png"]];
}

@end
