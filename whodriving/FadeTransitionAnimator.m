//
//  FadeTransitionAnimator.m
//  Who's Driving?!
//
//  Created by Josh Freed on 1/15/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "FadeTransitionAnimator.h"

@interface FadeTransitionAnimator ()
@property CGFloat duration;
@end

@implementation FadeTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.duration = 0.3;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.appearing) {
        [transitionContext.containerView addSubview:toVC.view];

        CGRect frame = CGRectMake((toVC.view.frame.size.width / 2) - 8, (toVC.view.frame.size.height / 2) - 8, 16, 16);
        NSLog(@"%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        NSLog(@"%f, %f, %f, %f", toVC.view.frame.origin.x, toVC.view.frame.origin.y, toVC.view.frame.size.width, toVC.view.frame.size.height);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithOvalInRect:frame];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = toVC.view.frame;
        maskLayer.path = maskPath.CGPath;
        toVC.view.layer.mask = maskLayer;
        
        CGRect newRect = CGRectMake(
            -toVC.view.frame.size.width / 2,
            -toVC.view.frame.size.height / 3,
             toVC.view.frame.size.width * 2,
             toVC.view.frame.size.height + (toVC.view.frame.size.height * 0.667)
        );
        
        NSLog(@"%f, %f, %f, %f", newRect.origin.x, newRect.origin.y, newRect.size.width, newRect.size.height);

        UIBezierPath *newPath = [UIBezierPath bezierPathWithOvalInRect:newRect];
        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
        pathAnim.fromValue = (id)maskPath.CGPath;
        pathAnim.toValue = (id)newPath.CGPath;
        pathAnim.duration = self.duration;
        maskLayer.path = newPath.CGPath;
        [maskLayer addAnimation:pathAnim forKey:@"path"];
    } else {
        CGRect startRect = CGRectMake(
            -toVC.view.frame.size.width / 2,
            -toVC.view.frame.size.height / 3,
            toVC.view.frame.size.width * 2,
            toVC.view.frame.size.height + (toVC.view.frame.size.height * 0.667)
        );
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = fromVC.view.frame;
        maskLayer.path = maskPath.CGPath;
        fromVC.view.layer.mask = maskLayer;
        
        CGRect newRect = CGRectMake((toVC.view.frame.size.width / 2) - 8, (toVC.view.frame.size.height / 2) - 8, 16, 16);
        UIBezierPath *newPath = [UIBezierPath bezierPathWithOvalInRect:newRect];
        CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
        pathAnim.fromValue = (id)maskPath.CGPath;
        pathAnim.toValue = (id)newPath.CGPath;
        pathAnim.duration = self.duration;
        maskLayer.path = newPath.CGPath;
        [maskLayer addAnimation:pathAnim forKey:@"path"];
    }
    
    [self performSelector:@selector(finishTransition:) withObject:transitionContext afterDelay:self.duration];
}

-(void)finishTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:YES];
}

@end
