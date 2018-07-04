//
//  PLCollectionViewFlowLayout.h
//  PLScrollView
//
//  Created by Pello on 2018/7/2.
//  Copyright © 2018年 pello. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 center cell enlarge max scale
 */
@property (nonatomic, assign) CGFloat maxScale;

/**
 how far away from the center point is to start zooming in or out of the cell. default is 200.0f.
 */
@property (nonatomic, assign) CGFloat activeDistance;

@end
