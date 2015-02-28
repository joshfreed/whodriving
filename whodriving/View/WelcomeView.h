//
//  WelcomeView.h
//  Who's Driving?!
//
//  Created by Josh Freed on 2/28/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelcomeViewDelegate;

@interface WelcomeView : UIView
@property (nonatomic, weak) id<WelcomeViewDelegate> delegate;
@end

@protocol WelcomeViewDelegate <NSObject>
- (void)closeWelcomeView;
@end