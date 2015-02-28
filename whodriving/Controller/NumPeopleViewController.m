//
//  NumPeopleViewController.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/27/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "NumPeopleViewController.h"
#import "ViewHelper.h"
#import "PotentialDriversViewController.h"
#import "TripSpecification.h"

@interface NumPeopleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;
@property (weak, nonatomic) IBOutlet UIView *numPeopleBgCircle;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *numPeopleCounter;
@end

@implementation NumPeopleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [ViewHelper setCustomFont:self.numPeopleLabel fontName:@"Lato"];
    [ViewHelper setCustomFont:self.nextButton.titleLabel fontName:@"Lato"];
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [ViewHelper makeRoundedView:self.numPeopleBgCircle];
    [ViewHelper setCustomFont:self.numPeopleCounter fontName:@"Lato-Black"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPotentialDrivers"]) {
        PotentialDriversViewController *vc = [segue destinationViewController];
        vc.managedObjectContext = self.managedObjectContext;
        vc.tripSpec = [[TripSpecification alloc] init:[self personCount]];
    }
}

- (NSNumber *)personCount
{
    return [NSNumber numberWithInteger:[self.numPeopleCounter.text integerValue]];
}

- (IBAction)increaseNumPeople:(UIButton *)sender
{
    NSInteger numPeople = [self.numPeopleCounter.text integerValue];
    
    numPeople++;
    if (numPeople > 99) {
        numPeople = 99;
    }
    
    [self.numPeopleCounter setText:[NSString stringWithFormat:@"%d", numPeople]];
}

- (IBAction)decreaseNumPeople:(UIButton *)sender
{
    NSInteger numPeople = [self.numPeopleCounter.text integerValue];
    
    numPeople--;
    if (numPeople < 1) {
        numPeople = 1;
    }
    
    [self.numPeopleCounter setText:[NSString stringWithFormat:@"%d", numPeople]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
