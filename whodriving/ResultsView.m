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
@property (weak, nonatomic) IBOutlet UIScrollView *driverNamesContainer;
@end

@implementation ResultsView

-(void)viewWillAppear
{
    [super viewWillAppear];
    
    [ViewHelper setCustomFont:self.doneButton.titleLabel fontName:@"Lato-Regular"];
    
    TripService *tripService = [[TripService alloc] init];
    NSArray *drivingDrivers = [tripService buildTrip:self.tripSpec];
    [self displayDrivers:drivingDrivers];
}

-(void) viewDidLayoutSubviews
{
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.driverNamesContainer.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    [self.driverNamesContainer setContentSize:(CGSizeMake(self.driverNamesContainer.frame.size.width, scrollViewHeight))];
}

-(void)displayDrivers:(NSArray*)drivingDrivers
{
    [[self.driverNamesContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int i = 0;
    
    UIView *spacer1 = [UIView new];
    spacer1.translatesAutoresizingMaskIntoConstraints = NO;
//    spacer1.backgroundColor = [UIColor grayColor];
    [self.driverNamesContainer addSubview:spacer1];
    
    UIView *spacer2 = [UIView new];
    spacer2.translatesAutoresizingMaskIntoConstraints = NO;
//    spacer2.backgroundColor = [UIColor brownColor];
    [self.driverNamesContainer addSubview:spacer2];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:spacer1
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.driverNamesContainer
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:spacer2
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
            [vFormat appendFormat:@"-16-[%@]", viewName];
        }
        
        i++;
    }
    [vFormat appendString:@"[spacer2(==spacer1)]|"];
    [self.driverNamesContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:viewsDictionary]];
    
    i = 0;
    for (UILabel *driverLabel in labels) {
        NSString *viewName = [NSString stringWithFormat:@"driverLabel%i", i];
        
        [driverLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[%@(30)]", viewName]
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary]];
        [self.driverNamesContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[%@]-0-|", viewName]
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
    
//    NSLog(vFormat);
    
    /*
    for (UILabel *driverLabel in labels) {
        float widthIs = [driverLabel.text boundingRectWithSize:driverLabel.frame.size
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{ NSFontAttributeName:driverLabel.font }
                                                       context:nil].size.width;
        NSLog(@"the width of yourLabel is %f", widthIs);
        float otherWidth = [driverLabel.text sizeWithAttributes:@{NSFontAttributeName: driverLabel.font}].width;
        NSLog(@"%f", otherWidth);
        NSLog(@"%f", driverLabel.intrinsicContentSize.width);
    }
    
    NSLog(@"Container: %f, @ %f = %f", self.driverNamesContainer.frame.size.width, [UIScreen mainScreen].scale, self.driverNamesContainer.frame.size.width * [UIScreen mainScreen].scale);
    NSLog(@"VIEW: %f, @ %f = %f", self.frame.size.width, [UIScreen mainScreen].scale, self.frame.size.width * [UIScreen mainScreen].scale);
     */
    
//    NSLog(@"%f, %f", self.driverNamesContainer.frame.size.width, self.driverNamesContainer.frame.size.height);

}

- (IBAction)doneButton:(UIButton *)sender
{
    [self.delegate done];
}

@end
