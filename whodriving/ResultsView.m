//
//  ResultsView.m
//  Who's Driving?!
//
//  Created by Josh Freed on 12/13/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "ResultsView.h"
#import "ViewHelper.h"
#import "TripService.h"
#import "Driver.h"

@interface ResultsView ()
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property NSArray *driverLabels;
@end

@implementation ResultsView

-(void)awakeFromNib
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.driverLabels = [NSArray array];
}

-(void)viewWillAppear
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
    
    [ViewHelper setCustomFont:self.doneButton.titleLabel fontName:@"Lato-Regular"];
    
    TripService *tripService = [[TripService alloc] init];
    NSArray *drivingDrivers = [tripService buildTrip:self.tripSpec];
    [self displayDrivers:drivingDrivers];
}

-(void)displayDrivers:(NSArray*)drivingDrivers
{
    [self.driverLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int i = 0;
    
    UIView *spacer1 = [UIView new];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
    //    spacer1.backgroundColor = [UIColor grayColor];
    [self addSubview:spacer1];
    
    UIView *spacer2 = [UIView new];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
    //    spacer2.backgroundColor = [UIColor brownColor];
    [self addSubview:spacer2];
    
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:spacer1
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.superview
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:spacer2
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.superview
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
        [self addSubview:driverLabel];
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
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
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
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-[%@]-|", viewName]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDictionary] ];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:driverLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        i++;
    }
    
    self.driverLabels = labels;
    
//    for (UILabel *driverLabel in labels) {
//        NSLog(@"Intrinsic: %f, %f  Size: %f, %f", driverLabel.intrinsicContentSize.width, driverLabel.intrinsicContentSize.height, driverLabel.frame.size.width, driverLabel.frame.size.height);
//    }

}

- (IBAction)doneButton:(UIButton *)sender
{
    [self.delegate done];
}

@end
