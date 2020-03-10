//
//  AlivcQuVideoServerManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/14.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcQuVideoServerManager.h"
#import "AlivcAppServer.h"
#import "NSString+AlivcHelper.h"
#import "AlivcQuVideoModel.h"
#import "AlivcShortVideoLiveVideoModel.h"
#import "AlivcDefine.h"




@implementation AlivcQuVideoServerManager

#pragma mark - 重复代码抽象 - 供本类调用

/**
 get请求统一处理

 @param urlString get的url
 @param success 成功的结果回调
 @param failure 失败的结果回调
 */
+ (void)p_getWithUrlString:(NSString *)urlString success:(void (^)(id data))success failure:(void (^)(NSString *errDes))failure{
    [AlivcAppServer getWithUrlString:urlString completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            failure([@"网络错误" localString]);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                success(dataObject);
            } doFailure:^(NSString * errorStr) {
                failure(errorStr);
            }];
        }
    }];
}

/**
 post请求统一处理

 @param urlString post的url字符串
 @param paramDic 参数
 @param success 成功的结果回调
 @param failure 失败的结果回调
 */
+ (void)p_postWithUrlString:(NSString *)urlString params:(NSDictionary *)paramDic success:(void (^)(id data))success failure:(void (^)(NSString *errDes))failure{
    
  
    [AlivcAppServer postWithUrlString:urlString parameters:paramDic completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            failure([@"网络错误" localString]);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                success(dataObject);
            } doFailure:^(NSString * errorStr) {
                failure(errorStr);
            }];
        }
    }];
}

/**
 生成get请求的字符串

 @param orininalString 问号之前的原始请求url
 @param paramDic 参数：字符串：字符串 - 请确保这个，否则不要使用本方法快捷生成
 @return 拼接好的getUrl字符串
 */
+ (NSString *)p_creatUrlGetStringWithOriginalUrlString:(NSString *)orininalString param:(NSDictionary *)paramDic{
    __block NSString *resultString = [orininalString stringByAppendingString:@"?"];
    [paramDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        NSString *itemString = [NSString stringWithFormat:@"%@=%@&",key,obj];
        resultString = [resultString stringByAppendingString:itemString];
    }];
    resultString = [resultString substringToIndex:resultString.length - 1];
    return resultString;
}




#pragma mark - Public Method
//获获取播放的sts校验数据
+ (void)quServerGetSTSWithToken:(NSString *)token success:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure{
    NSString *urlString = @"/demo/getSts";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@?token=%@",kAlivcQuUrlString,urlString,token];
    
    [self p_getWithUrlString:allUrlString success:^(id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            //
            NSDictionary *dataDic = (NSDictionary *)data;
            //AccessKeyId
            NSString *keyIDString = dataDic[@"accessKeyId"];
            //AccessKeySecret
            NSString *accessKeySecret = dataDic[@"accessKeySecret"];
            //SecurityToken
            NSString *securityToken = dataDic[@"securityToken"];
            if (keyIDString && accessKeySecret && securityToken) {
                success(keyIDString,accessKeySecret,securityToken);
                return ;
            }
        }
        failure([@"数据解析错误" localString]);
    } failure:^(NSString *errDes) {
        failure(errDes);
    }];
}


//发布视频
+ (void)quServerVideoPublishWithDic:(NSDictionary *)paramDic success:(void (^)(void))success failure:(void (^)(NSString * _Nonnull))failure{
    NSString *urlString = @"/vod/videoPublish";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",kAlivcQuUrlString,urlString];
    [self p_postWithUrlString:allUrlString params:paramDic success:^(id data) {
        success();
    } failure:^(NSString *errDes) {
        failure(errDes);
    }];
}


//推荐的视频列表

+ (void)quServerGetRecommendVideoListWithToken:(NSString *)token pageIndex:(NSInteger)index pageSize:(NSInteger)count lastEndVideoId:(NSString *)videoId success:(void (^)(NSArray<AlivcQuVideoModel *> * _Nonnull,NSInteger))success failure:(void (^)(NSString * _Nonnull))failure{
    NSString *urlString = @"/vod/getRecommendVideoList";
    [self p_quServerVideoListWithUrlString:urlString token:token pageIndex:index pageSize:count lastEndVideoId:videoId success:success failure:failure];
}
//个人中心的视频列表
+ (void)quServerGetPersonalVideoListWithToken:(NSString *)token pageIndex:(NSInteger)index pageSize:(NSInteger)count lastEndVideoId:(NSString *)videoId success:(void (^)(NSArray<AlivcQuVideoModel *> * _Nullable,NSInteger))success failure:(void (^)(NSString * _Nonnull))failure{
    if (!token) {
        failure(@"登录失败");
        return;
    }
    NSString *urlString = @"/vod/getPersonalVideoList";
    [self p_quServerVideoListWithUrlString:urlString token:token pageIndex:index pageSize:count lastEndVideoId:videoId success:success failure:failure];
}

