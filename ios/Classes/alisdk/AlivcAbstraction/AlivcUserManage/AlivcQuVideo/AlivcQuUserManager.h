//
//  AlivcQuUserManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/10.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliVideoClientUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlivcQuUserManager : NSObject
/**
 获取一个随机的用户信息 - 赋值给单例AlivcUser
 
 @param success 成功
 @param failure 失败
 */
+ (void)randomAUserSuccess:(void(^)(void))success failure:(void (^)(NSString *errDes))failure;

/**
 更新用户昵称

 @param nickname 昵称
 @param success 成功
 @param failure 失败
 */
+ (void)updateNickname:(NSString *)nickname withToken:(NSString *)token userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSString * _Nonnull errDes))failure;
@end

NS_ASSUME_NONNULL_END
