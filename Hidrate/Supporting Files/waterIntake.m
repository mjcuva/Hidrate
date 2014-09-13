//
//  waterIntake.m
//  Hidrate
//
//  Created by Nicholas Padilla on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "waterIntake.h"

@implementation waterIntake
@synthesize height; //meters
@synthesize weight; //kg
@synthesize BMR;
@synthesize age;   //years
@synthesize activity;
@synthesize gender;

-(float)dailyWater{
    return _dailyWater;
}

-(void)setDailyWater{
    if([gender isEqualToString:@"female"]){
        BMR = 88.362;
        BMR += 13.297*height;//weight modifier
        BMR += 4.799*weight; //height modifier
        BMR -= 5.677*age; //age modifier
        
        if(age < 4)
            _dailyWater = BMR * 0.93;
        else if(age < 9)
            _dailyWater = BMR * 1.06;
        else if (age < 14)
            _dailyWater = BMR * 1.05;
        else if (age < 19)
            _dailyWater = BMR * 1.15;
        else if (age < 31)
            _dailyWater = BMR * 1.23;
        else if (age < 51)
            _dailyWater = BMR * 1.35;
        else
            _dailyWater = BMR * 1.50;
            
    }
    else{
        BMR = 447.593;
        BMR += 9.247*height; //weight modifier
        BMR += 3.098*weight; //height modifier
        BMR -= 4.330*age; //age modifier
        
        if(age < 4)
            _dailyWater = BMR * 0.93;
        else if(age < 9)
            _dailyWater = BMR * 1.06;
        else if (age < 14)
            _dailyWater = BMR * 1.20;
        else if (age < 19)
            _dailyWater = BMR * 1.18;
        else if (age < 31)
            _dailyWater = BMR * 1.32;
        else if (age < 51)
            _dailyWater = BMR * 1.42;
        else
            _dailyWater = BMR * 1.54;
    }
}

@end
