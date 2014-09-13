//
//  waterIntake.h
//  Hidrate
//
//  Created by Nicholas Padilla on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface waterIntake : NSObject
@property float height; //meters
@property float weight; //kg
@property float BMR;
@property float age;   //years
@property NSString *activity;
@property NSString *gender;
@property (nonatomic) float dailyWater;
@property (nonatomic) float percentOfDailyDrink;
@property (nonatomic) float cupsLeft;

@end
