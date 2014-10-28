//
//  ViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "ViewController.h"
#import "ManageDriversTableViewController.h"
#import "Driver.h"
#import "TripSpecification.h"
#import "TripService.h"
#import "TripResultsViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *findMyDriversButton;
@property (weak, nonatomic) IBOutlet UIButton *manageDriversButton;
//@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;

@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIView *numPeopleBg;
@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *needDriversLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversPeopleLabel;


@property NSArray *drivers;
@property NSArray *tripResult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)makeRoundedView:(UIView*)view
{
    view.layer.cornerRadius = view.frame.size.width / 2;
}

- (void)setCustomFont:(UILabel*)label fontName:(NSString*)fontName
{
    [label setFont:[UIFont fontWithName:fontName size:label.font.pointSize]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareMainView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self makeRoundedView:self.numPeopleBg];
    [self makeRoundedView:self.plusButton];
    [self makeRoundedView:self.minusButton];
    
    [self setCustomFont:self.plusButton.titleLabel fontName:@"Lato-Hairline"];
    [self setCustomFont:self.minusButton.titleLabel fontName:@"Lato-Hairline"];
    [self setCustomFont:self.numPeopleLabel2 fontName:@"Lato-Black"];
    [self setCustomFont:self.needDriversLabel fontName:@"Lato-Regular"];
    [self setCustomFont:self.needDriversPeopleLabel fontName:@"Lato-Regular"];
}

- (void)prepareMainView
{
    [self refreshDriversArray];

    if (self.drivers.count == 0) {
        [self.findMyDriversButton setHidden:YES];
        [self.manageDriversButton setHidden:NO];
//        [self.actionButton setTitle:@"Add Drivers" forState:UIControlStateNormal];
//        [self.actionButton removeTarget:self action:@selector(findMeDrivers:) forControlEvents:UIControlEventTouchUpInside];
//        [self.actionButton addTarget:self action:@selector(showManageDriversScreen:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.findMyDriversButton setHidden:NO];
        [self.manageDriversButton setHidden:YES];
//        [self.actionButton setTitle:@"Find My Drivers" forState:UIControlStateNormal];
//        [self.actionButton removeTarget:self action:@selector(showManageDriversScreen:) forControlEvents:UIControlEventTouchUpInside];
//        [self.actionButton addTarget:self action:@selector(findMeDrivers:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)refreshDriversArray
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    self.drivers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.drivers == nil) {
        // Handle the error.
        NSLog(@"Drivers array is nil!?");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)increasePersonCount:(UIButton *)sender
{
    NSInteger personCount = [self.numPeopleLabel2.text integerValue];
    
    personCount++;
    if (personCount > 99) {
        personCount = 99;
    }
    
    [self.numPeopleLabel2 setText:[NSString stringWithFormat:@"%d", personCount]];
}

- (IBAction)decreasePersonCount:(UIButton *)sender
{
    NSInteger personCount = [self.numPeopleLabel2.text integerValue];
    
    personCount--;
    if (personCount < 1) {
        personCount = 1;
    }
    
    [self.numPeopleLabel2 setText:[NSString stringWithFormat:@"%d", personCount]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if ([[segue identifier] isEqualToString:@"ManageDrivers"]) {
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"FindMyDrivers"]) {
        NSInteger personCount = [self.numPeopleLabel2.text integerValue];
        NSNumber *passengerCount = [NSNumber numberWithInteger:personCount];
        TripSpecification *tripSpec = [[TripSpecification alloc] init:passengerCount possibleDrivers:self.drivers];
        
        TripResultsViewController *vc = (TripResultsViewController*)segue.destinationViewController;
        vc.tripSpec = tripSpec;
        vc.drivers = self.tripResult;
        vc.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)findMeDrivers:(UIButton *)sender
{
    NSInteger personCount = [self.numPeopleLabel2.text integerValue];
    NSNumber *passengerCount = [NSNumber numberWithInteger:personCount];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:passengerCount possibleDrivers:self.drivers];
    TripService *tripService = [[TripService alloc] init];
    self.tripResult = [tripService buildTrip:tripSpec];
    [self performSegueWithIdentifier:@"FindMyDrivers" sender:self];
}
//
//- (IBAction)showManageDriversScreen:(UIButton *)sender
//{
//    [self performSegueWithIdentifier:@"ManageDrivers" sender:self];
//}

@end
