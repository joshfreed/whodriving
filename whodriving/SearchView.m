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

@property CGFloat fadeInTime;
@property CGFloat fadeOutTime;

@end

@implementation SearchView

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    self.fadeInTime = 0.25;
    self.fadeOutTime = 0.25;
    
    [ViewHelper makeRoundedView:self.numPeopleBg];

    self.searchButton.layer.cornerRadius = self.searchButton.frame.size.width / 12;
    self.searchButton.clipsToBounds = YES;
    
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
    NSNumber *personCount = [NSNumber numberWithInteger:[self.personCountLabel.text integerValue]];
    [self.delegate findDrivers:personCount];
}

-(void)runExitAnimation:(void (^)(void))completion
{
    [UIView animateWithDuration:self.fadeOutTime animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        completion();
    }];

}

-(void)runEntranceAnimation:(void (^)(void))completion
{
    [UIView animateWithDuration:self.fadeInTime animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        completion();
    }];
}


@end
