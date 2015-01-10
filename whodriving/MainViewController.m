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

@property (weak, nonatomic) JoshView *currentView;
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

    [self.searchView setHidden:NO];
    [self.welcomeView setHidden:YES];
    [self.resultsView setHidden:YES];
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.welcomeView];
    [self.view addSubview:self.resultsView];

    self.searchView.delegate = self;
    self.welcomeView.delegate = self;
    self.resultsView.delegate = self;
    
    self.currentView = self.searchView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshDriversArray];
 
    [self.searchView viewWillAppear];
    [self.welcomeView viewWillAppear];
    [self.resultsView viewWillAppear];
    
//    if (self.searchView.drivers.count == 0) {
//    } else {
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"Intrinsic: %f, %f", self.view.intrinsicContentSize.width, self.view.intrinsicContentSize.height);
//    NSLog(@"Bounds: %f, %f", self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.currentView viewDidLayoutSubviews];
}

- (void) switchView:(JoshView*)newView
{
    [self.currentView runExitAnimation:^{
        [self.currentView setHidden:YES];
        [newView setHidden:NO];
        self.currentView = newView;
        [self.currentView runEntranceAnimation:^{

        }];
    }];
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
    
    [self switchView:self.resultsView];
}

-(void)done
{
    [self switchView:self.searchView];
}

@end
