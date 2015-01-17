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

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIScrollView *driverNamesContainer;
@end

@implementation ResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.doneButton.layer.cornerRadius = self.doneButton.frame.size.width / 12;
    self.doneButton.clipsToBounds = YES;
    
    [self clearDriverNamesContainer];
    
    TripService *tripService = [[TripService alloc] init];
    NSArray *drivingDrivers = [tripService buildTrip:self.tripSpec];
    if (drivingDrivers.count > 0) {
        drivingDrivers = [drivingDrivers sortedArrayUsingSelector:@selector(sortByName:)];
        [self displayDrivers:drivingDrivers];
        [self.driverNamesContainer flashScrollIndicators];
    } else {
        // trip spec failed to find adequate drivers
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [ViewHelper setCustomFont:self.doneButton.titleLabel fontName:@"Lato-Regular"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.driverNamesContainer.subviews) {
        scrollViewHeight += view.frame.size.height;
    }
    [self.driverNamesContainer setContentSize:(CGSizeMake(self.driverNamesContainer.frame.size.width, scrollViewHeight))];
}

- (void)clearDriverNamesContainer
{
    for (NSObject * subview in [[self.driverNamesContainer subviews] copy]) {
        if ([subview isKindOfClass:[UILabel class]]) {
            [(UILabel*)subview removeFromSuperview];
        }
    }
}

-(void)displayDrivers:(NSArray*)drivingDrivers
{
    int i = 0;
    
    UIView *spacer1 = [UIView new];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
    //    spacer1.backgroundColor = [UIColor grayColor];
    [self.driverNamesContainer addSubview:spacer1];
    
    UIView *spacer2 = [UIView new];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
    //    spacer2.backgroundColor = [UIColor brownColor];
    [self.driverNamesContainer addSubview:spacer2];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spacer1
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.driverNamesContainer
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spacer2
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.driverNamesContainer
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
    
    // Build the text labels and add them to the view
    NSMutableArray *labels = [NSMutableArray array];
    for (Driver *driver in drivingDrivers) {
        UILabel *driverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
        driverLabel.translatesAutoresizingMaskIntoConstraints = NO;
        //        [driverLabel setBackgroundColor:[UIColor greenColor]];
        [driverLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:24]];
        [driverLabel setTextColor:UIColorFromRGB(0x444444)];
        [driverLabel setText:driver.driverName];
        [driverLabel setTextAlignment:NSTextAlignmentCenter];
        [driverLabel setMinimumScaleFactor:0.1];
        [driverLabel setAdjustsFontSizeToFitWidth:YES];
        [driverLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.driverNamesContainer addSubview:driverLabel];
        [labels addObject:driverLabel];
    }
    
    // Build the dictionary of labels for constraints
    i = 0;
    NSMutableDictionary *viewsDictionary = [NSMutableDictionary dictionary];
    [viewsDictionary setValue:spacer1 forKey:@"spacer1"];
    [viewsDictionary setValue:spacer2 forKey:@"spacer2"];
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        [viewsDictionary setValue:driverLabel forKey:viewName];
        i++;
    }
    
    // Set label height and width constraints
    i = 0;
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        
        [driverLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(30)]", viewName]
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
        [self.driverNamesContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-32-[%@]-32-|", viewName]
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:viewsDictionary]];
        [self.driverNamesContainer addConstraint:[NSLayoutConstraint constraintWithItem:driverLabel
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.driverNamesContainer
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1
                                                                               constant:0]];
        i++;
    }
    
    // Determine spacer heights
    CGFloat spacerHeight = 0;
    CGFloat labelHeight = 0.0f;
    for (UIView* view in labels) {
        labelHeight += view.frame.size.height;
    }
    labelHeight += (labels.count - 1) * 16;
    //    NSLog(@"Labels Height: %f", labelHeight);
    if (labelHeight < self.driverNamesContainer.frame.size.height) {
        CGFloat extraHeight = self.driverNamesContainer.frame.size.height - labelHeight;
        spacerHeight = extraHeight / 2;
    }
    //    NSLog(@"Spacer Height: %f", spacerHeight);
    [spacer1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[spacer1(%f)]", spacerHeight]
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"spacer1": spacer1}]];
    [spacer2 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[spacer2(%f)]", spacerHeight]
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"spacer2": spacer2}]];
    
    // Build the vertical constraint between the spacers and each text label
    i = 0;
    NSMutableString *vFormat = [NSMutableString stringWithString:@"V:|[spacer1]"];
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        
        if (i == 0) {
            [vFormat appendFormat:@"[%@]", viewName];
        } else {
            [vFormat appendFormat:@"-16-[%@]", viewName];
        }
        
        i++;
    }
    [vFormat appendString:@"[spacer2]|"];
    [self.driverNamesContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:viewsDictionary]];
}

@end
