//
//  AlivcShortVideoLiveModel.m
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/5/15.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import "AlivcShortVideoLiveVideoModel.h"

@implementation AlivcShortVideoLiveVideoModel

@synthesize durationString = _durationString;
@synthesize ID = _ID;
@synthesize title = _title;
@synthesize videoId = _videoId;
@synthesize videoDescription = _videoDescription;
@synthesize coverUrl = _coverUrl;
@synthesize statusString = _statusString;
@synthesize firstFrameUrl = _firstFrameUrl;
@synthesize sizeString = _sizeString;
@synthesize cateId = _cateId;
@synthesize tags = _tags;
@synthesize cateName = _cateName;
@synthesize belongUserId = _belongUserId;
@synthesize belongUserName = _belongUserName;
@synthesize belongUserAvatarUrl = _belongUserAvatarUrl;

/**
 指定初始化方法 - Designated Initializers
 
 @param dic 用于初始化的数据
 @return 实例化对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        //原始数据的获取
        _ID = dic[@"id"];
        _title = dic[@"title"];
        _videoId = dic[@"videoId"];
        _videoDescription = dic[@"description"];
        _durationString = dic[@"duration"];
        _coverUrl = dic[@"coverUrl"];
        _statusString = dic[@"status"];
        _firstFrameUrl = dic[@"firstFrameUrl"];
        _sizeString = dic[@"size"];
        _tags = dic[@"tags"];
        _cateId = dic[@"cateId"];
        _cateName = dic[@"cateName"];
        _liveId = dic[@"liveID"];
        _liveUrl = dic[@"liveUrl"];
        
        NSDictionary *belongUserDic = dic[@"user"];
        if ([belongUserDic isKindOfClass:[NSDictionary class]]) {
            _belongUserId = belongUserDic[@"userId"];
            _belongUserName = belongUserDic[@"userName"];
            _belongUserAvatarUrl = belongUserDic[@"avatarUrl"];
        }

    }
    
    return self;
}



@end
