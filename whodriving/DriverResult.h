//
//  DriverResult.h
//  whodriving
//
//  Created by Josh Freed on 10/5/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Driver.h"

@interface DriverResult : NSObject

@property Driver *driver;
@property NSNumber *passengerCount;

@end
