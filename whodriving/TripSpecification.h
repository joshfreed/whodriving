//
//  TripSpecification.h
//  whodriving
//
//  Created by Josh Freed on 10/4/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripSpecification : NSObject

@property NSInteger passengerCount;
@property NSArray *possibleDrivers;

- (id)init;
- (void)increasePersonCount;
- (void)decreasePersonCount;
- (bool)isSatisfiedBy:(NSArray*)driverSet;

@end
