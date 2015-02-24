//
//  VerticalFlowLayout.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/10/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "DriverResultsFlowLayout.h"

@implementation DriverResultsFlowLayout

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attr.center = CGPointMake(attr.center.x + attr.bounds.size.width * 1.5, attr.center.y);
    return attr;
}

@end
