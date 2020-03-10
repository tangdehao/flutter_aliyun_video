//
//  AlivcShortVideoPlayerPresent.m
//  AliyunVideoClient_Entrance
//
//  Created by 孙震 on 2019/4/9.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import "AlivcShortVideoPlayerManager.h"
#import "UIColor+AlivcHelper.h"
#import "AlivcQuVideoModel.h"
#import "AlivcShortVideoLiveVideoModel.h"
#import "AlivcShortVideoBasicVideoModel.h"
#import "AlivcQuVideoServerManager.h"
#import "MBProgressHUD+AlivcHelper.h"
#import "AliVideoClientUser.h"
#import <AliyunPlayer/AliyunPlayer.h>


@interface AlivcShortVideoPlayerManager()<AVPDelegate>

//播放器
@property (nonatomic, strong) AliListPlayer *listPlayer;//播放器状态
@property (nonatomic, assign) AVPStatus playerStatus;

@property (nonatomic, weak) UIViewController *vc;

/**
 视频列表
 */
@property (nonatomic, strong) NSMutableArray *videos;

/**
 播放器的视图view
 */
@property (nonatomic, strong) UIView *playImageView;

/**
 进度条
 */
@property (nonatomic, strong) UIProgressView *playLoadingProgress;

/**
 STS相关
 */
@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessKeySecret;
@property (nonatomic, copy) NSString *securityToken;
@property (nonatomic, copy) NSString *region;


@end
@implementation AlivcShortVideoPlayerManager

- (instancetype)initWithVC:(UIViewController *)vc {
    if(self = [super init]) {
        self.vc = vc;
        [self initData];
        [self initUI];
    }
    return self;
}
- (void)initData {
    self.canPlay = YES;
    self.currentIndex = -1;
    self.videos = @[].mutableCopy;
}
- (void)initUI {
    self.listPlayer.delegate = self;
    self.listPlayer.stsPreloadDefinition = @"FD";
    
    CGFloat playViewX = 0;
    CGFloat playViewY = 0;
    CGFloat playViewW = ScreenWidth;
    CGFloat playViewH = ScreenHeight - KquTabBarHeight;
    if ([NSStringFromClass([self.vc class]) isEqualToString:@"AlivcShortVideoLivePlayViewController"]) {
        playViewH = ScreenHeight;
    }
    
    
    CGRect frame = CGRectMake(playViewX, playViewY, playViewW, playViewH);
    self.playView = [[UIView alloc]initWithFrame:frame];
    self.playView.hidden = YES;
    
    //1.播放按钮
    self.listPlayer.playerView = self.playView;
    [self.playView addSubview:self.playImageView];
    self.playImageView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    
    //2.进度条
    [self.playView addSubview:self.playLoadingProgress];
    self.playLoadingProgress.frame = CGRectMake(0, frame.size.height - 70, frame.size.width, 1);
    self.playLoadingProgress.hidden = YES;
}
#pragma   mark - public method

// 停止
- (void)stop {
    self.playView.hidden = YES;
    [self.listPlayer stop];
    self.playerStatus = AVPStatusStopped;
}
// 暂停
- (void)pause {
    self.listPlayer.autoPlay = NO;
    [self.listPlayer pause];
    self.playerStatus = AVPStatusPaused;
}
// 恢复
- (void)resume {
    if (self.canPlay) {
        self.listPlayer.autoPlay = YES;
        [self.listPlayer start];
        self.playerStatus = AVPStatusStarted;
    }else {
        self.listPlayer.autoPlay = NO;
        [self.listPlayer pause];
        self.playerStatus = AVPStatusPaused;
    }
}
- (void)clear {
    [self.listPlayer clear];
    [self.videos removeAllObjects];
    self.currentIndex = -1;
}
//移除播放视频
- (void)removeVideoAtIndex:(NSInteger)index {
    [self.videos removeObjectAtIndex:index];
    self.currentIndex = -1;
}
- (void)updateAccessId:(NSString *)accessId accessKeySecret:(NSString *)accessKeySecret
         securityToken:(NSString *)securityToken region:(NSString *)region{
    self.accessKeyId = accessId;
    self.accessKeySecret =accessKeySecret;
    self.securityToken = securityToken;
    self.region= region;
}

- (void)addPlayList:(NSArray *)videos{
    [self.videos addObjectsFromArray:videos];

    for (AlivcShortVideoBasicVideoModel *video  in videos) {
        if ([video isKindOfClass:[AlivcShortVideoLiveVideoModel class]]) {
          // AlivcShortVideoLiveVideoModel * livevideo = (AlivcShortVideoLiveVideoModel *)video;
            // [self.listPlayer addUrlSource:@"http://pull-videocall.aliyuncs.com/timeline/cctv-anniversary.m3u8" uid:livevideo.ID];
            // [self.listPlayer addUrlSource:livevideo.liveUrl uid:livevideo.ID];
          // [self.listPlayer addUrlSource:@"https://alivc-demo-vod.aliyuncs.com/bc6702477b6242ba870a8fcf709f73dd/fb95d607901b5fb982a2b502fe3ae1cb-fd.mp4" uid:livevideo.ID];
            
        }else if([video isKindOfClass:[AlivcQuVideoModel class]]) {
           [self.listPlayer addVidSource:video.videoId uid:video.ID];
        }
    }
    
    
}

