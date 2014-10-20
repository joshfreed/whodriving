//
//  TripResultsViewController.m
//  whodriving
//
//  Created by Josh Freed on 10/14/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "TripResultsViewController.h"
#import "DriverResultCollectionViewCell.h"
#import "ManageDriversTableViewController.h"
#import "TripService.h"

@interface TripResultsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TripResultsViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)findDifferentDrivers:(UIButton *)sender
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *drivers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (drivers == nil) {
        // Handle the error.
        NSLog(@"Drivers array is nil!?");
    }
    
    TripSpecification *tripSpec = [[TripSpecification alloc] init:self.tripSpec.passengerCount possibleDrivers:drivers];
    TripService *tripService = [[TripService alloc] init];
    self.drivers = [tripService buildTrip:tripSpec];
    [self.collectionView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"ManageDrivers"]) {
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
    }
    
//    if ([[segue identifier] isEqualToString:@"ShowResultCollection"]) {
//        TripCollectionViewController *vc = (TripCollectionViewController*)segue.destinationViewController;
//        vc.drivers = self.drivers;
//    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return self.drivers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DriverResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Driver Result Cell" forIndexPath:indexPath];
    
    DriverResult *result = [self.drivers objectAtIndex:indexPath.row];
    [cell.driverNameLabel setText:result.driver.driverName];
    [cell.passengerCountLabel setText:[result.passengerCount stringValue]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


@end
