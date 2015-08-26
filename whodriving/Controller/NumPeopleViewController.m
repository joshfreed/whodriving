//
//  NumPeopleViewController.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/27/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "NumPeopleViewController.h"
#import "ViewHelper.h"
#import "PotentialDriversViewController.h"
#import "TripSpecification.h"
#import "Masonry.h"

@interface NumPeopleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;
@property (weak, nonatomic) IBOutlet UIView *numPeopleBgCircle;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *numPeopleCounter;

@property WelcomeView *welcomeView;
@property UIView *fadeView;
@property TripSpecification *tripSpec;

@end

@implementation NumPeopleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tripSpec = [TripSpecification new];
    
    self.welcomeView = [[[NSBundle mainBundle] loadNibNamed:@"WelcomeView" owner:self options:nil] objectAtIndex:0];
    self.welcomeView.delegate = self;
    self.welcomeView.layer.cornerRadius = 5;
    self.welcomeView.clipsToBounds = YES;
    
    self.fadeView = [[UIView alloc] initWithFrame:self.view.frame];
    self.fadeView.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [ViewHelper setCustomFont:self.numPeopleLabel fontName:@"Lato"];
    [ViewHelper setCustomFont:self.nextButton.titleLabel fontName:@"Lato"];
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.clipsToBounds = YES;
    [ViewHelper makeRoundedView:self.numPeopleBgCircle];
    [ViewHelper setCustomFont:self.numPeopleCounter fontName:@"Lato-Black"];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        UIView *parentView = [[UIApplication sharedApplication] keyWindow];
        [parentView addSubview:self.fadeView];
        [parentView addSubview:self.welcomeView];
        
        [self.fadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView);
        }];
        
        [self.welcomeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView).insets(UIEdgeInsetsMake(60, 24, 60, 24));
        }];
        
        self.fadeView.alpha = 0;
        self.welcomeView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.fadeView.alpha = 0.8;
            self.welcomeView.alpha = 1;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPotentialDrivers"]) {
        PotentialDriversViewController *vc = [segue destinationViewController];
        vc.managedObjectContext = self.managedObjectContext;
        vc.tripSpec = self.tripSpec;
    }
}

- (IBAction)increaseNumPeople:(UIButton *)sender
{
    [self.tripSpec increasePersonCount];
    [self.numPeopleCounter setText:[NSString stringWithFormat:@"%ld", (long)self.tripSpec.passengerCount]];
}

- (IBAction)decreaseNumPeople:(UIButton *)sender
{
    [self.tripSpec decreasePersonCount];
    [self.numPeopleCounter setText:[NSString stringWithFormat:@"%ld", (long)self.tripSpec.passengerCount]];
}

- (void)closeWelcomeView
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.fadeView.alpha = 0;
        self.welcomeView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.fadeView removeFromSuperview];
        [self.welcomeView removeFromSuperview];
    }];
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
