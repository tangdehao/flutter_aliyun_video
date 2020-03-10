//
//  AlivcQuVideoServerManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/14.
//  Copyright © 2019年 Alibaba. All rights reserved.
//  趣视频业务server请求的管理类

#import <Foundation/Foundation.h>

@class AlivcQuVideoModel;
@class AlivcShortVideoLiveVideoModel;

NS_ASSUME_NONNULL_BEGIN

@interface AlivcQuVideoServerManager : NSObject


/**
 获取播放的sts校验数据

 @param token 用户token
 @param success 成功
 @param failure 失败
 */
+ (void)quServerGetSTSWithToken:(NSString *)token success:(void(^)(NSString *accessKeyId, NSString *accessKeySecret, NSString *securityToken))success failure:(void (^)(NSString *errorString))failure;

/**
 发布一个视频

 @param paramDic 视频模型类
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)quServerVideoPublishWithDic:(NSDictionary *)paramDic success:(void(^)(void))success failure:(void (^)(NSString *errorString))failure;


/**
 请求推荐的视频列表

 @param token 用户token
 @param index 起始页
 @param count 页面条数
 @param videoId 本次查询的视频id所在的位置为起点，不包含此视频id，有值的时候index不起作用,此id是ID，数据库递增的标识
 @param success 成功
 @param failure 失败
 */
+ (void)quServerGetRecommendVideoListWithToken:(NSString *)token pageIndex:(NSInteger )index pageSize:(NSInteger)count lastEndVideoId:(NSString *__nullable)videoId success:(void(^)(NSArray <AlivcQuVideoModel *>*videoList,NSInteger allVideoCount))success failure:(void (^)(NSString *errorString))failure;

/**
 请求个人的视频列表
 
 @param token 用户token
 @param index 起始页
 @param count 页面条数
 @param videoId 本次查询的视频id所在的位置为起点，不包含此视频id，有值的时候index不起作用,此id是ID，数据库递增的标识
 @param success 成功
 @param failure 失败
 */
+ (void)quServerGetPersonalVideoListWithToken:(NSString *)token pageIndex:(NSInteger )index pageSize:(NSInteger)count lastEndVideoId:(NSString *__nullable)videoId success:(void(^)(NSArray <AlivcQuVideoModel *>* __nullable videoList,NSInteger allVideoCount))success failure:(void (^)(NSString *errorString))failure;

/**
 删除个人视频

 @param token token
 @param videId 视频id
 @param userId 用户id
 @param success 成功
 @param failure 失败
 */
+ (void)quServerDeletePersonalVideoWithToken:(NSString *)token videoId:(NSString *)videId userId:(NSString *)userId success:(void(^)(void))success failure:(void (^)(NSString *errorString))failure;



/**
 获取播流列表
 @param token token
 @param pageIndex pageIndex
 @param pageSize pageSize
 @param success 成功
 @param failure 失败
 */
+ (void)getRecommendLiveListWithToken:(NSString *)token pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(void (^)(NSArray<AlivcShortVideoLiveVideoModel *> * _Nonnull,NSInteger totalCount))success failure:(void (^)(NSString * _Nonnull))failure;

@end

NS_ASSUME_NONNULL_END
