//
//  SearchView.m
//  Who's Driving?!
//
//  Created by Josh Freed on 12/3/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "SearchView.h"
#import "ViewHelper.h"
#import "Driver.h"
#import "TripSpecification.h"
#import "TripService.h"

@interface SearchView ()

@property (weak, nonatomic) IBOutlet UIView *searchForm;
@property (weak, nonatomic) IBOutlet UIView *numPeopleBg;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversLabel;
@property (weak, nonatomic) IBOutlet UILabel *needDriversPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *resultsView;

@end

@implementation SearchView

-(void)awakeFromNib
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)viewWillAppear
{
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.superview
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.superview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.superview
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.superview layoutIfNeeded];
    
    [ViewHelper makeRoundedView:self.numPeopleBg];
    
    [ViewHelper setCustomFont:self.personCountLabel fontName:@"Lato-Black"];
    [ViewHelper setCustomFont:self.needDriversLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.needDriversPeopleLabel fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.searchButton.titleLabel fontName:@"Lato-Regular"];
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

- (IBAction)findMeDrivers:(UIButton *)sender
{
//    [self showAnimatedSearchResults];
    NSNumber *personCount = [NSNumber numberWithInteger:[self.personCountLabel.text integerValue]];
    [self.delegate findDrivers:personCount];
}

-(void)showAnimatedSearchResults
{
    UIView *view = self;
    [view layoutIfNeeded];
    
    [view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop){
        if (constraint.firstItem == self.searchButton && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondItem == self.searchForm) {
            [constraint setActive:NO];
        }
        if (constraint.secondItem == self.searchForm && constraint.secondAttribute == NSLayoutAttributeBottom && constraint.firstItem == self) {
            [constraint setActive:NO];
        }
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    NSNumber *personCount = [NSNumber numberWithInteger:[self.personCountLabel.text integerValue]];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:personCount possibleDrivers:self.drivers];
    TripService *tripService = [[TripService alloc] init];
    NSArray *drivingDrivers = [tripService buildTrip:tripSpec];
    [self updateDriverResults:drivingDrivers];
}

- (void)updateDriverResults:(NSArray *)drivingDrivers
{
    [[self.resultsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int i = 0;
    
    UIView *spacer1 = [UIView new];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
    //    spacer1.backgroundColor = [UIColor grayColor];
    [self.resultsView addSubview:spacer1];
    
    UIView *spacer2 = [UIView new];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
    //    spacer2.backgroundColor = [UIColor brownColor];
    [self.resultsView addSubview:spacer2];
    
    [self.resultsView addConstraint:[NSLayoutConstraint constraintWithItem:spacer1
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.resultsView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    [self.resultsView addConstraint:[NSLayoutConstraint constraintWithItem:spacer2
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.resultsView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    [spacer1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[spacer1(10)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"spacer1": spacer1}]];
    [spacer2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[spacer2(10)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"spacer2": spacer2}]];
    
    NSMutableArray *labels = [NSMutableArray array];
    for (Driver *driver in drivingDrivers) {
        UILabel *driverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
        driverLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [driverLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:45]];
        [driverLabel setTextColor:UIColorFromRGB(0x444444)];
        [driverLabel setText:driver.driverName];
        [driverLabel setTextAlignment:NSTextAlignmentCenter];
        [driverLabel setMinimumScaleFactor:0.1];
        [driverLabel setAdjustsFontSizeToFitWidth:YES];
        [driverLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.resultsView addSubview:driverLabel];
        [labels addObject:driverLabel];
    }
    
    i = 0;
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
    [viewsDictionary setValue:spacer1 forKey:@"spacer1"];
    [viewsDictionary setValue:spacer2 forKey:@"spacer2"];
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        [viewsDictionary setValue:driverLabel forKey:viewName];
        i++;
    }
    
    i = 0;
    NSMutableString *vFormat = [NSMutableString stringWithString:@"V:|[spacer1]"];
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        
        if (i == 0) {
            [vFormat appendFormat:@"[%@]", viewName];
        } else {
            [vFormat appendFormat:@"-15-[%@]", viewName];
        }
        
        i++;
    }
    [vFormat appendString:@"[spacer2(==spacer1)]|"];
    [self.resultsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    i = 0;
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        
        [driverLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(60)]", viewName]
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
        [self.resultsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-[%@]-|", viewName]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary] ];
        [self.resultsView addConstraint:[NSLayoutConstraint constraintWithItem:driverLabel
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.resultsView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1
                                                                      constant:0]];
        i++;
    }
    
    for (UILabel *driverLabel in labels) {
        NSLog(@"Intrinsic: %f, %f  Size: %f, %f", driverLabel.intrinsicContentSize.width, driverLabel.intrinsicContentSize.height, driverLabel.frame.size.width, driverLabel.frame.size.height);
    }
    //    NSLog(vFormat);
}

@end
