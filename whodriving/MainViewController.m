//
//  ViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "MainViewController.h"
#import "ManageDriversTableViewController.h"
#import "ViewHelper.h"
#import "ResultsViewController.h"
#import "Masonry.h"
#import "TripService.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *searchForm;
@property (weak, nonatomic) IBOutlet UIView *numPeopleBg;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *addSomeDriversButton;
@property NSArray *drivers;
@property UIImageView *addSomeDriversImg;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addSomeDriversImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddSomeDrivers"]];
    [self.view addSubview:self.addSomeDriversImg];
    [self.addSomeDriversImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(self.view.mas_width).multipliedBy(0.6667);
        make.height.equalTo(self.addSomeDriversImg.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.bottom.lessThanOrEqualTo(self.addSomeDriversButton.mas_top).with.offset(-32);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshDriversArray];
    
    // This is where I'd prefer to set cusotm fonts; before they are displayed on the screen.
    // Only some elements seem to accept the font up here, though. Others ignore it.
    [ViewHelper setCustomFont:self.needDriversLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.needDriversPeopleLabel fontName:@"Lato-Regular"];
    
    self.searchButton.layer.cornerRadius = 5;
    self.searchButton.clipsToBounds = YES;
    self.addSomeDriversButton.layer.cornerRadius = 5;
    self.addSomeDriversButton.clipsToBounds = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (self.drivers.count == 0) {
        [self.addSomeDriversImg setHidden:NO];
        [self.addSomeDriversButton setHidden:NO];
        [self.searchButton setHidden:YES];
        [self.searchForm setHidden:YES];
    } else {
        [self.addSomeDriversImg setHidden:YES];
        [self.addSomeDriversButton setHidden:YES];
        [self.searchButton setHidden:NO];
        [self.searchForm setHidden:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    // For some reason, these particular views will only accept a custom font if I specify here in viewDidAppear
    [ViewHelper setCustomFont:self.personCountLabel fontName:@"Lato-Black"];
    [ViewHelper setCustomFont:self.searchButton.titleLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.addSomeDriversButton.titleLabel fontName:@"Lato-Regular"];
    
    [ViewHelper makeRoundedView:self.numPeopleBg];

//    NSLog(@"personCountLabel: %@", self.personCountLabel.font.fontName);
//    NSLog(@"needDriversLabel: %@", self.needDriversLabel.font.fontName);
//    NSLog(@"needDriversPeopleLabel: %@", self.needDriversPeopleLabel.font.fontName);
//    NSLog(@"searchButton: %@", self.searchButton.titleLabel.font.fontName);
//    NSLog(@"addSomeDriversButton: %@", self.addSomeDriversButton.titleLabel.font.fontName);
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
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)[navigationController topViewController];
        viewController.managedObjectContext = self.managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"ShowResults"]) {
        TripSpecification *tripSpec = [[TripSpecification alloc] init:[self personCount] possibleDrivers:self.drivers];
        ResultsViewController *vc = (ResultsViewController*)segue.destinationViewController;
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

- (NSNumber *)personCount
{
    return [NSNumber numberWithInteger:[self.personCountLabel.text integerValue]];
}

- (IBAction)addSomeDriversClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"ManageDrivers" sender:sender];
}

@end
