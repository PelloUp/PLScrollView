//
//  PLCustomCollectionViewCell.m
//  PLScrollView
//
//  Created by Pello on 2018/7/4.
//  Copyright © 2018年 pello. All rights reserved.
//

#import "PLCustomCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface PLCustomCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation PLCustomCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initImageView];
        [self updateSubviewsConstraints];
    }
    return self;
}

- (void)initImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
}

- (void)updateSubviewsConstraints
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}
@end