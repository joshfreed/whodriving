//
//  PotentialDriversViewController.h
//  Who's Driving?!
//
//  Created by Josh Freed on 2/27/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripSpecification.h"

@interface PotentialDriversViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak) UITextField *activeTextField;
@property TripSpecification *tripSpec;
@end
