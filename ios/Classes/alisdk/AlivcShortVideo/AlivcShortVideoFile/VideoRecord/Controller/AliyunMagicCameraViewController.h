//
//  AliyunMagicCameraViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by wanghao on 2019/2/20.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcShortVideoRoute.h"
#import "AlivcRecordToolView.h"


typedef void (^AlivcRecordFinishDictBlock)(NSDictionary *outputPath);

@class AliyunClipManager;
@class AliyunIRecorder;
 
NS_ASSUME_NONNULL_BEGIN
 

@interface AliyunMagicCameraViewController : UIViewController

/**
 视频参数配置
 */
@property (nonatomic, strong, nullable) AliyunMediaConfig *quVideo;

/**
 视频拍摄界面UI配置，可不传
 */
@property (nonatomic, strong, nullable) AlivcRecordUIConfig *uiConfig;

/**
 拍摄完成的回调
 */
@property (nonatomic, copy, nullable) AlivcRecordFinishDictBlock finishBlock;

@property (nonatomic, assign)BOOL isMixedViedo;//是否是合拍的视频

//初始化拍摄模式-baan
@property(nonatomic, assign)AlivcRecordButtonTouchMode touchMode;

//禁用音乐按钮
- (void)hiddenMusicButton;
//完成按钮enable的条件 是否是录制时间大于等于最短时间
- (CGFloat)finishButtonEnabledMinDuration;


@end

NS_ASSUME_NONNULL_END
