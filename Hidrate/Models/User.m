//
//  User.m
//  Hidrate
//
//  Created by Marc Cuva on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic age;
@dynamic weight;
@dynamic feet;
@dynamic inches;
@dynamic gender;

-(float)dailyWater{
    return self.dailyWater;
}

-(void)setDailyWater{
    float BMR;
    float height; //height in centimeters
    
    //convert Empirial to cm
    height = self.feet*30.480 + self.inches*0.394;
    
    
    
    if([self.gender isEqualToString:@"Female"]){
        BMR = 88.362;
        BMR += 13.297*height;//weight modifier
        BMR += 4.799*self.weight; //height modifier
        BMR -= 5.677*self.age; //age modifier
        
        if(self.age < 4)
            self.dailyWater = BMR * 0.93;
        else if(self.age < 9)
            self.dailyWater = BMR * 1.06;
        else if (self.age < 14)
            self.dailyWater = BMR * 1.05;
        else if (self.age < 19)
           self.dailyWater = BMR * 1.15;
        else if (self.age < 31)
            self.dailyWater = BMR * 1.23;
        else if (self.age < 51)
            self.dailyWater = BMR * 1.35;
        else
            self.dailyWater = BMR * 1.50;
        
    }
    else{
        BMR = 447.593;
        BMR += 9.247*height; //weight modifier
        BMR += 3.098*self.weight; //height modifier
        BMR -= 4.330*self.age; //age modifier
        
        if(self.age < 4)
            self.dailyWater = BMR * 0.93;
        else if(self.age < 9)
            self.dailyWater = BMR * 1.06;
        else if (self.age < 14)
            self.dailyWater = BMR * 1.20;
        else if (self.age < 19)
            self.dailyWater = BMR * 1.18;
        else if (self.age < 31)
            self.dailyWater = BMR * 1.32;
        else if (self.age < 51)
            self.dailyWater = BMR * 1.42;
        else
            self.dailyWater = BMR * 1.54;
    }
}



@end
