//
//  TripSpecification.h
//  whodriving
//
//  Created by Josh Freed on 10/4/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripSpecification : NSObject

@property NSNumber *passengerCount;
@property NSArray *possibleDrivers;

-(id)init:(NSNumber*)passengerCount possibleDrivers:(NSArray*)possibleDrivers;
-(bool)isSatisfiedBy:(NSArray*)driverSet;

@end
