//
//  User.h
//  Hidrate
//
//  Created by Marc Cuva on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic) int16_t age;
@property (nonatomic) double weight;
@property (nonatomic) int16_t feet;
@property (nonatomic) int16_t inches;
@property (nonatomic, retain) NSString * gender;

@end
