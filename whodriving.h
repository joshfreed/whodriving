//
//  whodriving.h
//  whodriving
//
//  Created by Josh Freed on 9/24/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface whodriving : NSManagedObject

@property (nonatomic, retain) NSString * driverName;
@property (nonatomic, retain) NSNumber * numPassengers;

@end
