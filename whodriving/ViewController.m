//
//  ViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "ViewController.h"
#import "ManageDriversTableViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
    }
}

- (IBAction)findMeDrivers:(UIButton *)sender
{
    
}

- (IBAction)numPeopleChanged:(UIStepper *)sender
{
    _numPeopleLabel.text = [NSString stringWithFormat:@"%g", sender.value];
}

@end
