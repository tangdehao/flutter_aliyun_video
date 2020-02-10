//
//  AlivcAppServer.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/16.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcAppServer.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+AlivcHelper.h"
#import "AlivcDefine.h"

@implementation AlivcAppServer

+ (AFHTTPSessionManager*) manager
{
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString * appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString *appVersionName = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString * appVersionCode = [appVersionName stringByReplacingOccurrencesOfString:@"." withString:@""];
        [manager.requestSerializer setValue:appName forHTTPHeaderField:@"appName"];
        [manager.requestSerializer setValue:bundleId forHTTPHeaderField:@"bundleId"];
        [manager.requestSerializer setValue:appVersionName forHTTPHeaderField:@"appVersionName"];
        [manager.requestSerializer setValue:appVersionCode forHTTPHeaderField:@"appVersionCode"];
        manager.requestSerializer.timeoutInterval = 10;
        manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    });
    
    return manager;
}

+ (void)getWithUrlString:(NSString *)urlString completionHandler:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))handle{
    [self getWithUrlString:urlString parameters:@{} completionHandler:handle];
}

+ (void)getWithUrlString:(NSString *)urlString
              parameters:(id)parameters
       completionHandler:(void (^)(NSString *__nullable errString,NSDictionary *_Nullable resultDic))handle{
   
      #warning 尊敬的客户，此Server服务只用于demo演示使用，无法作为商用服务上线使用，我们不能保证这个服务的稳定性，高并发性，请自行搭建自己的Server服务，如何集成自己的Server服务详见文档：https://help.aliyun.com/document_detail/108783.html?spm=a2c4g.11186623.6.1075.a70a3a4895Qysq。
    NSMutableString * string ;
    NSDictionary *paraDic = [NSDictionary dictionaryWithDictionary:parameters];
    if (paraDic && paraDic.count >0 ) {
        
        string = [[NSMutableString alloc]initWithString:[self p_creatUrlGetStringWithOriginalUrlString:urlString param:paraDic]];
    }else {
        string= [NSMutableString stringWithString:urlString];
    }
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    // 拼接包名参数
     string = [self jointUrl:string withBundleId:bundleID];
    
    [[self manager] GET:string parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            handle(nil,resultDic);
        }else{
            handle(@"数据格式异常",nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(error.description,nil);
    }];
}
+ (void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parametersDic completionHandler:(void (^)(NSString * _Nullable, NSDictionary * _Nullable))handle{
    
#warning 尊敬的客户，此Server服务只用于demo演示使用，无法作为商用服务上线使用，我们不能保证这个服务的稳定性，高并发性，请自行搭建自己的Server服务，如何集成自己的Server服务详见文档：https://help.aliyun.com/document_detail/108783.html?spm=a2c4g.11186623.6.1075.a70a3a4895Qysq。
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *mutableParaDic = [[NSMutableDictionary alloc]initWithDictionary:parametersDic];
    if ([urlString hasPrefix:AlivcVideoPlayUrlString]) {
       // 播放器 没有包名校验功能
    }else{
    [mutableParaDic setObject:bundleID forKey:@"PACKAGE_NAME"];
    }
    
    [[self manager] POST:urlString parameters:mutableParaDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            handle(nil,resultDic);
        }else{
            handle(@"数据格式异常",nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handle(error.description,nil);
    }];
}

/**
 统一处理返回的结果字典
 
 @param resultDic 结果字典
 @param success 结果字典表明请求成功，那么解析出数据字典让别人使用
 @param failure 失败
 */
+ (void)judgmentResultDic:(NSDictionary *)resultDic success:(void (^)(id dataObject))success doFailure:(void (^)(NSString *))failure{
    BOOL isSucess = [resultDic[@"result"] boolValue];
    if (isSucess) {
        id dataObject = resultDic[@"data"];
        success(dataObject);
    }else{
        NSString *messageString = resultDic[@"message"];
        failure(messageString);
    }
}

// 缩略图需要
+ (void)getStsDataSucess:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))sucess failure:(void (^)(NSString * _Nonnull))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/demo/getSts",kAlivcQuUrlString];
    
    AFHTTPSessionManager *manager = [self manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject[@"data"];
        NSLog(@"%@",resultDic);
        //AccessKeyId
        NSString *keyIDString = resultDic[@"accessKeyId"];
        //AccessKeySecret
        NSString *accessKeySecret = resultDic[@"accessKeySecret"];
        //SecurityToken
        NSString *securityToken = resultDic[@"securityToken"];
        if (keyIDString && accessKeySecret && securityToken) {
            dispatch_async(dispatch_get_main_queue(), ^{
                sucess(keyIDString,accessKeySecret,securityToken);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failure([@"数据解析错误" localString]);
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1009) {
            failure([@"当前无网络,请检查网络连接" localString]);
        }else{
            failure(error.description);
        }
    }];
}

+ (void)getStsDataWithVid:(NSString *)vidString sucess:(void (^)(NSString *, NSString *, NSString *))sucess failure:(void (^)(NSString *))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"https://demo-vod.cn-shanghai.aliyuncs.com/voddemo/CreateSecurityToken?BusinessType=vodai&TerminalType=pc&DeviceModel=iPhone9,2&UUID=59ECA-4193-4695-94DD-7E1247288&AppVersion=1.0.0&VideoId=%@",vidString];
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requst completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError;
            if (data) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
                NSDictionary *resultDic = responseDic[@"SecurityTokenInfo"];
                NSLog(@"%@",resultDic);
                //AccessKeyId
                NSString *keyIDString = resultDic[@"AccessKeyId"];
                //AccessKeySecret
                NSString *accessKeySecret = resultDic[@"AccessKeySecret"];
                //SecurityToken
                NSString *securityToken = resultDic[@"SecurityToken"];
                if (keyIDString && accessKeySecret && securityToken) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sucess(keyIDString,accessKeySecret,securityToken);
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure([@"数据解析错误" localString]);
                    });
                    
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure([@"返回数据为空" localString]);
                });
                
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.code == -1009) {
                    failure([@"当前无网络,请检查网络连接" localString]);
                }else{
                    failure(error.description);
                }
                
            });
        }
    }];
    [task resume];
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

/**
 生成请求的字符串
 
 @param urlStr 原始请求url
 @param bundleId 参数：包名
 @return 拼接好的getUrl字符串
 */

+ (NSMutableString *)jointUrl:(NSString *)urlStr withBundleId:(NSString *)bundleId{
    
    NSMutableString * string= [NSMutableString stringWithString:urlStr];
    
    if ([urlStr hasPrefix:AlivcVideoPlayUrlString]) {
        // 播放器 没有包名校验功能
        return string;
    }else{
        
        if ([[urlStr substringFromIndex:(string.length - 1)] isEqualToString:@"?"]) {
            [string appendString:[NSString stringWithFormat:@"%@=%@",@"PACKAGE_NAME",bundleId]];
        }else if(![string containsString:@"?"]){
            [string appendString:[NSString stringWithFormat:@"?%@=%@",@"PACKAGE_NAME",bundleId]];
        }else{
            [string appendString:[NSString stringWithFormat:@"&%@=%@",@"PACKAGE_NAME",bundleId]];
        }
    }
    
    return string;
    
}



@end
