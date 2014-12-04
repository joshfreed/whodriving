//
//  WelcomeView.m
//  Who's Driving?!
//
//  Created by Josh Freed on 12/3/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "WelcomeView.h"
#import "ViewHelper.h"

@interface WelcomeView ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UIButton *addDriversButton;

@end

@implementation WelcomeView

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
    
    [ViewHelper setCustomFont:self.textLabel1 fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.textLabel2 fontName:@"Lato-Regular"];
    [ViewHelper setCustomFont:self.addDriversButton.titleLabel fontName:@"Lato-Regular"];
}

- (IBAction)showManageDriversScreen:(UIButton *)sender
{
    [self.delegate showManageDrivers];
}

@end
