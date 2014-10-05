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
#import "TripCollectionViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIStepper *passengerStepper;
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
    
//    NSSet *set = [self.actionButton allTargets];
//    for (NSObject* target in set) {
//        NSLog(target);
//    }
//    
//    NSArray *actions = [self.actionButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
//    for (NSString *str in actions) {
//        NSLog(str);
//    }


    
    if (self.drivers.count == 0) {
        [self.actionButton setTitle:@"Add Drivers" forState:UIControlStateNormal];
        [self.actionButton removeTarget:self action:@selector(findMeDrivers:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionButton addTarget:self action:@selector(showManageDriversScreen:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.actionButton setTitle:@"Find My Drivers" forState:UIControlStateNormal];
        [self.actionButton removeTarget:self action:@selector(showManageDriversScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionButton addTarget:self action:@selector(findMeDrivers:) forControlEvents:UIControlEventTouchUpInside];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ManageDrivers"]) {
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"FindMyDrivers"]) {
        TripCollectionViewController *vc = (TripCollectionViewController*)segue.destinationViewController;
        vc.drivers = self.tripResult;
    }
}

- (IBAction)findMeDrivers:(UIButton *)sender
{
    NSNumber *passengerCount = [NSNumber numberWithDouble:self.passengerStepper.value];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:passengerCount possibleDrivers:self.drivers];
    TripService *tripService = [[TripService alloc] init];
    self.tripResult = [tripService buildTrip:tripSpec];
    [self performSegueWithIdentifier:@"FindMyDrivers" sender:self];
}

- (IBAction)numPeopleChanged:(UIStepper *)sender
{
    _numPeopleLabel.text = [NSString stringWithFormat:@"%g", sender.value];
}

- (IBAction)showManageDriversScreen:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"ManageDrivers" sender:self];
}

@end
