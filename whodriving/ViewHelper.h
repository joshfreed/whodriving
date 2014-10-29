//
//  ViewHelper.h
//  Who's Driving?!
//
//  Created by Josh Freed on 10/28/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewHelper : NSObject
+ (void)makeRoundedView:(UIView*)view;
+ (void)setCustomFont:(UILabel*)label fontName:(NSString*)fontName;
@end
