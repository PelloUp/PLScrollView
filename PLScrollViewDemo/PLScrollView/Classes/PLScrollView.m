//
//  PLScrollView.m
//  PLScrollView
//
//  Created by Pello on 2018/7/2.
//  Copyright © 2018年 pello. All rights reserved.
//

#import "PLScrollView.h"
#import "PLCollectionViewCell.h"
#import "PLCollectionViewFlowLayout.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <SDWebImage/SDWebImageManager.h>

/**
 UICollectionViewCell reuseIdentifier
 */
NSString * const ID = @"PLCollectionViewCellID";

/**
 UICollectionViewCell custom cell reuseIdentifier
 */
NSString * const CUSTOM_ID = @"PLCollectionViewCellCustomCellID";


/**
 get the visible margin of three cells in screen

 @param width UICollectionView.width
 @param lineSpacing the real margin of the user sees
 @param exposedOffset margins exposed on both sides of the cell
 @return the visible margin of three cells in screen
 */
CGFloat PLGetItemMargin(CGFloat width, CGFloat lineSpacing, CGFloat exposedOffset)
{
    return width - exposedOffset * 2 - lineSpacing * 2;
}

/**
 get the minimumLineSpacing of UICollectionViewFlowLayout,This value is greater than the spacing the user sees.

 @param width UICollectionView.width
 @param lineSpacing the real margin of the user sees
 @param exposedOffset margins exposed on both sides of the cell
 @param maxScale center cell will enlarge max scale
 @return the minimumLineSpacing of UICollectionViewFlowLayout
 */
CGFloat PLGetMinimumLineSpacing(CGFloat width, CGFloat lineSpacing, CGFloat exposedOffset, CGFloat maxScale)
{
    return lineSpacing + PLGetItemMargin(width, lineSpacing, exposedOffset) * (1 - 1.0 / maxScale) / 2.0;
}


/**
 get item cell size

 @param size UICollectionView.size
 @param lineSpacing the real margin of the user sees
 @param exposedOffset margins exposed on both sides of the cell
 @param maxScale center cell will enlarge max scale
 @return UICollectionViewFlowLayout.itemSize
 */
CGSize PLGetItemSize(CGSize size, CGFloat lineSpacing, CGFloat exposedOffset, CGFloat maxScale)
{
    return CGSizeMake(PLGetItemMargin(size.width, lineSpacing, exposedOffset) / maxScale, size.height / maxScale);
}

/**
 get UICollectionView contentInset

 @param size UICollectionView.size
 @param lineSpacing the real margin of the user sees
 @param exposedOffset margins exposed on both sides of the cell
 @param maxScale center cell will enlarge max scale
 @return UICollectionView.contentInset
 */
UIEdgeInsets PLGetCollectionViewContentInset(CGSize size, CGFloat lineSpacing, CGFloat exposedOffset, CGFloat maxScale)
{
    CGFloat insetValue = PLGetItemSize(size, lineSpacing, exposedOffset, maxScale).width;
    return UIEdgeInsetsMake(0, (size.width - insetValue) / 2.0, 0, (size.width - insetValue) / 2.0);
}

@interface PLScrollView () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) PLCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) CGRect recordRect;

@property (nonatomic, assign) BOOL delegateDidSelectedItemProtocol;
@property (nonatomic, assign) BOOL delegateDidScrollToIndexProtocol;
@property (nonatomic, assign) BOOL delegateCellForItemProtocol;

@end

@implementation PLScrollView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultProperty];
        [self initCollectionView];
        [self updateSubviewsConstraints];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupDefaultProperty];
    [self initCollectionView];
    [self updateSubviewsConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.recordRect, self.frame)) {
        self.recordRect = self.frame;
        [self reloadData];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.delegate = nil;
}

#pragma mark - Public Method
/**
 initialize PLScrollView
 
 @param dataList data source
 @return instancetype
 */
+ (instancetype)scrollViewWithDataList:(NSArray *)dataList
{
    PLScrollView *scrollView = [[self alloc] init];
    scrollView.dataList = dataList;
    return scrollView;
}

/**
 initialize PLScrollView with frame
 
 @param frame frame
 @param dataList data source
 @return instancetype
 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame dataList:(NSArray *)dataList
{
    PLScrollView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.dataList = dataList;
    return scrollView;
}

/**
 initialize PLScrollView with frame and delegate

 @param frame frame
 @param delegate delegate
 @param dataList data source
 @return instancetype
 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame delegate:(id<PLScrollViewDelegate>)delegate dataList:(NSArray *)dataList
{
    PLScrollView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.dataList = dataList;
    scrollView.delegate = delegate;
    return scrollView;
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:CUSTOM_ID forIndexPath:indexPath];
}

/**
 reloads all of the data for the scrollView.
 */
