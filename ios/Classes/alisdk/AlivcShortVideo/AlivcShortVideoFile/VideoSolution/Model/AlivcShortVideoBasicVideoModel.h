//
//  AlivcShortVideoBasicModel.h
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/5/15.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlivcShortVideoBasicVideoModel : NSObject

#pragma mark - 原始数据

/**
 id - 数据库自动递增的标识
 */
@property (strong, nonatomic, readonly) NSString *ID;

/**
 视频标题
 */
@property (strong, nonatomic, readonly) NSString *title;

/**
 视频id
 */
@property (strong, nonatomic, readonly) NSString *videoId;

/**
 视频描述
 */
@property (strong, nonatomic, readonly) NSString *videoDescription;

/**
 视频时长（秒）
 */
@property (strong, nonatomic, readonly) NSString *durationString;

/**
 视频封面URL
 */
@property (strong, nonatomic, readonly) NSString *coverUrl;

/**
 视频状态 - 现在没有用到 - 以后可能用到 - 所以先放这里
 */
@property (strong, nonatomic, readonly) NSString *statusString __attribute__((deprecated("视频状态 - 现在没有用到 - 统一由具体的四个状态来确定")));

/**
 首帧地址
 */
@property (strong, nonatomic, readonly) NSString *firstFrameUrl;

/**
 视频源文件大小（字节）
 */
@property (strong, nonatomic, readonly) NSString *sizeString;

/**
 视频标签,多个用逗号分隔?
 */
@property (strong, nonatomic, readonly) NSString *tags;

/**
 视频分类
 */
@property (strong, nonatomic, readonly) NSString *cateId;

/**
 视频分类名称
 */
@property (strong, nonatomic, readonly) NSString *cateName;


/**
 所属的用户id
 */
@property (strong, nonatomic, readonly) NSString *belongUserId;

/**
 所属的用户名
 */
@property (strong, nonatomic, readonly) NSString *belongUserName;

/**
 所属的用户的头像URL
 */
@property (strong, nonatomic, readonly) NSString *belongUserAvatarUrl;


/**
 封面图 - 内部不会请求，由使用者自己管理
 */
@property (strong, nonatomic) UIImage *coverImage;

/**
 首帧图 - 内部不会请求，由使用者自己管理
 */
@property (strong, nonatomic) UIImage *firstFrameImage;

/**
 所属的用户的头像
 */
@property (strong, nonatomic) UIImage *belongUserAvatarImage;

@end

NS_ASSUME_NONNULL_END
