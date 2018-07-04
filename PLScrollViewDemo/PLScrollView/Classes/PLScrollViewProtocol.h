//
//  PLScrollViewProtocol.h
//  PLScrollView
//
//  Created by Pello on 2018/7/3.
//  Copyright © 2018年 pello. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLScrollView;
@protocol PLScrollViewDelegate <NSObject>

@optional

/**
 select one cell
 
 @param scrollView PLScrollView
 @param index index
 */
- (void)scrollView:(PLScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;

/**
 scroll to index
 
 @param scrollView PLScrollView
 @param index index
 */
- (void)scrollView:(PLScrollView *)scrollView didScrollToIndex:(NSInteger)index;

//////////////////////    Custom Cell API    //////////////////////////////////

// if you want to customize the cell, please implement these method.

/**
 first method. implement this method for registing UICollectionViewCell
 
 @param scrollView PLScrollView
 @return UICollectionViewCell Class
 */
- (Class)customCollectionViewCellClassForScrollView:(PLScrollView *)scrollView;

/**
 second method. implement this method for your custom cell.
 
 @param scrollView if you want to customize the cell, please implement this method
 @param index index
 @return UICollectionViewCell
 */
- (UICollectionViewCell *)scrollView:(PLScrollView *)scrollView cellForItemAtIndex:(NSInteger)index;

@end

