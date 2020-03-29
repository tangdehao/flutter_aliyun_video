//
//  AlivcPublishViewControlViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/12/26.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  趣视频模块二合一的上传方式

#import "AlivcKeyboardManageViewController.h"

typedef void (^AlivcRecordFinishEmptyBlock)();

@class AliyunMediaConfig;

NS_ASSUME_NONNULL_BEGIN

@interface AlivcPublishQuViewControl : AlivcBaseViewController

@property (strong, nonatomic) UIImage *coverImage;

/**
 短视频路径
 */
@property (nonatomic, strong) NSString *taskPath;

/**
 合成信息配置
 */
@property (nonatomic, strong) AliyunMediaConfig *config;

@property (nonatomic, strong) NSString *videoPath;



@property (nonatomic, assign) BOOL isCamera;
@property (nonatomic, strong) NSString *cameraVideoPath;
@property (nonatomic, strong) UIImage *cameraImage;
@property (nonatomic, copy, nullable) AlivcRecordFinishEmptyBlock finishPublishBlock;

@end

NS_ASSUME_NONNULL_END
