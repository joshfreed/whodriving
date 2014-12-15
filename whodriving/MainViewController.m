//
//  ViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "MainViewController.h"
#import "ManageDriversTableViewController.h"
#import "SearchView.h"
#import "WelcomeView.h"
#import "ResultsView.h"

@interface MainViewController ()

@property (strong, nonatomic) SearchView *searchView;
@property (strong, nonatomic) WelcomeView *welcomeView;
@property (strong, nonatomic) ResultsView *resultsView;
@property NSArray *drivers;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchView = [[[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:self options:nil] objectAtIndex:0];
    self.welcomeView = [[[NSBundle mainBundle] loadNibNamed:@"WelcomeView" owner:self options:nil] objectAtIndex:0];
    self.resultsView = [[[NSBundle mainBundle] loadNibNamed:@"ResultsView" owner:self options:nil] objectAtIndex:0];

    self.searchView.delegate = self;
    self.welcomeView.delegate = self;
    self.resultsView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshDriversArray];

//    if (self.searchView.drivers.count == 0) {
//        [self.searchView removeFromSuperview];
//        [self.view addSubview:self.welcomeView];
//        [self.welcomeView viewWillAppear];
//    } else {
        [self.welcomeView removeFromSuperview];
        [self.view addSubview:self.searchView];
        [self.searchView viewWillAppear];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"Intrinsic: %f, %f", self.view.intrinsicContentSize.width, self.view.intrinsicContentSize.height);
//    NSLog(@"Bounds: %f, %f", self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)refreshDriversArray
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    self.drivers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.searchView.drivers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if ([[segue identifier] isEqualToString:@"ManageDrivers"]) {
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
    }
}

-(void)showManageDrivers
{
    [self performSegueWithIdentifier:@"ManageDrivers" sender:self];
}

-(void)findDrivers:(NSNumber*)personCount
{
    TripSpecification *tripSpec = [[TripSpecification alloc] init:personCount possibleDrivers:self.drivers];
    self.resultsView.tripSpec = tripSpec;
    
    [self.welcomeView removeFromSuperview];
    [self.searchView removeFromSuperview];
    [self.view addSubview:self.resultsView];
    [self.resultsView viewWillAppear];
}

-(void)done
{
    [self.resultsView removeFromSuperview];
    [self.view addSubview:self.searchView];
    [self.searchView viewWillAppear];
}

@end
