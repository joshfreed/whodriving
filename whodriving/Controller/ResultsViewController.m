//
//  ResultsViewController.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/28/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "ResultsViewController.h"
#import "ViewHelper.h"
#import "TripService.h"
#import "DriverResultCollectionViewCell.h"

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *startOverButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *questionBang;
@property (weak, nonatomic) IBOutlet UIView *notEnoughDriversView;

@property TripService *tripService;
@property NSMutableArray *searchResults;
@property BOOL alreadySearched;
@property NSTimer *nsTimer;
@property double numDrivers;

@end

@implementation ResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.tripService = [[TripService alloc] init];
    self.searchResults = [NSMutableArray array];
    self.alreadySearched = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [ViewHelper setCustomFont:self.backButton.titleLabel fontName:@"Lato"];
    self.backButton.layer.cornerRadius = 5;
    self.backButton.clipsToBounds = YES;
    
    [ViewHelper setCustomFont:self.startOverButton.titleLabel fontName:@"Lato"];
    self.startOverButton.layer.cornerRadius = 5;
    self.startOverButton.clipsToBounds = YES;
    
    [self showLoadingScreen];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self doSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSearch
{
    // Prevents a bug where the search results would get added to the list twice.
    // Happened if the user swiped right to go back to the search screen but let go before swiping all the way.
    if (self.alreadySearched) {
        return;
    }
    
    NSArray *searchResults = [self.tripService buildTrip:self.tripSpec];
    self.numDrivers = searchResults.count;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.questionBang.alpha = 0;
        self.startOverButton.alpha = 1;
        self.backButton.alpha = 1;
    }];
    
    if (searchResults.count > 0) {
        self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(addResult:) userInfo:searchResults repeats:YES];
    } else {
        // No drivers found! Show a error message
        self.notEnoughDriversView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.notEnoughDriversView.alpha = 1;
        }];
    }
    
    self.alreadySearched = YES;
}

- (void)addResult:(NSTimer*)timer
{
    NSArray *searchResults = timer.userInfo;
    NSUInteger index = self.searchResults.count;
    [self.searchResults addObject:[searchResults objectAtIndex:index]];
    [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
    if (self.searchResults.count == searchResults.count) {
        [self.nsTimer invalidate];
        [self.collectionView flashScrollIndicators];
    }
}

- (UICollectionViewFlowLayout*)flowLayout
{
    return (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
}

- (void)showLoadingScreen
{
    // Prevents a bug where the search results would get added to the list twice.
    // Happened if the user swiped right to go back to the search screen but let go before swiping all the way.
    if (self.alreadySearched) {
        return;
    }
    
    self.notEnoughDriversView.alpha = 0;
    self.startOverButton.alpha = 0;
    self.backButton.alpha = 0;
    self.questionBang.alpha = 1;
    
    self.questionBang.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.questionBang.transform = CGAffineTransformMakeScale(1.3, 1.3);
                     }
                     completion:NULL];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

- (IBAction)goBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startOver:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DriverResultCollectionViewCell* newCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"DriverResultCell" forIndexPath:indexPath];
    [ViewHelper setCustomFont:newCell.driverNameLabel fontName:@"Lato-Regular"];
    newCell.driverNameLabel.text = ((Driver*)[self.searchResults objectAtIndex:indexPath.row]).driverName;
    newCell.layer.cornerRadius = 5;
    
    return newCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    UIEdgeInsets inset = flowLayout.sectionInset;
    CGSize size = flowLayout.itemSize;
    
    double desiredHeight = self.collectionView.frame.size.height;
    desiredHeight -= flowLayout.sectionInset.top;
    desiredHeight -= flowLayout.sectionInset.bottom;
    desiredHeight -= (self.numDrivers - 1) * flowLayout.minimumLineSpacing;
    desiredHeight /= self.numDrivers;
    desiredHeight = MIN(desiredHeight, 160);

    size.width = self.collectionView.frame.size.width - inset.left - inset.right;
    size.height = MAX(desiredHeight, size.height);

//    NSLog(@"%f, %f", size.width, size.height);
    return size;
}


@end
