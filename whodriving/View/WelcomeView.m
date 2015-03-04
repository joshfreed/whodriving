//
//  WelcomeView.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/28/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "WelcomeView.h"
#import "ViewHelper.h"

@interface WelcomeView ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *theButton;
@end

@implementation WelcomeView

- (void)awakeFromNib
{

}

- (void)layoutSubviews
{
    [ViewHelper setCustomFont:self.label1 fontName:@"Lato-Light"];
    [ViewHelper setCustomFont:self.label2 fontName:@"Lato-Light"];
    [ViewHelper setCustomFont:self.label3 fontName:@"Lato-Light"];
    [ViewHelper setCustomFont:self.label4 fontName:@"Lato-Light"];
    [ViewHelper setCustomFont:self.theButton.titleLabel fontName:@"Lato-Regular"];
    
    self.theButton.layer.cornerRadius = 5;
    self.theButton.clipsToBounds = YES;
}

- (IBAction)closeWindow:(UIButton *)sender
{
    [self.delegate closeWelcomeView];
}

@end
