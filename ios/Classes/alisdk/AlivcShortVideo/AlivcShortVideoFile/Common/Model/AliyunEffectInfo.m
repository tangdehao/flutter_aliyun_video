//
//  AliyunEffectInfo.m
//  AliyunVideo
//
//  Created by dangshuai on 17/3/11.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import "AliyunEffectInfo.h"
#import "AliyunEffectResourceModel.h"

@implementation AliyunEffectInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (NSString *)localFilterIconPath {
    return nil;
}

- (NSString *)localFilterResourcePath {
    return nil;
}

- (NSString *)filterTypeName{
    NSString *typeName = @"";
    switch (_filterType) {
        case AliyunFilterTypNone:
            typeName = @"";
            break;
        case AliyunFilterTypeFace:
            typeName = NSLocalizedString(@"人物类" , nil);
            break;
        case AliyunFilterTypeFood:
            typeName = NSLocalizedString(@"食物类" , nil);
            break;
        case AliyunFilterTypeScenery:
            typeName = NSLocalizedString(@"风景类" , nil);
            break;
        case AliyunFilterTypePet:
            typeName = NSLocalizedString(@"宠物类" , nil);
            break;
        case AliyunFilterTypeSpecialStyle:
            typeName = NSLocalizedString(@"特殊风格类" , nil);
            break;
        default:
            break;
    }
    return typeName;
}


@end
