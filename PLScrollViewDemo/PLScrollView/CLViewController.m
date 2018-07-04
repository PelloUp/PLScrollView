//
//  CLViewController.m
//  PLScrollView
//
//  Created by Pello on 2018/7/3.
//  Copyright © 2018年 pello. All rights reserved.
//

#import "CLViewController.h"
#import "PLScrollView.h"
#import <Masonry/Masonry.h>
#import "PLCollectionViewCell.h"
#import "PLCustomCollectionViewCell.h"

@interface CLViewController () <PLScrollViewDelegate>

@end

@implementation CLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    PLScrollView *scrollView = [PLScrollView scrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300)
                                                        dataList:[self dataList]];
    scrollView.delegate = self;
//    scrollView.infiniteScroll = YES;
//    scrollView.autoScroll = YES;
    [self.view addSubview:scrollView];
    [scrollView reloadData];
}

- (NSArray *)dataList
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return [dataDict objectForKey:@"dataList"];
}

- (void)scrollView:(PLScrollView *)scrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"%s:%ld", __func__, index);
}

- (void)scrollView:(PLScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%s:%ld", __func__, index);
}

- (Class)customCollectionViewCellClassForScrollView:(PLScrollView *)scrollView
{
    return [PLCustomCollectionViewCell class];
}

- (UICollectionViewCell *)scrollView:(PLScrollView *)scrollView cellForItemAtIndex:(NSInteger)index
{
    PLCustomCollectionViewCell *cell = [scrollView dequeueReusableCellWithIndex:index];
    cell.imageUrl = [[self dataList] objectAtIndex:index];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
