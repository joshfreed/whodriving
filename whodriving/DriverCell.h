//
//  ManageDriverCellTableViewCell.h
//  whodriving
//
//  Created by Josh Freed on 9/22/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Driver.h"
#import "ManageDriversTableViewController.h"

@interface DriverCell : UITableViewCell <UITextFieldDelegate>

@property Driver *driver;
@property (weak) ManageDriversTableViewController *parentTableView;

-(void)configure:(Driver*)driver;
-(void)willDisplayCell;

@end