//查询视频列表
+ (void)p_quServerVideoListWithUrlString:(NSString *)urlString token:(NSString *)token pageIndex:(NSInteger)index pageSize:(NSInteger)count lastEndVideoId:(NSString *)videoId success:(void (^)(NSArray<AlivcQuVideoModel *> * _Nonnull,NSInteger))success failure:(void (^)(NSString * _Nonnull))failure{
    
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",kAlivcQuUrlString,urlString];
    NSString *indexString = [NSString stringWithFormat:@"%ld",(long)index];
    NSString *countString = [NSString stringWithFormat:@"%ld",(long)count];
    NSDictionary *paramDic = @{@"token":token,@"pageIndex":indexString,@"pageSize":countString};
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithDictionary:paramDic];
    if (videoId) {
        [mDic setObject:videoId forKey:@"id"];
    }
    NSString *resultUrlString = [self p_creatUrlGetStringWithOriginalUrlString:allUrlString param:mDic];
    
    [self p_getWithUrlString:resultUrlString success:^(id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            //
            NSDictionary *dataDic = (NSDictionary *)data;
            NSArray *dics = dataDic[@"videoList"];
            NSInteger totalCount = [dataDic[@"total"]integerValue];
            if (dics.count) {
                NSMutableArray *tempMArray = [[NSMutableArray alloc]initWithCapacity:dics.count];
                [dics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        AlivcQuVideoModel *model = [[AlivcQuVideoModel alloc]initWithDic:(NSDictionary *)obj];
                        [tempMArray insertObject:model atIndex:idx];
                    }
                }];
                NSArray *resultArray = [[NSArray alloc]initWithArray:tempMArray];
                success(resultArray,totalCount);
                return ;
            }else{
                success([NSArray array],0);
                return ;
            }
        }
        failure([@"数据解析错误" localString]);
    } failure:^(NSString *errDes) {
        failure(errDes);
    }];
}



//删除个人视频
+ (void)quServerDeletePersonalVideoWithToken:(NSString *)token videoId:(NSString *)videId userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSString * _Nonnull))failure{
    NSString *urlString = @"/vod/deleteVideoById";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",kAlivcQuUrlString,urlString];
    NSDictionary *paramDic = @{@"token":token,@"videoId":videId,@"userId":userId};
    
    [self p_postWithUrlString:allUrlString params:paramDic success:^(id data) {
        success();
    } failure:^(NSString *errDes) {
        failure(errDes);
    }];
}

// 获取播流列表
+ (void)getRecommendLiveListWithToken:(NSString *)token pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize success:(void (^)(NSArray<AlivcShortVideoLiveVideoModel *> * _Nonnull,NSInteger totalCount))success failure:(void (^)(NSString * _Nonnull))failure {
    
    NSString *urlString = @"/vod/getRecommendLiveList";
    NSString *fullUrlString = [NSString stringWithFormat:@"%@%@",kAlivcQuUrlString,urlString];
    NSDictionary *paramDic = @{@"token":token,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":[NSNumber numberWithInteger:pageSize]};
    NSString *resultUrlString = [self p_creatUrlGetStringWithOriginalUrlString:fullUrlString param:paramDic];
    
    [self p_getWithUrlString:resultUrlString success:^(id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            //
            NSDictionary *dataDic = (NSDictionary *)data;
            NSArray *dics = dataDic[@"liveList"];
            NSInteger totalCount = [dataDic[@"total"]integerValue];
            if (dics.count) {
                NSMutableArray *tempMArray = [[NSMutableArray alloc]initWithCapacity:dics.count];
                [dics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        AlivcShortVideoLiveVideoModel *model = [[AlivcShortVideoLiveVideoModel alloc]initWithDic:(NSDictionary *)obj];
                        [tempMArray insertObject:model atIndex:idx];
                    }
                }];
                NSArray *resultArray = [[NSArray alloc]initWithArray:tempMArray];
                success(resultArray,totalCount);
                return ;
            }else{
                success([NSArray array],0);
                return ;
            }
        }
        failure([@"数据解析错误" localString]);
    } failure:^(NSString *errDes) {
        failure(errDes);
    }];
    
    
}



@end
