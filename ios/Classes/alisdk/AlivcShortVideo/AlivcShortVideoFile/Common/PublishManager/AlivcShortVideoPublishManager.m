//
//  AlivcShortVideoPublishManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/6.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoPublishManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "AlivcShortVideoUploadManager.h"
#import "AliyunMediaConfig.h"


@interface AlivcShortVideoPublishManager () <
AliyunIExporterCallback, AlivcShortVideoUploadManagerDelegate>

//合成相关属性记录
@property(strong, nonatomic) NSString *taskPath;
//视频配置信息
@property(strong, nonatomic) AliyunMediaConfig *mediaConfig;
//合成完成之后是否保存至相册
@property(assign, nonatomic) BOOL saveToAlbum;

//封面图
@property(nonatomic, copy) UIImage *coverImage;
//发布状态记录
@property(nonatomic, assign) AlivcPublishStatus newStatus;
//上传sts相关属性l记录
//@property(strong, nonatomic) NSString *key;
//@property(strong, nonatomic) NSString *secret;
//@property(strong, nonatomic) NSString *token;

/**
 先合成-再上传，YES：当前出于上传步骤 NO：当前出于合成步骤
 */
@property(assign, nonatomic) BOOL isProcessToUpload;

@end

static AlivcShortVideoPublishManager *_instance = nil;
static CGFloat exportRatio = 0.7; //合成暂用的时间比例

@implementation AlivcShortVideoPublishManager
#pragma mark - 单例

+ (instancetype)shared {
    if (_instance == nil) {
        
        _instance = [[AlivcShortVideoPublishManager alloc] init];
    }
    
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    if (_instance == nil) {
        
        _instance = [super allocWithZone:zone];
    }
    
    return _instance;
}

- (id)copy {
    
    return self;
}

- (id)mutableCopy {
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    return self;
}

#pragma mark - Publish Method
- (void)setVideoPath:(NSString *)taskPath videoConfig:(AliyunMediaConfig *)mediaConfig {
    _taskPath = taskPath;
    _mediaConfig = mediaConfig;
}

- (void)setCoverImag:(UIImage *)image
           videoInfo:(AliyunUploadSVideoInfo *)videoInfo {
    _coverImage = image;
    _videoInfo = videoInfo;
}

//- (void)setUploadInfoWithKey:(NSString *)keyId secres:(NSString *)keySecret token:(NSString *)token{
//    _key = keyId;
//    _secret = keySecret;
//    _token = token;
//}

- (BOOL)startPublishWithSaveToAlbum:(BOOL)saveToAlbum {
    _isProcessToUpload = NO;
    if (_taskPath && _mediaConfig.outputPath) {
        _saveToAlbum = saveToAlbum;
        [AliyunPublishService service].exportCallback = self;
        BOOL isSuccess = [[AliyunPublishService service]exportWithTaskPath:_taskPath outputPath:_mediaConfig.outputPath];
        return isSuccess;
    }else{
        return NO;
    }
}

- (void)cancelPublish {
    [[AliyunPublishService service] cancelExport];
    [[AliyunPublishService service] cancelUpload];
    //由外界调用的话把状态至为fail，不至为cancel，cancel是退后台，SDK自动cancel了才是cancel状态
    _newStatus = AlivcPublishStatusFailure;
    [self endPublishFlow];
}

- (void)endPublishFlow{
    [self p_clearData];
}

- (void)p_clearData{
    _taskPath = nil;
    _mediaConfig = nil;
//    _key = nil;
//    _secret = nil;
//    _token = nil;
    _coverImage = nil;
    _newStatus = AlivcPublishStatusNoTStart;
}

- (BOOL)restartPublishFromPreCurrentStatus{
    if (_isProcessToUpload) {
        return [self startUpload];
    }else{
        // - 短视频3.8.0版本及之后后台SDK会自动合成，所以这里注释掉
//        return [self startPublishWithSaveToAlbum:_saveToAlbum];
       
    }
    return YES;
}

- (UIImage *)coverImage {
    return _coverImage;
}

- (AlivcPublishStatus)currentStatus {
    return _newStatus;
}



#pragma mark - AliyunIExporterCallback
- (void)exportProgress:(float)progress {
    CGFloat allProgress = progress * exportRatio;
    if (_managerDelegate && [_managerDelegate respondsToSelector:@selector
                             (publishManager:updateProgress:)]) {
        [_managerDelegate publishManager:self updateProgress:allProgress];
    }
}

- (void)exporterDidCancel {
    _newStatus = AlivcPublishStatusCancel;
    if (_managerDelegate &&
        [_managerDelegate respondsToSelector:@selector(publishManager:
                                                       uploadStatusChangedTo:)]) {
        [_managerDelegate publishManager:self
                   uploadStatusChangedTo:AlivcPublishStatusCancel];
    }
}

