//
//  PLCollectionViewFlowLayout.m
//  PLScrollView
//
//  Created by Pello on 2018/7/2.
//  Copyright © 2018年 pello. All rights reserved.
//

#import "PLCollectionViewFlowLayout.h"

@implementation PLCollectionViewFlowLayout

#pragma mark - Override
/**
 Override method
 Set the property value here
 */
- (void)prepareLayout
{
    // must call the parent class method
    [super prepareLayout];
    
    self.minimumInteritemSpacing = 0.0f;
}

/**
 Override method

 @param newBounds no need
 @return return YES to cause the collection view to requery the layout for geometry information
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 Override method
 layout display cell of the distance meet the condition of center.x and collectionView.center.x

 @param rect current display collectionView rect
 @return return an array layout attributes instances for all the views in the given rect
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // get super layout attributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];

    // get visible rect of collectionView
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    // traverse all cell layoutAttributes, layout cell according to the distance between the centers
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        // the distance of the cell.center.x with collectionView.center.x
        CGFloat distance = ABS(CGRectGetMidX(visibleRect) - attributes.center.x);
        
        // determine whether the currently visible cell intersects with react
        if (CGRectIntersectsRect(attributes.frame, rect))
        {
            if (ABS(distance) < self.activeDistance)
            {
                // generate the scale
                CGFloat scale = self.maxScale - distance / self.activeDistance * (self.maxScale - 1.0);
                CATransform3D transfrom = CATransform3DIdentity;
                transfrom = CATransform3DScale(transfrom, scale, scale, scale);
                attributes.transform3D = transfrom;
                attributes.zIndex = 1;
            }
            else
            {
                // the distance not match
                attributes.transform3D = CATransform3DIdentity;
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}

/**
 Override method

 @param proposedContentOffset taget point with stopping
 @param velocity the stop velocity
 @return return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // get proposed rect with proposedContentOffset.x and collectionView.size
    CGRect proposedRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    // get all displayed cell layoutAttributes in proposedRect
    NSArray* array = [super layoutAttributesForElementsInRect:proposedRect];
    
    // the minimum distance from the center of the collectionView used to identify the center of all cells
    CGFloat minOffsetX = MAXFLOAT;
    
    // the center of the collectionView
    CGFloat horizontalCenter = proposedContentOffset.x + self.collectionView.frame.size.width / 2.0;
    
    // traverse all cell layoutAttributes, find the minmum distance of the cell
    for (UICollectionViewLayoutAttributes* layoutAttributes in array)
    {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        
        // center difference absolute value
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(minOffsetX))
        {
            // update min distance
            minOffsetX = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    // return the point of stopping
    return CGPointMake(proposedContentOffset.x + minOffsetX, proposedContentOffset.y);
}

@end
