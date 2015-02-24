//
//  ResultsViewController.m
//  Who's Driving?!
//
//  Created by Josh Freed on 1/15/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "ResultsViewController.h"
#import "ViewHelper.h"
#import "Driver.h"
#import "TripService.h"
#import "Masonry.h"
#import "DriverResultCollectionViewCell.h"

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property TripService *tripService;
@property CGFloat driverNameHeight;
@property NSMutableArray *searchResults;
@property UIView *loadingView;
@property UIImageView *questionBang;
@property NSTimer *nsTimer;
@property BOOL alreadySearched;
@property UIView *notEnoughDriversView;
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
    
//    [self.collectionView.viewForBaselineLayout.layer setSpeed:0.8f];
    
    self.notEnoughDriversView = [[[NSBundle mainBundle] loadNibNamed:@"NotEnoughDriversView" owner:self options:nil] objectAtIndex:0];

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

- (void)viewWillAppear:(BOOL)animated
{
    // Prevents a bug where the search results would get added to the list twice.
    // Happened if the user swiped right to go back to the search screen but let go before swiping all the way.
    if (self.alreadySearched) {
        return;
    }
    
    self.loadingView.alpha = 1;
    [self.view addSubview:self.loadingView];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@250);
        make.height.equalTo(@250);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    self.questionBang.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.questionBang.transform = CGAffineTransformMakeScale(1.3, 1.3);
                     }
                     completion:NULL];
}

- (UICollectionViewFlowLayout*)flowLayout
{
    return (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Prevents a bug where the search results would get added to the list twice.
    // Happened if the user swiped right to go back to the search screen but let go before swiping all the way.
    if (self.alreadySearched) {
        return;
    }
    
    NSArray *searchResults = [self.tripService buildTrip:self.tripSpec];
    self.numDrivers = searchResults.count;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
    
    if (searchResults.count > 0) {
        [self flowLayout].sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
        if (self.numDrivers == 1) {
            CGFloat width = self.collectionView.frame.size.width - [self flowLayout].sectionInset.left - [self flowLayout].sectionInset.right;
            CGFloat height = width; // height and width are the same to make a perfect circle
            CGFloat insetSize = (self.collectionView.frame.size.height - height) / 2;
            [self flowLayout].sectionInset = UIEdgeInsetsMake(insetSize, 16, insetSize, 16);
        }
//        [self.collectionView.collectionViewLayout invalidateLayout];
        
        self.nsTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(addResult:) userInfo:searchResults repeats:YES];
/*
        [self.collectionView performBatchUpdates:^{
            for (int i = 0; i < searchResults.count; i++) {
                [self.searchResults addObject:[searchResults objectAtIndex:i]];
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:i inSection:0]]];
            }
        } completion:^(BOOL finished){
            [self.collectionView flashScrollIndicators];
        }];
*/
    } else {
        // No drivers found! Show a error message
        self.notEnoughDriversView.alpha = 0;
        self.collectionView.backgroundView = self.notEnoughDriversView;
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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    if (self.numDrivers == 1) {
        newCell.layer.cornerRadius = newCell.frame.size.width / 2;
    } else if (self.numDrivers == 2) {
        newCell.layer.cornerRadius = newCell.frame.size.height / 2;
    } else {
        newCell.layer.cornerRadius = 5;
    }

    return newCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    
    double desiredHeight = self.collectionView.frame.size.height;
    desiredHeight -= flowLayout.sectionInset.top;
    desiredHeight -= flowLayout.sectionInset.bottom;
    desiredHeight -= (self.numDrivers - 1) * flowLayout.minimumLineSpacing;
    desiredHeight /= self.numDrivers;

    UIEdgeInsets inset = flowLayout.sectionInset;
    CGSize size = flowLayout.itemSize;
    
    if (self.numDrivers == 1) {
        size.width = self.collectionView.frame.size.width - inset.left - inset.right;
        size.height = size.width;
    } else if (self.numDrivers == 2) {
        size.height = MAX(desiredHeight, size.height);
        size.width = MIN(self.collectionView.frame.size.width - inset.left - inset.right, size.height);
    } else {
        size.width = self.collectionView.frame.size.width - inset.left - inset.right;
        size.height = MAX(desiredHeight, size.height);
    }
//    NSLog(@"%f, %f", size.width, size.height);
    return size;
}

@end
