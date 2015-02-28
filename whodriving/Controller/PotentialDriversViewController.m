//
//  PotentialDriversViewController.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/27/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "PotentialDriversViewController.h"
#import "ViewHelper.h"
#import "AddDriverViewController.h"
#import "DriverCell.h"
#import "TripSpecification.h"
#import "ResultsViewController.h"

@interface PotentialDriversViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIView *noDriversBgColor;
@property (weak, nonatomic) IBOutlet UIButton *noDriversButton1;
@property (weak, nonatomic) IBOutlet UIButton *noDriversButton2;
@property (weak, nonatomic) IBOutlet UIButton *noDriversButton3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PotentialDriversViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchDrivers];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64;
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [ViewHelper setCustomFont:self.backButton.titleLabel fontName:@"Lato"];
    self.backButton.layer.cornerRadius = 5;
    self.backButton.clipsToBounds = YES;
    
    [ViewHelper setCustomFont:self.nextButton.titleLabel fontName:@"Lato"];
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.clipsToBounds = YES;
    
    self.noDriversBgColor.layer.cornerRadius = 5;
    self.noDriversBgColor.clipsToBounds = YES;
    
    [ViewHelper setCustomFont:self.noDriversButton1.titleLabel fontName:@"Lato-Light"];
    [ViewHelper setCustomFont:self.noDriversButton3.titleLabel fontName:@"Lato-Light"];
    
    self.bgView.layer.borderColor = UIColorFromRGB(0x979797).CGColor;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.clipsToBounds = YES;
    
    self.bgView.layer.borderWidth = 0;
    self.tableView.alpha = 0;
    self.noDriversBgColor.alpha = 1;
    self.nextButton.alpha = 0;
    [self toggleNoDriversDisplay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        if (error) {
            NSLog(@"Unable to save record.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDrivers
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Driver"];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"driverName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}

- (IBAction)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAddDriver"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        AddDriverViewController *vc = [navigationController topViewController];
        vc.managedObjectContext = self.managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"showResults"]) {
        ResultsViewController *vc = segue.destinationViewController;
        [self.tripSpec setPossibleDrivers:self.fetchedResultsController.fetchedObjects];
        vc.tripSpec = self.tripSpec;
    }
}

- (IBAction)addDriver:(id)sender
{
    [self performSegueWithIdentifier:@"showAddDriver" sender:sender];
}

- (IBAction)unwindToPotentialDrivers:(UIStoryboardSegue *)segue
{
    
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        [self.tableView scrollRectToVisible:self.activeTextField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)toggleNoDriversDisplay
{
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bgView.layer.borderWidth = 0;
            self.tableView.alpha = 0;
            self.noDriversBgColor.alpha = 1;
            self.nextButton.alpha = 0;
        }];
    } else {
        self.bgView.layer.borderWidth = 1;
        self.tableView.alpha = 1;
        self.noDriversBgColor.alpha = 0;
        self.nextButton.alpha = 1;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverCell *cell = (DriverCell*)[tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    cell.parentTableView = self;
    
    Driver *driver = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configure:driver];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DriverCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell willDisplayCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        return 64;
    } else {
        return 78;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DriverCell *cell = (DriverCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.driver = nil;
        Driver *driver = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:driver];
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - NSFetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self toggleNoDriversDisplay];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self toggleNoDriversDisplay];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            //            [self configureCell:(DriverCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

@end