- (void)exporterDidStart {
    _newStatus = AlivcPublishStatusPublishing;
    if (_managerDelegate &&
        [_managerDelegate respondsToSelector:@selector(publishManager:
                                                       uploadStatusChangedTo:)]) {
        [_managerDelegate publishManager:self
                   uploadStatusChangedTo:AlivcPublishStatusPublishing];
    }
}

- (void)exportError:(int)errorCode {
    _newStatus = AlivcPublishStatusFailure;
    if (_managerDelegate &&
        [_managerDelegate respondsToSelector:@selector(publishManager:
                                                       uploadStatusChangedTo:)]) {
        [_managerDelegate publishManager:self
                   uploadStatusChangedTo:AlivcPublishStatusFailure];
    }
}

- (void)exporterDidEnd:(NSString *)outputPath {
    if (_saveToAlbum) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL
                                                     fileURLWithPath:_mediaConfig
                                                     .outputPath]
                                    completionBlock:^(NSURL *assetURL, NSError *error) {
                                        NSLog(@"视频已保存到相册");
                                    }];
    }
    [self startUpload];
    
}

- (BOOL)startUpload{
    BOOL startUploadSuccess = NO;
    _isProcessToUpload = YES;
    //进度到exportRatio，然后开始上传
    if (_managerDelegate && [_managerDelegate respondsToSelector:@selector
                             (publishManager:updateProgress:)]) {
        [_managerDelegate publishManager:self updateProgress:exportRatio];
    }
    
    UIImage *coverImage = nil;
    if (_coverImage) {
        coverImage = _coverImage;
    } else {
        //取第一帧 - 外界确认一定有值，这里没法取第一帧
    }
    
    AliyunUploadSVideoInfo *vInfo = nil;
    if (_videoInfo) {
        vInfo = _videoInfo;
        if ([vInfo.title isEqualToString:@""] || !vInfo.title) {
            vInfo.title = @"Default Title";
        }
    } else {
        //生成必要的默认值
        vInfo = [[AliyunUploadSVideoInfo alloc]init];
        vInfo.title = @"Default Title";
    }
    
    NSString *coverPath = [_taskPath stringByAppendingPathComponent:@"cover.png"];
    if (!coverImage) {
        return NO;
    }
    NSData *data = UIImagePNGRepresentation(coverImage);
    [data writeToFile:coverPath atomically:YES];
    [[AlivcShortVideoUploadManager shared] setManagerDelegate:self];
    [[AlivcShortVideoUploadManager shared] setCoverImagePath:coverPath
                                                   videoInfo:vInfo videoPath:self.mediaConfig.outputPath];
    [[AlivcShortVideoUploadManager shared]startUpload];
    return YES;
}

#pragma mark - AlivcShortVideoUploadManagerDelegate

- (void)uploadManager:(AlivcShortVideoUploadManager *)manager
       updateProgress:(CGFloat)progress {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat allProgress = progress * (1 - exportRatio) + exportRatio;
        if (_managerDelegate &&
            [_managerDelegate respondsToSelector:@selector(publishManager:
                                                           updateProgress:)]) {
            [_managerDelegate publishManager:self updateProgress:allProgress];
        }
    });
}

- (void)uploadManager:(AlivcShortVideoUploadManager *)manager
uploadStatusChangedTo:(AlivcUploadStatus)newStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (newStatus) {
            case AlivcUploadStatusCancel:
                _newStatus = AlivcPublishStatusCancel;
                break;
            case AlivcUploadStatusFailure:
                _newStatus = AlivcPublishStatusFailure;
                break;
            case AlivcUploadStatusSuccess:
                _newStatus = AlivcPublishStatusSuccess;
                break;
            case AlivcUploadStatusUploading:
                _newStatus = AlivcPublishStatusPublishing;
                break;
                
            default:
                break;
        }
        
        if (_managerDelegate &&
            [_managerDelegate respondsToSelector:@selector(publishManager:
                                                           uploadStatusChangedTo:)]) {
            [_managerDelegate publishManager:self uploadStatusChangedTo:_newStatus];
        }
    });
}

- (void)uploadManager:(AlivcShortVideoUploadManager *)manager succesWithVid:(NSString *)vid coverImageUrl:(NSString *)imageUrl{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_managerDelegate && [_managerDelegate respondsToSelector:@selector(publishManager:succesWithVid:coverImageUrl:)]) {
            [_managerDelegate publishManager:self succesWithVid:vid coverImageUrl:imageUrl];
        }
        
        
    });
}


@end
