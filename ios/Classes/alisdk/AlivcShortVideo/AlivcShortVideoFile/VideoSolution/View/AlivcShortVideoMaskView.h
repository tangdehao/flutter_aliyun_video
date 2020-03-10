//
//  AlivcShortVideoMaskView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/12/5.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  播放器业务上的各种UI控件，这里封装了一层

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AlivcShortVideoMaskView;

@protocol AlivcShortVideoMaskViewDelegate <NSObject>

/**
 左下的视频按钮点击回调

 @param maskView 对应的UI容器视图
 @param button 视频按钮
 */
//- (void)shortVideoMaskView:(AlivcShortVideoMaskView *)maskView videoButtonTouched:(UIButton *)button;

/**
 中间的视频按钮点击回调
 
 @param maskView 对应的UI容器视图
 @param button 中间的home按钮
 */
//- (void)shortVideoMaskView:(AlivcShortVideoMaskView *)maskView homeButtonTouched:(UIButton *)button;

/**
 用户按钮点击回调

 @param maskView 对应的UI容器视图
 @param button 用户按钮
 */
//- (void)shortVideoMaskView:(AlivcShortVideoMaskView *)maskView userButtonTouched:(UIButton *)button;

/**
 更多按钮点击回调

 @param maskView 对应的UI容器视图
 @param button 更多按钮
 */
- (void)shortVideoMaskView:(AlivcShortVideoMaskView *)maskView moreButtonTouched:(UIButton *)button;




@end

@interface AlivcShortVideoMaskView : UIView

/**
 代理
 */
@property (nonatomic,weak) id <AlivcShortVideoMaskViewDelegate> delegate;

/**
 手势视图
 */
@property (nonatomic, strong) UIView *gestureView;

/**
 改变UI至暂停状态
 */
- (void)changeUIToPauseStatusWithCurrentPlayView:(UIView *)playView;

/**
 改变UI至播放状态
 */
- (void)changeUIToPlayStatus;

/**
 更新视频加载的进度条

 @param progress 0-1
 */
- (void)updatePlayLoadProgeress:(CGFloat)progress;

/**
 隐藏进度条
 */
- (void)hidePlayLoadProgeress;



@end

NS_ASSUME_NONNULL_END
