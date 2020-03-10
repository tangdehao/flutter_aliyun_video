//
//  AlivcShortVideoPlayControler.h
//  AliyunVideoClient_Entrance
//
//  Created by 孙震 on 2019/4/3.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlivcBaseViewController.h"
@class AlivcQuVideoModel;

NS_ASSUME_NONNULL_BEGIN

static NSString *AlivcNotificationDeleveVideoSuccess = @"AlivcDeleveVideoSuccess";

@interface AlivcShortVideoPlayViewController : AlivcBaseViewController

/**
 用于个人中心初始化播放控制器
 与首页的区别是数据源：推荐视频 VS 个人发布的视频
 @param videoList 视频列表
 @param startPlayIndex 开始播放的位置
 @return 播放控制器
 */
-(instancetype)initWithVideoList:(NSArray <AlivcQuVideoModel *>*)videoList
                  startPlayIndex:(NSInteger )startPlayIndex;
@end

NS_ASSUME_NONNULL_END
