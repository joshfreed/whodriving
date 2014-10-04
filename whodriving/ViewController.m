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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property NSArray *drivers;

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
//        UINavigationController *navigationController = (UINavigationController *);
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)findMeDrivers:(UIButton *)sender
{

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
