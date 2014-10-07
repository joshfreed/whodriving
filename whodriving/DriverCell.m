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

- (IBAction)increasedPassengerCount:(UIButton *)sender
{
    NSInteger passengerCount = [numPassengers.text integerValue];
    passengerCount++;
    [numPassengers setText:[NSString stringWithFormat:@"%d", passengerCount]];
    [self.driver setPassengerCount:passengerCount];
}

- (IBAction)decreasedPassengerCount:(UIButton *)sender
{
    NSInteger passengerCount = [numPassengers.text integerValue];
    passengerCount--;
    [numPassengers setText:[NSString stringWithFormat:@"%d", passengerCount]];
    [self.driver setPassengerCount:passengerCount];
}

- (IBAction)toggleDriver:(UISwitch *)sender
{
    if ([sender isOn]) {
        [self.driver enable];
    } else {
        [self.driver disable];
    }
}

@synthesize driverName, numPassengers;

@end
