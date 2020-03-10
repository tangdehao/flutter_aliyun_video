//
//  AlivcQuVideoModel.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/9.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcQuVideoModel.h"



@implementation AlivcQuVideoModel

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
        
        NSDictionary *belongUserDic = dic[@"user"];
        if ([belongUserDic isKindOfClass:[NSDictionary class]]) {
            _belongUserId = belongUserDic[@"userId"];
            _belongUserName = belongUserDic[@"userName"];
            _belongUserAvatarUrl = belongUserDic[@"avatarUrl"];
        }
        
        _creationTimeString = dic[@"creationTime"];
        _transcodeStatusString = dic[@"transcodeStatus"];
        _snapshotStatusString = dic[@"snapshotStatus"];
        _censorStatusString = dic[@"censorStatus"];
        _narrowTranscodeStatusString = dic[@"narrowTranscodeStatus"];
       
        [self handleOriginalData];
    
    }
    return self;
}


/**
 处理二次包装的数据
 */
- (void)handleOriginalData{
    
    if (_durationString) {
        _duration = [_durationString integerValue];
    }
    if (_creationTimeString) {
        //
    }
    
    _transcodeStatus = [self statusWithString:_transcodeStatusString];
    _snapshotStatus = [self statusWithString:_snapshotStatusString];
    _ensorStatus = [self statusWithString:_censorStatusString];
    _narrowTranscodeStatus = [self statusWithString:_narrowTranscodeStatusString];
}

- (AlivcQuVideoAbstractionStatus )statusWithString:(NSString *)statusString{
    if ([statusString isEqualToString:@"success"]) {
        return AlivcQuVideoAbstractionStatus_Success;
    }
    if ([statusString isEqualToString:@"fail"]) {
        return AlivcQuVideoAbstractionStatus_Fail;
    }
    if ( [statusString isEqualToString:@"check"]) {
        return AlivcQuVideoAbstractionStatus_On;//如果是待审核的状态，客户端也是审核中的状态
    }
   
    return AlivcQuVideoAbstractionStatus_On;
}
@end
