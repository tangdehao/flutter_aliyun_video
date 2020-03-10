//
//  AlivcShortVideoMaskView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/12/5.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoMaskView.h"
#import "AlivcUIConfig.h"
#import "UIColor+AlivcHelper.h"



@interface AlivcShortVideoMaskView ()

#pragma mark - UI

/**
 更多按钮
 */
@property (nonatomic, strong) UIButton *moreButton;


/**
 选择效果
 */
@property (nonatomic, strong) UIView *lineView;


/**
 播放图标的容器视图
 */
@property (nonatomic, strong) UIView *playImageContainView;

/**
 播放加载的进度条的视图
 */
@property (nonatomic, strong) UIProgressView *playLoadingProgress;


@end

@implementation AlivcShortVideoMaskView

#pragma mark - Getter


- (UIView *)gestureView{
    if (!_gestureView) {
        _gestureView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _gestureView.backgroundColor = [UIColor clearColor];
    }
    return _gestureView;
}



- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[AlivcImage imageNamed:@"shortVideo_solution_share"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}



- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 2)];
        _lineView.backgroundColor = [AlivcUIConfig shared].kAVCThemeColor;
    }
    return _lineView;
}

- (UIView *)playImageContainView{
    if (!_playImageContainView) {
        CGFloat width = 70;
        _playImageContainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        _playImageContainView.layer.cornerRadius = width / 2;
        _playImageContainView.clipsToBounds = YES;
        _playImageContainView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _playImageContainView;;
}

- (UIProgressView *)playLoadingProgress{
    if (!_playLoadingProgress) {
        _playLoadingProgress = [[UIProgressView alloc]init];
        [_playLoadingProgress setProgressTintColor:[UIColor colorWithHexString:@"#1AD4FF"]];
        [_playLoadingProgress setTrackTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
    }
    return _playLoadingProgress;
}

#pragma mark - init
- (instancetype)init{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self configBaseUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configBaseUI];
    }
    return self;
}

- (void)configBaseUI{
    
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [self addSubview:self.gestureView];

    
    CGFloat beside = 16;
    
    [self.moreButton sizeToFit];
    self.moreButton.center = CGPointMake(ScreenWidth - beside - self.moreButton.frame.size.width / 2, ScreenHeight - 120-SafeAreaBottom);
    [self addSubview:self.moreButton];
    
    [self addSubview:self.playLoadingProgress];
    self.playLoadingProgress.frame = CGRectMake(0, ScreenHeight - 70, ScreenWidth, 1);
    self.playLoadingProgress.hidden = YES;
}


#pragma mark - ButtonAction

/**
 视频按钮点击
 */
- (void)videoButtonTouched:(UIButton *)button{
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(button.center.x, CGRectGetMaxY(button.frame) + 3);
    }];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoMaskView:videoButtonTouched:)]) {
//        [self.delegate shortVideoMaskView:self videoButtonTouched:button];
//    }
}



/**
 我按钮点击
 */
- (void)meButtonTouched:(UIButton *)button{
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(button.center.x, CGRectGetMaxY(button.frame) + 3);
    }];
}

/**
 更多按钮点击
 */
- (void)moreButtonTouched:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoMaskView:moreButtonTouched:)]) {
        [self.delegate shortVideoMaskView:self moreButtonTouched:button];
    }
}





#pragma mark - Public Method
- (void)changeUIToPauseStatusWithCurrentPlayView:(UIView *)playView{
    [self.playImageContainView removeFromSuperview];
    [self.playImageContainView sizeToFit];
    [playView addSubview:self.playImageContainView];
    self.playImageContainView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    UIImageView *playImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"temp_qu_play"]];
    playImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.playImageContainView addSubview:playImageView];
    playImageView.center = CGPointMake(self.playImageContainView.frame.size.width / 2, self.playImageContainView.frame.size.height / 2);
    self.playImageContainView.hidden = NO;
}

- (void)changeUIToPlayStatus{
    self.playImageContainView.hidden = YES;
}

/**
 更新视频加载的进度条
 
 @param progress 0-1
 */
- (void)updatePlayLoadProgeress:(CGFloat)progress{
    self.playLoadingProgress.hidden = NO;
    [self.playLoadingProgress setProgress:progress];
}

/**
 隐藏进度条
 */
- (void)hidePlayLoadProgeress{
    self.playLoadingProgress.hidden = YES;
}

@end
