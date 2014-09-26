//
//  AddDriverViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "AddDriverViewController.h"
#import "Driver.h"

@interface AddDriverViewController ()

@property (weak, nonatomic) IBOutlet UITextField *driverName;
@property (weak, nonatomic) IBOutlet UITextField *numPassengers;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation AddDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// change to save button
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) {
        return;
    }
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSNumber * numPassengers = [f numberFromString:self.numPassengers.text];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
    Driver *driver = [[Driver alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    driver.driverName = self.driverName.text;
    driver.numPassengers = numPassengers;
//
//    NSError *error = nil;
//    if (![self.managedObjectContext save:&error]) {
//        if (error) {
//            NSLog(@"Unable to save record.");
//            NSLog(@"%@, %@", error, error.localizedDescription);
//        }
//        
//        // Show Alert View
//        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
