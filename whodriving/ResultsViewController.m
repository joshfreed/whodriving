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

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *driverNamesContainer;
@property CGFloat driverNameHeight;
@property CGFloat scrollViewContentHeight;
@property CGFloat spacerHeight;
@end

@implementation ResultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.driverNameHeight = 30;
}

- (void)viewWillAppear:(BOOL)animated
{
    // animate names in
    // they will start animating while the transition is still happening
    
    [self clearDriverNamesContainer];
    
    NSArray *drivingDrivers = self.searchResults;
    if (drivingDrivers.count > 0) {
        self.scrollViewContentHeight = (drivingDrivers.count * self.driverNameHeight) + ((drivingDrivers.count - 1) * 16);
        
        // Determine spacer heights
        // Because it's a UIScollView I can't just pin the spacers to the top and bottom of the super view, and to the driver labels
        if (self.scrollViewContentHeight < self.driverNamesContainer.frame.size.height) {
            CGFloat extraHeight = self.driverNamesContainer.frame.size.height - self.scrollViewContentHeight;
            self.spacerHeight = extraHeight / 2;
        }
        
        drivingDrivers = [drivingDrivers sortedArrayUsingSelector:@selector(sortByName:)];
        
        [self displayDrivers:drivingDrivers];
        
        [self.driverNamesContainer setContentSize:(CGSizeMake(self.driverNamesContainer.frame.size.width, self.scrollViewContentHeight))];
        [self.driverNamesContainer flashScrollIndicators];
    } else {
        self.scrollViewContentHeight = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UIView *spacer1 = [UIView new];
//    spacer1.backgroundColor = [UIColor grayColor];
    [self.driverNamesContainer addSubview:spacer1];
    
    UIView *spacer2 = [UIView new];
//    spacer2.backgroundColor = [UIColor brownColor];
    [self.driverNamesContainer addSubview:spacer2];
    
    NSMutableArray *labels = [NSMutableArray array];
    for (Driver *driver in drivingDrivers) {
        UILabel *driverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
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
    
    UILabel *lastDriver = [labels lastObject];
    UILabel *firstDriver = [labels firstObject];
    
    [spacer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo([NSNumber numberWithFloat:self.spacerHeight]);
        make.centerX.equalTo(self.driverNamesContainer.mas_centerX);
        make.top.equalTo(self.driverNamesContainer.mas_top);
        make.bottom.equalTo(firstDriver.mas_top);
    }];
    
    [spacer2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo([NSNumber numberWithFloat:self.spacerHeight]);
        make.centerX.equalTo(self.driverNamesContainer.mas_centerX);
        make.top.equalTo(lastDriver.mas_bottom);
        make.bottom.equalTo(self.driverNamesContainer.mas_bottom);
    }];
    
    UIView *prevLabel;
    for (UILabel *driverLabel in labels) {
        [driverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo([NSNumber numberWithFloat:self.driverNameHeight]);
            make.leading.equalTo(@32);
            make.trailing.equalTo(@32);
            make.centerX.equalTo(self.driverNamesContainer.mas_centerX);
            
            if (prevLabel) {
                make.top.equalTo(prevLabel.mas_bottom).with.offset(16);
            }
        }];
        
        prevLabel = driverLabel;
    }
}


@end
