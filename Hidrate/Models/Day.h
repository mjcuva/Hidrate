//
//  Day.h
//  Hidrate
//
//  Created by Nicholas Padilla on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Day : NSManagedObject

@property (nonatomic) double amountDrank;
@property (nonatomic) int32_t day;
@property (nonatomic) int32_t month;
@property (nonatomic) int32_t year;

@end
