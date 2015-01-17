//
//  ViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "MainViewController.h"
#import "ManageDriversTableViewController.h"
#import "FadeTransitionAnimator.h"
#import "ViewHelper.h"
#import "ResultsViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIView *searchForm;
@property (weak, nonatomic) IBOutlet UIView *numPeopleBg;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property NSArray *drivers;
@property FadeTransitionAnimator *transitionManager;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitionManager = [[FadeTransitionAnimator alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshDriversArray];
    
    [ViewHelper setCustomFont:self.personCountLabel fontName:@"Lato-Black"];
    [ViewHelper setCustomFont:self.needDriversLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.needDriversPeopleLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.searchButton.titleLabel fontName:@"Lato-Regular"];
    
    [ViewHelper makeRoundedView:self.numPeopleBg];
    self.searchButton.layer.cornerRadius = self.searchButton.frame.size.width / 12;
    self.searchButton.clipsToBounds = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
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
    } else if ([[segue identifier] isEqualToString:@"ShowResults"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        navigationController.modalPresentationStyle = UIModalPresentationCustom;
        navigationController.transitioningDelegate = self.transitionManager;
        
        NSNumber *personCount = [NSNumber numberWithInteger:[self.personCountLabel.text integerValue]];
        TripSpecification *tripSpec = [[TripSpecification alloc] init:personCount possibleDrivers:self.drivers];
        ResultsViewController *vc = (ResultsViewController*)[navigationController topViewController];
        vc.tripSpec = tripSpec;
    }
}

- (IBAction)increasePersonCount:(UIButton *)sender
{
    NSInteger personCount = [self.personCountLabel.text integerValue];
    
    personCount++;
    if (personCount > 99) {
        personCount = 99;
    }
    
    [self.personCountLabel setText:[NSString stringWithFormat:@"%d", personCount]];
}

- (IBAction)decreasePersonCount:(UIButton *)sender
{
    NSInteger personCount = [self.personCountLabel.text integerValue];
    
    personCount--;
    if (personCount < 1) {
        personCount = 1;
    }
    
    [self.personCountLabel setText:[NSString stringWithFormat:@"%d", personCount]];
}

- (IBAction)unwindToSearchScreen:(UIStoryboardSegue *)segue
{
    
}

@end
