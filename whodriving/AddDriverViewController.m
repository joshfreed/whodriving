//
//  AddDriverViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "AddDriverViewController.h"

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
    
    self.driver = [[Driver alloc] init];
    self.driver.driverName = self.driverName.text;
    self.driver.numberOfPassengers = (NSNumber*)self.numPassengers.text;
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