- (void)playAtIndex:(NSInteger)index {
    if (index <= self.videos.count - 1) {
//        self.playView.hidden = NO;
        AlivcShortVideoBasicVideoModel *video = self.videos[index];
        if ([video isKindOfClass:[AlivcQuVideoModel class]]) {
            self.currentIndex = index;
            [self.listPlayer moveTo:video.ID accId:self.accessKeyId
                             accKey:self.accessKeySecret
                              token:self.securityToken
                             region:self.region];
            [self resume];
        }else if ([video isKindOfClass:[AlivcShortVideoLiveVideoModel class]]){
            self.currentIndex = index;
            AlivcShortVideoLiveVideoModel *liveModel = (AlivcShortVideoLiveVideoModel *)video;
            AVPUrlSource *urlSource = [[AVPUrlSource alloc]init];
            urlSource.playerUrl = [NSURL URLWithString:liveModel.liveUrl];// 
            [self.listPlayer setUrlSource:urlSource];
            [self.listPlayer prepare];
            [self.listPlayer start];
           // [self.listPlayer moveTo:video.ID];
           // [self resume];
        }
       
    }
    
}

- (void)removePlayView {
    [self.playView removeFromSuperview];
    self.playView.hidden = YES;
    [self.listPlayer stop];
    self.currentIndex = -1;
}

#pragma mark - AVPDelegate

- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel {
    if (errorModel.code == ERROR_SERVER_VOD_UNKNOWN) {
        [self fetchSTSComplete:^(BOOL result) {
            if (result) {
                [self playAtIndex:self.currentIndex];
            }
        }];
    }
}

-(void)onPlayerEvent:(AliPlayer*)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventPrepareDone: {
            [self setPlayerscalingMode];
        }
            break;
        case AVPEventLoadingStart: {
            self.playLoadingProgress.hidden = NO;
        }
            break;
        case AVPEventLoadingEnd: {
            
            self.playLoadingProgress.hidden = YES;
        }
            break;
        case AVPEventFirstRenderedStart: {
            //设置播放器的填充模式
           
            self.playView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)onPlayerStatusChanged:(AliPlayer*)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    self.playerStatus = newStatus;
    switch (newStatus) {
        case AVPStatusStarted: {
            self.playImageView.hidden = YES;
        }
            break;
        case AVPStatusPaused: {
            self.playImageView.hidden = NO;
        }
            break;
        default:
             self.playImageView.hidden = NO;
            break;
    }
}
- (void)onLoadingProgress:(AliPlayer*)player progress:(float)progress {
    CGFloat progressValue = progress / 100.0f;
    [self.playLoadingProgress setProgress:progressValue];
}

/**
 更新播放器的填充模式
 */
- (void)setPlayerscalingMode{
    AVPTrackInfo *trackInfo = self.listPlayer.getMediaInfo.tracks.firstObject;
    if(trackInfo.videoWidth<trackInfo.videoHeight&&IPHONEX) {
        self.listPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFILL;
    }else {
        self.listPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT;
    }
}
#pragma mark - getter & setter
- (AliListPlayer *)listPlayer {
    if (!_listPlayer) {
        _listPlayer = [[AliListPlayer alloc]init];
        _listPlayer.loop = YES;
        _listPlayer.autoPlay = YES;
        _listPlayer.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT;
        AVPCacheConfig *config = [[AVPCacheConfig alloc]init];
        config.enable = YES;
        [_listPlayer setCacheConfig:config];
    }
    return _listPlayer;
}

- (UIView *)playImageView{
    if (!_playImageView) {
        CGFloat width = 70;
        _playImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        _playImageView.layer.cornerRadius = width / 2;
        _playImageView.clipsToBounds = YES;
        _playImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"temp_qu_play"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_playImageView addSubview:imageView];
        imageView.center = CGPointMake(_playImageView.frame.size.width / 2, _playImageView.frame.size.height / 2);
    }
    return _playImageView;;
}

- (UIProgressView *)playLoadingProgress{
    if (!_playLoadingProgress) {
        _playLoadingProgress = [[UIProgressView alloc]init];
        [_playLoadingProgress setProgressTintColor:[UIColor colorWithHexString:@"#1AD4FF"]];
        [_playLoadingProgress setTrackTintColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
    }
    return _playLoadingProgress;
}

- (AlivcShortVideoBasicVideoModel *)playingVideo {
    if (_currentIndex >= 0 && _currentIndex < self.videos.count) {
      return self.videos[_currentIndex];
    }
    return nil;
}

- (void)fetchSTSComplete:(void(^)(BOOL result))complete{
    __weak typeof(self) weakSelf = self;
    NSString *token = [AliVideoClientUser shared].token;
    [AlivcQuVideoServerManager quServerGetSTSWithToken:token
                                               success:^(NSString * _Nonnull accessKeyId,
                                                         NSString * _Nonnull accessKeySecret,
                                                         NSString * _Nonnull securityToken) {
                                                   [weakSelf updateAccessId:accessKeyId accessKeySecret:accessKeySecret securityToken:securityToken region:@"cn-shanghai"];
                                                   if (complete) {
                                                       complete(YES);
                                                   }
                                               } failure:^(NSString * _Nonnull errorString) {
                                                   [MBProgressHUD showMessage:errorString inView:weakSelf.vc.view];
                                                    complete(NO);
                                               }];
}

@end
