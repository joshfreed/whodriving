//
//  AddDriverViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "AddDriverViewController.h"
#import "Driver.h"
#import "ViewHelper.h"

@interface AddDriverViewController ()
@property (weak, nonatomic) IBOutlet UITextField *driverName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation AddDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.driverName becomeFirstResponder];
    
    [ViewHelper setCustomFontForTextField:self.driverName fontName:@"Lato-Heavy"];
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

    NSString *driverName = self.driverName.text;
    if ([driverName length] == 0) {
        driverName = @"Unnamed Driver";
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
    Driver *driver = [[Driver alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    [driver enable];
    driver.driverName = driverName;
    driver.numPassengers = [NSNumber numberWithInt:0];
    driver.createdOn = [NSDate date];

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        if (error) {
            NSLog(@"Unable to save record.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        
//        // Show Alert View
//        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your to-do could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [self.driverName resignFirstResponder];
    [self performSegueWithIdentifier:@"saveAndClose" sender:self.doneButton];
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
