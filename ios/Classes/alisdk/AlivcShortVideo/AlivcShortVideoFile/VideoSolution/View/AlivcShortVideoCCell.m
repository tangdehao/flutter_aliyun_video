//
//  AlivcShortVideoCCell.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/9.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoCCell.h"
#import "AlivcQuVideoModel.h"
#import "UIColor+AlivcHelper.h"
#import "NSString+AlivcHelper.h"
#import "UIImageView+WebCache.h"

@implementation AlivcShortVideoCCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        self.contentView.backgroundColor = [UIColor blackColor];
        
        _statusContainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width / 3, 20)];
        _statusContainView.center = CGPointMake(frame.size.width - _statusContainView.frame.size.width / 2, _statusContainView.frame.size.height / 3);
        [self.contentView addSubview:_statusContainView];
        
        _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, _statusContainView.frame.size.width - 4, _statusContainView.frame.size.height)];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.adjustsFontSizeToFitWidth = YES;
        [_statusContainView addSubview:_statusLabel];
        
        self.contentView.layer.cornerRadius = 4;
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)configUIWithModel:(AlivcQuVideoModel *)viewModel{
    if (viewModel.coverImage) {
        self.imageView.image = viewModel.coverImage;
    }else if(viewModel.coverUrl){
        NSURL *url = [NSURL URLWithString:viewModel.coverUrl];
        [self.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            viewModel.coverImage = image;
        }];
    }
    
    switch (viewModel.ensorStatus) {
        case AlivcQuVideoAbstractionStatus_On:
            self.statusContainView.hidden = NO;
            self.statusContainView.backgroundColor = [UIColor colorWithHexString:@"FC7729"];
            self.statusLabel.text = [@"审核中" localString];
            break;
        case AlivcQuVideoAbstractionStatus_Fail:
            self.statusContainView.hidden = NO;
            self.statusContainView.backgroundColor = [UIColor colorWithHexString:@"FC4347"];
            self.statusLabel.text = [@"未通过" localString];
            break;
        case AlivcQuVideoAbstractionStatus_Success:
            self.statusContainView.hidden = NO;
            self.statusContainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            self.statusLabel.text = [@"已通过" localString];
            break;
            
        default:
            break;
    }
}



@end
