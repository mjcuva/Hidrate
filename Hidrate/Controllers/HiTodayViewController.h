//
//  HiTodayViewController.h
//  Hidrate
//
//  Created by Matthew Lewis on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiTodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *waterPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterBottlesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wavesImage;

- (void)setWaterPercentConsumed:(int)percent;
- (void)setBottlesRemaining:(float)bottles;

@end
