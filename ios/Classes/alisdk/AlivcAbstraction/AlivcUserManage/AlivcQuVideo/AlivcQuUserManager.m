//
//  AlivcQuUserManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/10.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcQuUserManager.h"
#import "AlivcAppServer.h"
#import "AlivcDefine.h"


@implementation AlivcQuUserManager

+ (void)randomAUserSuccess:(void (^)(void))success failure:(void (^)(NSString * _Nonnull))failure{
    
    NSString *urlString = @"/user/randomUser";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@?",kAlivcQuUrlString,urlString];
    [AlivcAppServer getWithUrlString:allUrlString completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            failure(errString);
            NSLog(@"%@ error:%@", allUrlString, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                NSDictionary *dataDic = (NSDictionary *)dataObject;
                [AliVideoClientUser shared].avatarImage = nil;
                [[AliVideoClientUser shared]setValueWithInfo:dataDic];
                success();
            } doFailure:^(NSString * errorStr) {
                if (failure) {
                    failure(errString);
                }
                NSLog(@"%@ error:%@", allUrlString, errorStr);
            }];
            
        }
    }];
}

+ (void)updateNickname:(NSString *)nickname withToken:(NSString *)token userId:(NSString *)userId success:(void (^)(void))success failure:(void (^)(NSString * _Nonnull))failure{
    
    
    if (!nickname || !token || !userId) {
        failure(@"参数不能为空哦");
        return;
    }
    NSString *urlString = @"/user/updateUser";
    NSString *allUrlString = [NSString stringWithFormat:@"%@%@",kAlivcQuUrlString,urlString];
    NSDictionary *dic = @{@"nickname":nickname,@"token":token,@"userId":userId};
    [AlivcAppServer postWithUrlString:allUrlString parameters:dic completionHandler:^(NSString * _Nullable errString, NSDictionary * _Nullable resultDic) {
        if (errString) {
            failure(errString);
            NSLog(@"%@ error:%@", allUrlString, errString);
        }else{
            [AlivcAppServer judgmentResultDic:resultDic success:^(id dataObject) {
                
                [[AliVideoClientUser shared]setNickName:nickname];
                success();
            } doFailure:^(NSString * errorStr) {
                if (failure) {
                    failure(errString);
                }
                NSLog(@"%@ error:%@", allUrlString, errorStr);
            }];
            
        }
    }];
}
@end
