//
//  ManageDriverCellTableViewCell.h
//  whodriving
//
//  Created by Josh Freed on 9/22/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Driver.h"
#import "PotentialDriversViewController.h"

@interface DriverCell : UITableViewCell <UITextFieldDelegate>

@property Driver *driver;
@property (weak) PotentialDriversViewController *parentTableView;

-(void)configure:(Driver*)driver;
-(void)willDisplayCell;

@end
