//
//  Driver.m
//  whodriving
//
//  Created by Josh Freed on 9/20/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "Driver.h"

@implementation Driver

- (void)setNumPassengers:(double)numPassengers {
    NSNumber *theNum = [NSNumber numberWithDouble:numPassengers];
    self.numberOfPassengers = theNum;
}

@end