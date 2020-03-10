//
//  AlivcShortVideoUploadProgressView.m
//  AliyunVideoClient_Entrance
//
//  Created by 张璠 on 2018/11/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoUploadProgressView.h"
@interface AlivcShortVideoUploadProgressView ()

/**
 背景图片
 */
@property(nonatomic, strong) UIImage *backgroundImage;

/**
 背景图片的view
 */
@property(nonatomic, strong) UIImageView *backImageView;

/**
 背景黑色view
 */
@property(nonatomic, strong) UIView *progressView;

/**
  显示字体
 */
@property(nonatomic, strong) UILabel *textLabel;
@end

@implementation AlivcShortVideoUploadProgressView

- (instancetype)initWithBackgroundImage:(UIImage *)image {
  self = [super initWithFrame:CGRectMake(0, 0, 100, 150)];
  if (self) {
    self.backgroundImage = image;
    //计算大小 - 宽度是整个屏幕的0.2 高度根据图片比例计算
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.2;
    CGFloat height = image.size.height / image.size.width * width;
    self.frame = CGRectMake(0, 0, width, height);

    //背景图片
    self.backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.backImageView];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backImageView.image = image;

    //背景进度条
    self.progressView = [[UIView alloc] initWithFrame:self.bounds];
    self.progressView.backgroundColor = [UIColor colorWithRed:0
                                                        green:0
                                                         blue:0
                                                        alpha:0.5];
    [self addSubview:self.progressView];

    //标题
    UILabel *textLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(0, self.bounds.size.height - 30,
                                 self.bounds.size.width, 30)];
    textLabel.text = NSLocalizedString(@"准备中", nil);
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    [self setShowText:NSLocalizedString(@"准备中", nil)];

    self.clipsToBounds = YES;
  }
  return self;
}

/**
 刷新进度条进度

 @param progress 进度条进度
 */
- (void)setProgress:(CGFloat)progress {
  _progress = progress;
  //计算中心点y 0-0.5   1.5h
  CGFloat cy = (progress + 0.5) * self.frame.size.height;
  [UIView animateWithDuration:0.1
                   animations:^{
                     self.progressView.center =
                         CGPointMake(self.frame.size.width / 2, cy);
                   }
                   completion:^(BOOL finished){
                       //

                   }];
}

- (void)setShowText:(NSString *)text {
  self.textLabel.text = text;
  [self.textLabel sizeToFit];
  self.textLabel.center =
      CGPointMake(self.frame.size.width / 2, self.frame.size.height - 30);
}

@end