- (void)reloadData
{
    self.flowLayout.activeDistance = self.activeDistance;
    self.flowLayout.maxScale = self.maxScale;
    self.flowLayout.minimumLineSpacing = PLGetMinimumLineSpacing(self.width, self.itemMargin, self.exposedOffset, self.maxScale);
    self.flowLayout.itemSize = PLGetItemSize(self.size, self.itemMargin, self.exposedOffset, self.maxScale);
    self.collectionView.contentInset = PLGetCollectionViewContentInset(self.size, self.itemMargin, self.exposedOffset, self.maxScale);;
    [self.collectionView reloadData];
}

#pragma mark - Set Default Property
- (void)setupDefaultProperty
{
    self.recordRect = CGRectZero;
    self.itemMargin = 40.0f;
    self.exposedOffset = 20.0f;
    self.maxScale = 1.2f;
    self.activeDistance = 200.0f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.autoScroll = NO;
    self.infiniteScroll = NO;
    self.autoScrollTimeInterval = 2.0f;
}

#pragma mark - Init Subviews
- (void)initCollectionView
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollsToTop = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[PLCollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - update constraints
- (void)updateSubviewsConstraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Getter and Setter
- (PLCollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[PLCollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (void)setDataList:(NSArray *)dataList
{
    _dataList = dataList;
    
    self.dataSources = _dataList;
}

- (void)setDataSources:(NSArray *)dataSources
{
    [self invalidateTimer];

    _dataSources = dataSources;
    
    self.totalCount = self.infiniteScroll ? dataSources.count * 1000 : dataSources.count;
    
    if (dataSources.count > 1)
    {
        self.collectionView.scrollEnabled = YES;
    }else
    {
        self.collectionView.scrollEnabled = NO;
    }
}

- (void)setInfiniteScroll:(BOOL)infiniteScroll
{
    _infiniteScroll = infiniteScroll;
    
    if (self.dataSources.count) {
        self.dataSources = self.dataSources;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    self.flowLayout.scrollDirection = scrollDirection;
}

- (void)setDelegate:(id<PLScrollViewDelegate>)delegate
{
    _delegate = delegate;
    
    if ([delegate respondsToSelector:@selector(customCollectionViewCellClassForScrollView:)] &&
        [delegate customCollectionViewCellClassForScrollView:self])
    {
        [self.collectionView registerClass:[delegate customCollectionViewCellClassForScrollView:self]
                forCellWithReuseIdentifier:CUSTOM_ID];
        self.delegateCellForItemProtocol = delegate && [delegate respondsToSelector:@selector(scrollView:cellForItemAtIndex:)];
    }
    
    self.delegateDidSelectedItemProtocol = delegate && [delegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)];
    self.delegateDidScrollToIndexProtocol = delegate && [delegate respondsToSelector:@selector(scrollView:didScrollToIndex:)];
}

#pragma mark - Actions
- (void)setupTimer
{
    // stop the timer before creating the timer, otherwise the zombie timer will appear, causing the polling frequency to be wrong.
    [self invalidateTimer];

    _timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval
                                              target:self
                                            selector:@selector(automaticScrollAction)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScrollAction
{
    if (self.totalCount == 0)
    {
        return;
    }
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(NSInteger)targetIndex
{
    if (targetIndex >= self.totalCount)
    {
        if (self.infiniteScroll)
        {
            targetIndex = self.totalCount * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionNone
                                                animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

- (NSInteger)currentIndex
{
    if (self.collectionView.width == 0 || self.collectionView.height == 0)
    {
        return 0;
    }
    
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5 + self.collectionView.contentInset.left) / (self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing);
    }else
    {
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height;
    }
    return MAX(0, index);
}

- (NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (NSInteger)index % self.dataSources.count;
}

- (void)clearCache
{
    [[self class] clearImagesCache];
}

+ (void)clearImagesCache
{
    [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    // if defined custom cell, return custom cell
    if (self.delegateCellForItemProtocol)
    {
        return [self.delegate scrollView:self cellForItemAtIndex:itemIndex];
    }
    
    // or return PLCollectionViewCell
    PLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.imageUrl = [self.dataSources objectAtIndex:itemIndex];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegateDidSelectedItemProtocol)
    {
        [self.delegate scrollView:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.dataSources.count)
    {
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll)
    {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll)
    {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.dataSources.count)
    {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger index = [self pageControlIndexWithCurrentCellIndex:itemIndex];

    if (self.delegateDidScrollToIndexProtocol)
    {
        [self.delegate scrollView:self didScrollToIndex:index];
    }
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == self.totalCount) return;
    
    [self scrollToIndex:(int)(self.totalCount * 0.5 + index)];
    
    if (self.autoScroll) {
        [self setupTimer];
    }
}

@end
