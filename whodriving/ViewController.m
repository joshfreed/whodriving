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
#import "ViewHelper.h"

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
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *searchForm;
@property (weak, nonatomic) IBOutlet UIView *resultsView;

@property (weak, nonatomic) UIView *contentView;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [ViewHelper makeRoundedView:self.numPeopleBg];
    [ViewHelper makeRoundedView:self.plusButton];
    [ViewHelper makeRoundedView:self.minusButton];

    [ViewHelper setCustomFont:self.numPeopleLabel2 fontName:@"Lato-Black"];
    [ViewHelper setCustomFont:self.needDriversLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.needDriversPeopleLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.searchButton.titleLabel fontName:@"Lato-Regular"];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
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

- (void)updateDriverResults:(NSArray *)drivingDrivers
{
    [[self.resultsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int i = 0;
    
    UIView *spacer1 = [UIView new];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
//    spacer1.backgroundColor = [UIColor grayColor];
    [self.resultsView addSubview:spacer1];
    
    UIView *spacer2 = [UIView new];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
//    spacer2.backgroundColor = [UIColor brownColor];
    [self.resultsView addSubview:spacer2];
    
    [self.resultsView addConstraint:[NSLayoutConstraint constraintWithItem:spacer1
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.resultsView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    [self.resultsView addConstraint:[NSLayoutConstraint constraintWithItem:spacer2
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.resultsView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    [spacer1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[spacer1(10)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"spacer1": spacer1}]];
    [spacer2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[spacer2(10)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"spacer2": spacer2}]];
    
    NSMutableArray *labels = [NSMutableArray array];
    for (Driver *driver in drivingDrivers) {
        UILabel *driverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
        driverLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [driverLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:30]];
        [driverLabel setTextColor:UIColorFromRGB(0x444444)];
        [driverLabel setText:driver.driverName];
        [driverLabel setTextAlignment:NSTextAlignmentCenter];
        [self.resultsView addSubview:driverLabel];
        [labels addObject:driverLabel];
    }
    
    i = 0;
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
    [viewsDictionary setValue:spacer1 forKey:@"spacer1"];
    [viewsDictionary setValue:spacer2 forKey:@"spacer2"];
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        [viewsDictionary setValue:driverLabel forKey:viewName];
        i++;
    }
    
    i = 0;
    NSMutableString *vFormat = [NSMutableString stringWithString:@"V:|[spacer1]"];
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        
        if (i == 0) {
            [vFormat appendFormat:@"[%@]", viewName];
        } else {
            [vFormat appendFormat:@"-15-[%@]", viewName];
        }
        
        i++;
    }
    [vFormat appendString:@"[spacer2(==spacer1)]|"];
    [self.resultsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    i = 0;
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        
        [driverLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(35)]", viewName]
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
        [self.resultsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-[%@]-|", viewName]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary] ];
        [self.resultsView addConstraint:[NSLayoutConstraint constraintWithItem:driverLabel
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.resultsView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1
                                                                         constant:0]];
        i++;
    }
    
//    NSLog(vFormat);
}

- (IBAction)findMeDrivers:(UIButton *)sender
{
    [self.view layoutIfNeeded];
    
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop){
        if (constraint.firstItem == self.searchButton && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondItem == self.searchForm) {
            [constraint setActive:NO];
        }
        if (constraint.secondItem == self.searchForm && constraint.secondAttribute == NSLayoutAttributeBottom && constraint.firstItem == self.view) {
            [constraint setActive:NO];
        }
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    NSInteger personCount = [self.numPeopleLabel2.text integerValue];
    NSNumber *passengerCount = [NSNumber numberWithInteger:personCount];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:passengerCount possibleDrivers:self.drivers];
    TripService *tripService = [[TripService alloc] init];
    NSArray *drivingDrivers = [tripService buildTrip:tripSpec];
    [self updateDriverResults:drivingDrivers];
}

//
//- (IBAction)showManageDriversScreen:(UIButton *)sender
//{
//    [self performSegueWithIdentifier:@"ManageDrivers" sender:self];
//}

@end
