//
//  AlivcShortVideoCCell.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/9.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlivcQuVideoModel;

NS_ASSUME_NONNULL_BEGIN

@interface AlivcShortVideoCCell : UICollectionViewCell

/**
 照片视图
 */
@property (strong, nonatomic) UIImageView *imageView;

/**
 状态label
 */
@property (strong, nonatomic) UILabel *statusLabel;

/**
 状态label的容器视图
 */
@property (strong, nonatomic) UIView *statusContainView;

- (void)configUIWithModel:(AlivcQuVideoModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
