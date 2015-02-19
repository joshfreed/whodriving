//
//  VerticalFlowLayout.m
//  Who's Driving?!
//
//  Created by Josh Freed on 2/10/15.
//  Copyright (c) 2015 Josh Freed. All rights reserved.
//

#import "VerticalFlowLayout.h"

@implementation VerticalFlowLayout
/*
-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), self.collectionView.bounds.size.height);
    return attr;
}
*/
/*
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    UICollectionViewLayoutAttributes* att = [array lastObject];
    if (att) {
        CGFloat lastY = att.frame.origin.y + att.frame.size.height;
        CGFloat diff = self.collectionView.frame.size.height - lastY;
        
        if (diff > 0) {
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(diff/2, 0.0, 0.0, 0.0);
            self.collectionView.contentInset = contentInsets;
        }
    }
    
    return array;
}
*/
@end
