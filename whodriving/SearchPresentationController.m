//
//  SearchPresentationController.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/7/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "SearchPresentationController.h"
#import "MainViewController.h"

@interface SearchPresentationController ()

@end

@implementation SearchPresentationController

-(void)dismissalTransitionDidEnd:(BOOL)completed
{
    // This is bad, I shouldn't be coupling this transition to a specific view controller
    [(MainViewController*)[(UINavigationController*)self.presentingViewController topViewController] unDimScreen];
}

@end
