//
//  ViewController.m
//  whodriving
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "MainViewController.h"
#import "ManageDriversTableViewController.h"
#import "FadeTransitionAnimator.h"
#import "ViewHelper.h"
#import "ResultsViewController.h"
#import "SearchPresentationController.h"
#import "Masonry.h"
#import "TripService.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIView *searchForm;
@property (weak, nonatomic) IBOutlet UIView *numPeopleBg;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property NSArray *drivers;
@property FadeTransitionAnimator *transitionManager;
@property TripService *tripService;
@property UIView *loadingView;
@property UIView *dimmerView;
@property NSArray *searchResults;
@property UIImageView *questionBang;
@property BOOL driversLoaded;
@property int minAnims;
@property int animCount;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitionManager = [[FadeTransitionAnimator alloc] init];
    self.tripService = [[TripService alloc] init];
    self.driversLoaded = NO;
    self.minAnims = 1;
    self.animCount = 0;
    
    self.dimmerView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    self.dimmerView.backgroundColor = [UIColor blackColor];
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    self.loadingView.backgroundColor = UIColorFromRGB(0xE67E22);
    [ViewHelper makeRoundedView:self.loadingView];
    
    self.questionBang = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QuestionBang"]];
    [self.loadingView addSubview:self.questionBang];
    [self.questionBang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingView.mas_centerX);
        make.centerY.equalTo(self.loadingView.mas_centerY);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshDriversArray];
    
    [ViewHelper setCustomFont:self.personCountLabel fontName:@"Lato-Black"];
    [ViewHelper setCustomFont:self.needDriversLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.needDriversPeopleLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.searchButton.titleLabel fontName:@"Lato-Regular"];
    
    [ViewHelper makeRoundedView:self.numPeopleBg];
    self.searchButton.layer.cornerRadius = 5;
    self.searchButton.clipsToBounds = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
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
        ManageDriversTableViewController *viewController = (ManageDriversTableViewController*)segue.destinationViewController;
        viewController.managedObjectContext = self.managedObjectContext;
    } else if ([[segue identifier] isEqualToString:@"ShowResults"]) {
        [self.loadingView removeFromSuperview];
        
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        navigationController.modalPresentationStyle = UIModalPresentationCustom;
        navigationController.transitioningDelegate = self;

        ResultsViewController *vc = (ResultsViewController*)[navigationController topViewController];
        vc.searchResults = self.searchResults;
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

- (void)doSearch
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TripSpecification *tripSpec = [[TripSpecification alloc] init:[self personCount] possibleDrivers:self.drivers];
        self.searchResults = [self.tripService buildTrip:tripSpec];
        self.driversLoaded = YES;
        NSLog(@"Drivers loaded: %i", self.searchResults.count);
    });
}

- (IBAction)search:(UIButton *)sender
{
    [self.navigationController.view addSubview:self.dimmerView];
    [self.navigationController.view addSubview:self.loadingView];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@250);
        make.height.equalTo(@250);
        make.centerX.equalTo(self.navigationController.view.mas_centerX);
        make.centerY.equalTo(self.navigationController.view.mas_centerY);
    }];
    
    self.dimmerView.alpha = 0;
    self.loadingView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.dimmerView.alpha = 0.6;
        self.loadingView.transform = CGAffineTransformMakeScale(1, 1);
    }];

    self.driversLoaded = NO;
    self.animCount = 0;
    [self animateQuestionBang:sender];
    
    [self doSearch];
}

-(void) animateQuestionBang:(UIButton *)sender
{
    self.questionBang.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
        self.questionBang.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        self.animCount++;
        
        NSLog(@"Completed %i animation", self.animCount);
        
        if (self.animCount < self.minAnims || !self.driversLoaded) {
            NSLog(@"Restarting animation");
            [self animateQuestionBang:sender];
            return;
        }
        if (self.animCount >= self.minAnims && self.driversLoaded) {
            NSLog(@"Seguing to results");
            [self performSegueWithIdentifier:@"ShowResults" sender:sender];
            return;
        }
        NSLog(@"Min anims complete, waiting for drivers");
    }];
}

- (void)unDimScreen
{
    [self.dimmerView removeFromSuperview];
}


#pragma mark - UIViewControllerTransitioningDelegate

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[SearchPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    FadeTransitionAnimator *animator = [[FadeTransitionAnimator alloc] init];
    animator.appearing = YES;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    FadeTransitionAnimator *animator = [[FadeTransitionAnimator alloc] init];
    animator.appearing = NO;
    return animator;
}

@end
