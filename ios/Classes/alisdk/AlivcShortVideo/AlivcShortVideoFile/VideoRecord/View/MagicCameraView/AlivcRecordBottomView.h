//
//  AlivcRecordBottomView.h
//  AliyunVideoClient_Entrance
//
//  Created by wanghao on 2019/2/25.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcRecordToolView.h"
#import "AlivcRecordRateSelectView.h"
#import "AlivcRecordButtonView.h"

@class AlivcRecordUIConfig;

NS_ASSUME_NONNULL_BEGIN

@protocol AlivcRecordBottomViewDelegate <NSObject>
@optional
/**
 录制速度改变

 @param rate 速度
 */
- (void)alivcRecordBottomViewDidSelectRate:(CGFloat)rate;

/**
 删除录制片段
 
 */
- (void)alivcRecordBottomViewDeleteVideoPart;

/**
 停止录制
 */
- (void)alivcRecordBottomViewStopRecord;

/**
 开始录制

 @return 是否成功
 */
- (BOOL)alivcRecordBottomViewStartRecord;

/**
 是否在录制中

 @return YES:录制中   NO:未录制
 */
- (BOOL)alivcRecordBottomViewIsRecording;

/**
 美颜按钮点击事件
 */
- (void)alivcRecordBottomViewBeautyButtonOnclick;

/**
 特效按钮点击事件
 */
- (void)alivcRecordBottomViewEffectButtonOnclick;

/**
 切换视频/照片
 */
- (void)alivcRecordBottomViewChangeTouchMode:(AlivcRecordButtonTouchMode *)mode;

@end

@interface AlivcRecordBottomView : UIView

@property(nonatomic, weak)id<AlivcRecordBottomViewDelegate>delegate;

@property(nonatomic, strong)AlivcRecordToolView *toolView;

@property(nonatomic, strong)AlivcRecordRateSelectView *rateSelectView;

//初始化拍摄模式-baan
@property(nonatomic, assign)AlivcRecordButtonTouchMode touchMode;

@property(nonatomic, strong)AlivcRecordButtonView *recordButttonView;
/**
 初始化实例

 @param frame frame
 @param uiConfig uiConfig
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame withUIConfig:(nonnull AlivcRecordUIConfig *)uiConfig withTouchMode: (AlivcRecordButtonTouchMode )mode;
/**
 更新视频片段

 @param partCount 视频片段
 */
- (void)updateViewsWithVideoPartCount:(NSInteger)partCount;

/**
 刷新录制时长

 @param duration 录制时长
 */
- (void)refreshRecorderVideoDuration:(CGFloat)duration;

/**
 更新录制UI
 */
- (void)updateRecorderUI;

/**
 开始录制
 */
- (void)startRecord;

@end

NS_ASSUME_NONNULL_END
