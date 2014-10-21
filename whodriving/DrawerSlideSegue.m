//
//  DrawerSlideSegue.m
//  whodriving
//
//  Created by Josh Freed on 10/20/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "DrawerSlideSegue.h"

@implementation DrawerSlideSegue

- (void)perform
{
    UIViewController *src = (UIViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    [dst.view setFrame:CGRectMake(375, 0, dst.view.frame.size.width, dst.view.frame.size.height)];
    
    [src addChildViewController:dst];
    [src.view addSubview:dst.view];
    [dst didMoveToParentViewController:src];
    
    [UIView animateWithDuration:0.3 animations:^{
        [dst.view setFrame:CGRectMake(30, 0, src.view.frame.size.width, src.view.frame.size.height)];
    }];
}

@end
