///
//  TripService.m
//  whodriving
//
//  Created by Josh Freed on 10/4/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "TripService.h"
#import "Driver.h"
#import "DriverResult.h"

@interface TripService ()
@property TripSpecification *tripSpec;
@property NSMutableArray *allResultSets;
@property NSMutableArray *stack;
@end

@implementation TripService

-(NSArray*)buildTrip:(TripSpecification*)tripSpec
{
    NSArray *allResultSets = [self getAllPossibleResults:tripSpec];
    
    if (allResultSets.count > 0) {
        NSArray *randomized = [allResultSets sortedArrayUsingComparator:^(id obj1, id obj2) {
            if (rand() % 2 == 0) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        return [randomized firstObject];
    } else {
        return [NSArray array];
    }
}

-(NSArray*)getAllPossibleResults:(TripSpecification*)tripSpec
{
    self.tripSpec = tripSpec;
    self.allResultSets = [NSMutableArray array];
    self.stack = [NSMutableArray array];
    
    NSPredicate *capableDriverPredicate = [NSPredicate predicateWithBlock:^BOOL(Driver* driver, NSDictionary *bindings) {
        return driver.isEnabled;
    }];
    NSArray *enabledDrivers = [tripSpec.possibleDrivers filteredArrayUsingPredicate:capableDriverPredicate];
    
    NSArray *sortedDrivers = [enabledDrivers sortedArrayUsingComparator:^(Driver *obj1, Driver *obj2) {
        if (obj1.numPassengers > obj2.numPassengers) {
            return NSOrderedAscending;
        } else if (obj1.numPassengers < obj2.numPassengers) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    [self tryDrivers:sortedDrivers];

    return self.allResultSets;
}

-(void)tryDrivers:(NSArray*)possibleDrivers
{
    int index = 0;
    for (Driver *driver in possibleDrivers) {
        [self.stack addObject:driver];
        if ([self.tripSpec isSatisfiedBy:self.stack]) {
            [self.allResultSets addObject:[NSArray arrayWithArray:self.stack]];
            [self.stack removeLastObject];
        } else {
            NSRange range = NSMakeRange(index + 1, possibleDrivers.count - (index + 1));
            if (range.length > 0) {
                NSArray *newArray = [possibleDrivers subarrayWithRange:range];
                [self tryDrivers:newArray];
            }
            [self.stack removeLastObject];
        }
        
        index++;
    }
}



@end
