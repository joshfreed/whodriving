//
//  VerticalFlowLayout.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/10/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "VerticalFlowLayout.h"

@implementation VerticalFlowLayout

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
//    attr.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
//    attr.transform = CGAffineTransformMakeScale(0.1, 0.1);
    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), self.collectionView.bounds.size.height);
    
    return attr;
}
//
//-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    
//    attr.transform = CGAffineTransformIdentity;
//    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//    
//    return attr;
//}

@end
