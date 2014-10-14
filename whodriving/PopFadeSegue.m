//
//  PopFadeSegue.m
//  whodriving
//
//  Created by Josh Freed on 10/14/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "PopFadeSegue.h"

@implementation PopFadeSegue

- (void)perform
{
    [((UIViewController*)[self destinationViewController]).view viewWithTag:1].alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        [((UIViewController*)[self sourceViewController]).view viewWithTag:1].alpha = 0.0f;
    } completion:^(BOOL finished){
        [((UIViewController*)[self sourceViewController]).navigationController popViewControllerAnimated:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [((UIViewController*)[self destinationViewController]).view viewWithTag:1].alpha = 1.0f;
        }];
    }];
}

@end
