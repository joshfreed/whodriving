//
//  WelcomeView.h
//  Who's Driving?!
//
//  Created by Josh Freed on 12/3/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelcomeViewDelegate;

@interface WelcomeView : UIView

@property (nonatomic, weak) id<WelcomeViewDelegate> delegate;

-(void)viewWillAppear;

@end

@protocol WelcomeViewDelegate <NSObject>

- (void)showManageDrivers;

@end
