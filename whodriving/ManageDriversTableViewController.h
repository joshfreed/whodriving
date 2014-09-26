//
//  DriversTableViewController.h
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageDriversTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end