//
//  AlivcShortVideoPublishManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/6.
//  Copyright © 2019年 Alibaba. All rights reserved.
//  发布管理器：先内部合成，再上传

#import <Foundation/Foundation.h>
#import "AliyunPublishService.h"

@class AlivcShortVideoPublishManager;
@class AliyunMediaConfig;
@class AliyunUploadSVideoInfo;

typedef NS_ENUM(NSInteger,AlivcPublishStatus){
    AlivcPublishStatusNoTStart = 0,
    AlivcPublishStatusSuccess = 1,
    AlivcPublishStatusPublishing,
    AlivcPublishStatusFailure,
    AlivcPublishStatusCancel,
};

NS_ASSUME_NONNULL_BEGIN

@protocol AlivcShortVideoPublishManagerDelegate <NSObject>

@required
/**
 发布状态回调
 
 @param manager manager
 @param newStatus 新的状态
 */
- (void)publishManager:(AlivcShortVideoPublishManager *)manager uploadStatusChangedTo:(AlivcPublishStatus )newStatus;

/**
 发布进度回调
 
 @param manager manager
 @param progress 0-1
 */
- (void)publishManager:(AlivcShortVideoPublishManager *)manager updateProgress:(CGFloat )progress;

@optional

- (void)publishManager:(AlivcShortVideoPublishManager *)manager succesWithVid:(NSString *)vid coverImageUrl:(NSString *)imageUrl;

@end

@interface AlivcShortVideoPublishManager : NSObject

/**
 单例 - 主要为了使用方便和模块间的低耦合
 
 @return 实例
 */
+ (instancetype)shared;

/**edd
 本次合成与上传发生事情的回调代理
 */
@property (nonatomic, weak) id<AlivcShortVideoPublishManagerDelegate> managerDelegate;


/**
 要发布的视频信息
 */
@property (nonatomic, copy, readonly) AliyunUploadSVideoInfo *videoInfo;

@property (nonatomic, copy)NSString *mixVideoPath;


/**
 设置合成信息
 
 @param taskPath 视频的地址
 @param mediaConfig 配置信息
 */
- (void)setVideoPath:(NSString *)taskPath videoConfig:(AliyunMediaConfig *)mediaConfig;


/**
 设置上传信息
 
 @param image 封面
 @param videoInfo 视频信息
 */
- (void)setCoverImag:(UIImage *)image videoInfo:(AliyunUploadSVideoInfo *)videoInfo;

/**
 设置上传凭证信息 - sts方式

 @param keyId key
 @param keySecret secret
 @param token token
 */
//- (void)setUploadInfoWithKey:(NSString *)keyId secres:(NSString *)keySecret token:(NSString *)token;

/**
 开始发布
 @param saveToAlbum 完成的时候是否保存至相册
 @return 成功或者失败
 */
- (BOOL)startPublishWithSaveToAlbum:(BOOL)saveToAlbum;

/**
 取消发布
 */
- (void)cancelPublish;

/**
 重新发布 - 用于发布过程中退后台再进来等操作
 */
- (BOOL)restartPublishFromPreCurrentStatus;

/**
 结束整个发布流程， 用于发布成功或者异常，由外部调用。与startPublish对应，取消发布内部自己会调用这个方法
 */
- (void)endPublishFlow;

- (UIImage *)coverImage;

- (AlivcPublishStatus )currentStatus;


@end

NS_ASSUME_NONNULL_END
