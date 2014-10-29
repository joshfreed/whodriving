//
//  ViewHelper.m
//  Who's Driving?!
//
//  Created by Josh Freed on 10/28/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "ViewHelper.h"

@implementation ViewHelper

+ (void)makeRoundedView:(UIView*)view
{
    view.layer.cornerRadius = view.frame.size.width / 2;
}

+ (void)setCustomFont:(UILabel*)label fontName:(NSString*)fontName
{
    [label setFont:[UIFont fontWithName:fontName size:label.font.pointSize]];
}

@end
