//
//  AlivcUserInfoViewController.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcBaseViewController.h"

/**
 界面类型

 - AlivcUserVCTypeLive: 互动直播 - 默认值
 - AlivcUserVCTypeQuVideo: 趣视频
 - AlivcUserVCTypeVersion: 设置 - 展示版本信息
 */
typedef NS_ENUM(NSInteger, AlivcUserVCType){
    AlivcUserVCTypeLive = 0,
    AlivcUserVCTypeQuVideo,
    AlivcUserVCTypeVersion
};

static NSString *AlivcNotificationChangeUserSuccess = @"AlivcNotificationChangeUserSuccess";

@interface AlivcUserInfoViewController : AlivcBaseViewController

/**
 界面类型
 */
@property (nonatomic, assign) AlivcUserVCType type;

/**
 当界面类型是趣视频的时候，当时的状态，是否有视频在发布中，发布中的话，不能更换用户
 */
@property (nonatomic, assign) BOOL isPublishing;

@end
