//
//  AlivcShortVideoPlayerPresent.h
//  AliyunVideoClient_Entrance
//
//  Created by 孙震 on 2019/4/9.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AlivcQuVideoModel;
@interface AlivcShortVideoPlayerManager : NSObject

- (instancetype)initWithVC:(UIViewController *)vc;

//视频显示的视图
@property (nonatomic, strong) UIView *playView;
//正在播放的视频在数组中的位置
@property (nonatomic, assign) NSInteger currentIndex;
//正在播放的视频模型
@property (nonatomic, strong, readonly) AlivcQuVideoModel *playingVideo;

//是否可以播放
@property (nonatomic, assign) BOOL canPlay;
//停止播放
- (void)stop;
//暂停
- (void)pause;
//恢复播放
- (void)resume;
//清空播放列表
- (void)clear;
//把video添加到播放列表中
- (void)addPlayList:(NSArray *)videos;
//播放index位置的视频
- (void)playAtIndex:(NSInteger)index;
//移除播放视频
- (void)removeVideoAtIndex:(NSInteger)index;
//移除播放视图
- (void)removePlayView;
//更新accessId等。。。
- (void)updateAccessId:(NSString *)accessId accessKeySecret:(NSString *)accessKeySecret
         securityToken:(NSString *)securityToken region:(NSString *)region;
@end

NS_ASSUME_NONNULL_END
