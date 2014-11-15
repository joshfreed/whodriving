//
//  ManageDriverCellTableViewCell.m
//  whodriving
//
//  Created by Josh Freed on 9/22/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "DriverCell.h"
#import "ViewHelper.h"

@interface DriverCell ()
@property (nonatomic, weak) IBOutlet UITextField *driverName;
@property (nonatomic, weak) IBOutlet UILabel *numPassengers;
@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;
@end

@implementation DriverCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(Driver *)driver
{
    if (self.driver != driver) {
        self.driver = driver;
    }
    
    [self.driverName setText:driver.driverName];
    [self.numPassengers setText:[driver.numPassengers stringValue]];
    [self.enabledSwitch setOn:driver.isEnabled];
}

- (void)willDisplayCell
{
    [ViewHelper setCustomFontForTextField:self.driverName fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.numPassengers fontName:@"Lato-Black"];
}

- (IBAction)increasedPassengerCount:(UIButton *)sender
{
    NSInteger passengerCount = [self.numPassengers.text integerValue];
    passengerCount++;
    if (passengerCount > 99) {
        passengerCount = 99;
    }
    [self.numPassengers setText:[NSString stringWithFormat:@"%d", passengerCount]];
    [self.driver setPassengerCount:passengerCount];
}

- (IBAction)decreasedPassengerCount:(UIButton *)sender
{
    NSInteger passengerCount = [self.numPassengers.text integerValue];
    passengerCount--;
    if (passengerCount < 0) {
        passengerCount = 0;
    }
    [self.numPassengers setText:[NSString stringWithFormat:@"%d", passengerCount]];
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

- (IBAction)editingDidEnd:(UITextField *)sender
{
    [self.driver setDriverName:self.driverName.text];
    [self resignFirstResponder];
}

@end
