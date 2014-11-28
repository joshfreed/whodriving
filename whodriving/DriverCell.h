//
//  ManageDriverCellTableViewCell.h
//  whodriving
//
//  Created by Josh Freed on 9/22/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Driver.h"

@interface DriverCell : UITableViewCell <UITextFieldDelegate>

@property Driver *driver;

-(void)configure:(Driver*)driver;
-(void)willDisplayCell;

@end
