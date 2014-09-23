//
//  ManageDriverCellTableViewCell.h
//  whodriving
//
//  Created by Josh Freed on 9/22/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Driver.h"

@interface ManageDriverCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *driverName;
@property (nonatomic, weak) IBOutlet UILabel *numPassengers;
@property (nonatomic, weak) IBOutlet UIStepper *passengerStepper;
@property Driver *driver;

@end
