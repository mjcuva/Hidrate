//
//  Day.h
//  Hidrate
//
//  Created by Marc Cuva on 9/13/14.
//  Copyright (c) 2014 Hidrate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Day : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * amountDrank;

@end
