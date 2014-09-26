//
//  ManageDriverCellTableViewCell.m
//  whodriving
//
//  Created by Josh Freed on 9/22/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "DriverCell.h"

@implementation DriverCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    numPassengers.text = [NSString stringWithFormat:@"%g", sender.value];
    [self.driver setPassengerCount:sender.value];
}

@synthesize driverName, numPassengers, passengerStepper;

@end
