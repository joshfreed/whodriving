//
//  Driver.h
//  whodriving
//
//  Created by Josh Freed on 9/20/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Driver : NSManagedObject

@property (nonatomic, retain) NSString * driverName;
@property (nonatomic, retain) NSNumber * numPassengers;
@property (nonatomic) BOOL isEnabled;
@property (nonatomic, retain) NSDate * createdOn;

- (void)setPassengerCount:(double)numPassengers;
- (void)enable;
- (void)disable;
- (NSComparisonResult)sortByName:(Driver*)aDriver;

@end
