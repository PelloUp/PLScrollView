//
//  PLScrollView.h
//  PLScrollView
//
//  Created by Pello on 2018/7/2.
//  Copyright © 2018年 pello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLScrollViewProtocol.h"

@interface PLScrollView : UIView

/**
 delegate
 */
@property (nonatomic, weak) id<PLScrollViewDelegate> delegate;

///////////////////////////////////////////////////////////////////////////////
//////////////////////    Data Source API    //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/**
 data sources, only read
 */
@property (nonatomic, strong, readonly) NSArray *dataList;

////////////////////////////////////////////////////////////////////////////////
//////////////////////    UICollectionViewFlowLayout API    ////////////////////
////////////////////////////////////////////////////////////////////////////////
/**
 the margin between cells, this margin not real margin, only user sees. default is 40.0f.
 */
@property (nonatomic, assign) CGFloat itemMargin;

/**
 the margin of the cell on both sides of the middle cell. default is 20.0f.
 */
@property (nonatomic, assign) CGFloat exposedOffset;

/**
 the maximum multiple of the intermediate cell amplification. default is 1.2f.
 */
@property (nonatomic, assign) CGFloat maxScale;

/**
 how far away from the center point is to start zooming in or out of the cell. default is 200.0f.
 */
@property (nonatomic, assign) CGFloat activeDistance;


///////////////////////////////////////////////////////////////////////////////
//////////////////////    UICollectionView Scroll API    //////////////////////
///////////////////////////////////////////////////////////////////////////////
/**
 Automatic scrolling interval, default is 2s.
 */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/**
 infinite scrolling, default is NO.
 */
@property (nonatomic, assign) BOOL infiniteScroll;

/**
 auto scrolling, default is NO.
 */
@property (nonatomic, assign) BOOL autoScroll;

/**
 scroll direction, default is horizontal.
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/**
 scroll to index

 @param index index
 */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;

#pragma mark - Public Method
/**
 initialize PLScrollView

 @param dataList data source
 @return instancetype
 */
+ (instancetype)scrollViewWithDataList:(NSArray *)dataList;

/**
 initialize PLScrollView with frame

 @param frame frame
 @param dataList data source
 @return instancetype
 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame dataList:(NSArray *)dataList;

/**
 initialize PLScrollView with frame and delegate

 @param frame frame
 @param delegate delegate
 @param dataList data source
 @return instancetype
 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame delegate:(id<PLScrollViewDelegate>)delegate dataList:(NSArray *)dataList;


///////////////////////////////////////////////////////////////////////////////
//////////////////////    UICollectionView Custom Cell API    //////////////////////
///////////////////////////////////////////////////////////////////////////////
/**
 return reusable cell

 @param index index
 @return reusable cell
 */
- (__kindof UICollectionViewCell *)dequeueReusableCellWithIndex:(NSInteger)index;

/**
 reloads all of the data for the scrollView.
 */
- (void)reloadData;

/**
 clear cache
 */
- (void)clearCache;
+ (void)clearImagesCache;


@end
