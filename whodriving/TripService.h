//
//  TripService.h
//  whodriving
//
//  Created by Josh Freed on 10/4/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripSpecification.h"

@interface TripService : NSObject

-(NSArray*)buildTrip:(TripSpecification*)tripSpec;
-(NSArray*)getAllPossibleResults:(TripSpecification*)tripSpec;

@end
