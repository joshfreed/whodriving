//
//  WelcomeView.h
//  Who's Driving?!
//
//  Created by Josh Freed on 12/3/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoshView.h"

@protocol WelcomeViewDelegate;

@interface WelcomeView : JoshView
@property (nonatomic, weak) id<WelcomeViewDelegate> delegate;
@end

@protocol WelcomeViewDelegate <NSObject>
- (void)showManageDrivers;
@end
