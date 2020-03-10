//
//  AliyunSVideoApi.m
//  qusdk
//
//  Created by Worthy Zhang on 2019/1/2.
//  Copyright © 2019 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunSVideoApi.h"
#import "AlivcDefine.h"
#import "AlivcMacro.h"


@implementation AliyunSVideoApi

+ (void)getImageUploadAuthWithToken:(NSString *)tokenString title:(NSString *)title filePath:(NSString *)filePath tags:(NSString *)tags handler:(void (^)(NSString * _Nullable, NSString * _Nullable, NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))handler{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{
                                       @"imageType":@"cover",
                                       @"imageExt":filePath.lastPathComponent.pathExtension
                                       }];
    if (title) {
        [params addEntriesFromDictionary:@{@"title":title}];
    }
    if (tags) {
        [params addEntriesFromDictionary:@{@"tags":tags}];
    }
    
    
    NSString *getUrl = @"/demo/getImageUploadAuth";
    AlivcOutputProductType type = kAlivcProductType;
    if (type == AlivcOutputProductTypeSmartVideo) {
        getUrl = @"/vod/getImageUploadAuth";
        if (tokenString) {
            [params addEntriesFromDictionary:@{@"token":tokenString}];
        }
    }
 
    
    [self getWithPath:getUrl params:params completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            handler(nil, nil, nil, nil, error);
        }else {
            NSString *uploadAddress = [responseObject objectForKey:@"uploadAddress"];
            NSString *uploadAuth = [responseObject objectForKey:@"uploadAuth"];
            NSString *imageURL = [responseObject objectForKey:@"imageURL"];
            NSString *imageId = [responseObject objectForKey:@"imageId"];
            handler(uploadAddress, uploadAuth, imageURL, imageId, nil);
        }
    }];
}

+ (void)getVideoUploadAuthWithWithToken:(NSString *)tokenString title:(NSString *)title filePath:(NSString *)filePath coverURL:(NSString *)coverURL desc:(NSString *)desc tags:(NSString *)tags handler:(void (^)(NSString * _Nullable, NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))handler{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{
                                       @"title":title,
                                       @"fileName":filePath.lastPathComponent
                                       }];
    if (coverURL) {
        [params addEntriesFromDictionary:@{@"coverURL":coverURL}];
    }
    if (desc) {
        [params addEntriesFromDictionary:@{@"description":desc}];
    }
    if (tags) {
        [params addEntriesFromDictionary:@{@"tags":tags}];
    }
   
    NSString *getUrl = @"/demo/getVideoUploadAuth";
    AlivcOutputProductType type = kAlivcProductType;
    if (type == AlivcOutputProductTypeSmartVideo) {
        getUrl = @"/vod/getVideoUploadAuth";
        if (tokenString) {
            [params addEntriesFromDictionary:@{@"token":tokenString}];
        }
    }
    
    [self getWithPath:getUrl params:params completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            handler(nil, nil, nil, error);
        }else {
            NSString *uploadAddress = [responseObject objectForKey:@"uploadAddress"];
            NSString *uploadAuth = [responseObject objectForKey:@"uploadAuth"];
            NSString *videoId = [responseObject objectForKey:@"videoId"];
            handler(uploadAddress, uploadAuth, videoId, nil);
        }
    }];
}


+ (void)refreshVideoUploadAuthWithToken:(NSString *)tokenString videoId:(NSString *)videoId handler:(void (^)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))handler{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (videoId) {
        [params addEntriesFromDictionary:@{@"videoId":videoId}];
    }
    
    
    NSString *getUrl = @"/demo/refreshVideoUploadAuth";
    AlivcOutputProductType type = kAlivcProductType;
    if (type == AlivcOutputProductTypeSmartVideo) {
        getUrl = @"/vod/refreshVideoUploadAuth";
        if (tokenString) {
            [params addEntriesFromDictionary:@{@"token":tokenString}];
        }
    }
    [self getWithPath:getUrl params:params completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            handler(nil, nil, error);
        }else {
            NSString *uploadAddress = [responseObject objectForKey:@"uploadAddress"];
            NSString *uploadAuth = [responseObject objectForKey:@"uploadAuth"];
            handler(uploadAddress, uploadAuth, nil);
        }
    }];
}




#pragma mark - Private Method

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params completionHandler:(void (^)(NSURLResponse *response, id responseObject,  NSError * error))completionHandler {
    
#warning 尊敬的客户，此Server服务只用于demo演示使用，无法作为商用服务上线使用，我们不能保证这个服务的稳定性，高并发性，请自行搭建自己的Server服务，如何集成自己的Server服务详见文档：https://help.aliyun.com/document_detail/108783.html?spm=a2c4g.11186623.6.1075.a70a3a4895Qysq。
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary *mutableParaDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    [mutableParaDic setObject:bundleID forKey:@"PACKAGE_NAME"];
    
    NSString *paramsString = [self getParamsString:mutableParaDic];
    NSString *urlString = [NSString
                    stringWithFormat:@"%@%@?%@", kAlivcQuUrlString, path, paramsString];
    
    NSURLSessionConfiguration *sessionConfiguration =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/json"
      forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:urlRequest
               completionHandler:^(NSData *_Nullable data,
                                   NSURLResponse *_Nullable response,
                                   NSError *_Nullable error) {
                   if (error) {
                       if (completionHandler) {
                           completionHandler(response, nil, error);
                       }
                       return;
                   }
                   
                   if (data == nil) {
                       NSError *emptyError =
                       [[NSError alloc] initWithDomain:@"AliyunSVideoApi"
                                                  code:-10000
                                              userInfo:nil];
                       if (completionHandler) {
                           completionHandler(response, nil, emptyError);
                       }
                       return;
                   }
                   
                   id jsonObj = [NSJSONSerialization
                                 JSONObjectWithData:data
                                 options:NSJSONReadingAllowFragments
                                 error:&error];
                   if (error) {
                       completionHandler(response, nil, error);
                       return;
                   }
                   
                   NSInteger code = [[jsonObj objectForKey:@"code"] integerValue];
                   if (code != 200) {
                       NSError *error = [NSError errorWithDomain:@"AliyunSVideoApi" code:code userInfo:jsonObj];
                       if (completionHandler) {
                           completionHandler(response, nil, error);
                       }
                       return;
                   }
                   
                   if (completionHandler) {
                       completionHandler(response, [jsonObj objectForKey:@"data"], nil);
                   }
                   
               }];
    
    [task resume];
    
    
}


+ (NSString *)getParamsString:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in params.allKeys) {
        id value = [params objectForKey:key];
        NSString *part = [NSString stringWithFormat:@"%@=%@", [self percentEncode:key], [self percentEncode:value]];
        [parts addObject: part];
    }
    
    NSArray<NSString *> *sortedArray = [parts sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *string = [sortedArray componentsJoinedByString:@"&"];
    return string;
}

+ (NSString *)percentEncode:(id)object {
    NSString *string = [NSString stringWithFormat:@"%@", object];
    
    NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@?/"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    
    NSString *percentstring = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    NSString * plusReplaced = [percentstring stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    NSString * starReplaced = [plusReplaced stringByReplacingOccurrencesOfString:@"*" withString:@"%2A"];
    NSString * waveReplaced = [starReplaced stringByReplacingOccurrencesOfString:@"%7E" withString:@"~"];
    return waveReplaced;
}
@end
