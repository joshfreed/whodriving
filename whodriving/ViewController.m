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

@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property NSArray *drivers;
@property NSArray *tripResult;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareMainView];
}

- (void)prepareMainView
{
    [self refreshDriversArray];
    
    [self.navigationController setNavigationBarHidden:true];

//    if (self.drivers.count == 0) {
//        [self.actionButton setTitle:@"Add Drivers" forState:UIControlStateNormal];
//        [self.actionButton removeTarget:self action:@selector(findMeDrivers:) forControlEvents:UIControlEventTouchUpInside];
//        [self.actionButton addTarget:self action:@selector(showManageDriversScreen:) forControlEvents:UIControlEventTouchUpInside];
//    } else {
//        [self.actionButton setTitle:@"Find My Drivers" forState:UIControlStateNormal];
//        [self.actionButton removeTarget:self action:@selector(showManageDriversScreen:) forControlEvents:UIControlEventTouchUpInside];
//        [self.actionButton addTarget:self action:@selector(findMeDrivers:) forControlEvents:UIControlEventTouchUpInside];
//    }
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
    NSInteger personCount = [self.numPeopleLabel.text integerValue];
    
    personCount++;
    if (personCount > 99) {
        personCount = 99;
    }
    
    [self.numPeopleLabel setText:[NSString stringWithFormat:@"%d", personCount]];
}

- (IBAction)decreasePersonCount:(UIButton *)sender
{
    NSInteger personCount = [self.numPeopleLabel.text integerValue];
    
    personCount--;
    if (personCount < 1) {
        personCount = 1;
    }
    
    [self.numPeopleLabel setText:[NSString stringWithFormat:@"%d", personCount]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ManageDrivers"]) {
        [self.navigationController setNavigationBarHidden:false];
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"FindMyDrivers"]) {
        TripResultsViewController *vc = (TripResultsViewController*)segue.destinationViewController;
        vc.drivers = self.tripResult;
    }
}

- (IBAction)findMeDrivers:(UIButton *)sender
{
    NSInteger personCount = [self.numPeopleLabel.text integerValue];
    NSNumber *passengerCount = [NSNumber numberWithInteger:personCount];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:passengerCount possibleDrivers:self.drivers];
    TripService *tripService = [[TripService alloc] init];
    self.tripResult = [tripService buildTrip:tripSpec];
    [self performSegueWithIdentifier:@"FindMyDrivers" sender:self];
    
//    [UIView animateWithDuration:1.0 animations:^{
//        [self.view viewWithTag:1].alpha = 0.0f;
//    }];
}
//
//- (IBAction)showManageDriversScreen:(UIButton *)sender
//{
//    [self performSegueWithIdentifier:@"ManageDrivers" sender:self];
//}

- (IBAction)unwindToMainMenu:(UIStoryboardSegue *)segue
{
    [self.view viewWithTag:1].alpha = 1.0f;
}

@end
