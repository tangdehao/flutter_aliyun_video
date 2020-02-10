//
//  AlivcRecordBeautyView.m
//  AliyunVideoClient_Entrance
//
//  Created by wanghao on 2019/5/5.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcRecordBeautyView.h"
#import "AlivcLiveBeautifySettingsViewController.h"
#import "AlivcPushBeautyDataManager.h"

@interface AlivcRecordBeautyView()<AlivcLiveBeautifySettingsViewControllerDelegate>
@property (nonatomic, strong) AlivcLiveBeautifySettingsViewController *beatyFaceViewControl;//美颜界面
@property (nonatomic, strong) AlivcLiveBeautifySettingsViewController *beatySkinViewControl;//美肌界面

@property (nonatomic, strong) AlivcPushBeautyDataManager *beautyFaceDataManager_normal;     //普通美颜的数据管理器
@property (nonatomic, strong) AlivcPushBeautyDataManager *beautyFaceDataManager_advanced;   //高级美颜的数据管理器
@property (nonatomic, strong) AlivcPushBeautyDataManager *beautySkinDataManager;            //美肌的数据管理器


@end
//TODO:只做了基础的UI托板的优化，和部分美颜代理方法的优化，AlivcLiveBeautifySettingsViewController可以优化成View，更方便使用
@implementation AlivcRecordBeautyView

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray<AlivcBottomMenuHeaderViewItem *> *)items{
    self = [super initWithFrame:frame withItems:items];
    if (self) {
       [self settingBeautyParams];
        [self addSubview:self.beatyFaceViewControl.view];
        [self.beatySkinViewControl.view setHidden:YES];
        [self addSubview:self.beatySkinViewControl.view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (AlivcLiveBeautifySettingsViewController *)beatyFaceViewControl{
     __weak typeof(self) weakSelf = self;
    if (!_beatyFaceViewControl) {
        //默认档位
        NSInteger level = [self.beautyFaceDataManager_advanced getBeautyLevel];
        //可供微调的选择
        NSArray *dics = @[[self.beautyFaceDataManager_advanced SkinPolishingDic],[self.beautyFaceDataManager_advanced SkinWhiteningDic],[self.beautyFaceDataManager_advanced SkinShiningDic]];
        
        _beatyFaceViewControl = [AlivcLiveBeautifySettingsViewController settingsViewControllerWithLevel:level detailItems:dics];
        //因为control没有展示在界面上，所有view手动设置frame
        _beatyFaceViewControl.view.frame = self.bounds;
        //设置高低级美颜
        if (self.currentBeautyType == AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Base) {
            [_beatyFaceViewControl setUIStyle:AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Base];
            //设置档位
            NSInteger level = [self.beautyFaceDataManager_normal getBeautyLevel];
            [_beatyFaceViewControl updateLevel:level];
        }else{
            [_beatyFaceViewControl setUIStyle:AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Advanced];
            //设置档位
            NSInteger level = [self.beautyFaceDataManager_advanced getBeautyLevel];
            [_beatyFaceViewControl updateLevel:level];
        }
        [_beatyFaceViewControl registerBeautifyViewActionBlock:^(NSInteger tag) {
            [weakSelf didSelectHeaderViewWithIndex:tag];
        }];
        _beatyFaceViewControl.delegate = self;
    }
    return _beatyFaceViewControl;
}

- (AlivcLiveBeautifySettingsViewController *)beatySkinViewControl{
     __weak typeof(self) weakSelf = self;
    if (!_beatySkinViewControl) {
        //默认档位
        NSInteger level = [self.beautySkinDataManager getBeautyLevel];
        //可供微调的选择
        NSArray *dics = @[[self.beautySkinDataManager EyeWideningDic],[self.beautySkinDataManager FaceSlimmingDic]];
        
        _beatySkinViewControl = [AlivcLiveBeautifySettingsViewController settingsViewControllerWithLevel:level detailItems:dics];
         [_beatySkinViewControl setUIStyle:AlivcBeautySettingViewStyle_ShortVideo_BeautySkin];
        //因为control没有展示在界面上，所有view手动设置frame
        _beatySkinViewControl.view.frame = self.bounds;
        
        [_beatySkinViewControl registerBeautifyViewActionBlock:^(NSInteger tag) {
            [weakSelf didSelectHeaderViewWithIndex:tag];
        }];
        _beatySkinViewControl.delegate = self;
    }
    return _beatySkinViewControl;
}

- (AlivcPushBeautyDataManager *)beautyFaceDataManager_normal{
    if (!_beautyFaceDataManager_normal) {
        _beautyFaceDataManager_normal = [[AlivcPushBeautyDataManager alloc]initWithType:AlivcPushBeautyParamsTypeShortVideo customSaveString:AlivcBeautyParamsTypeShortVideo_Base];
    }
    return _beautyFaceDataManager_normal;
}
- (AlivcPushBeautyDataManager *)beautyFaceDataManager_advanced{
    if (!_beautyFaceDataManager_advanced) {
        _beautyFaceDataManager_advanced = [[AlivcPushBeautyDataManager alloc]initWithType:AlivcPushBeautyParamsTypeShortVideo customSaveString:AlivcBeautyParamsTypeShortVideo_Advanced];
    }
    return _beautyFaceDataManager_advanced;
}
- (AlivcPushBeautyDataManager *)beautySkinDataManager{
    if (!_beautySkinDataManager) {
        _beautySkinDataManager = [[AlivcPushBeautyDataManager alloc]initWithType:AlivcPushBeautyParamsTypeShortVideo customSaveString:AlivcBeautyParamsTypeShortVideo_BeautySkin];
    }
    return _beautySkinDataManager;
}

- (void)settingBeautyParams{
    //美颜参数
    _beautyParams = [self.beautyFaceDataManager_advanced getBeautyParamsOfLevel:[self.beautyFaceDataManager_advanced getBeautyLevel]];
    //美肌参数
    _beautySkinParams = [self.beautySkinDataManager getBeautyParamsOfLevel:[self.beautySkinDataManager getBeautyLevel]];
    //当前美颜类型
    _currentBeautyType = (AlivcBeautySettingViewStyle)[[NSUserDefaults standardUserDefaults] integerForKey:@"shortVideo_beautyType"];
    //当前基础美颜等级
    _currentBaseBeautyLevel = [self.beautyFaceDataManager_normal getBeautyLevel];
}
- (void)alivcBottomMenuHeaderViewAction:(UIButton *)button{
    BOOL isBeatyFace =button.tag == 1?YES:NO;
    [self.beatyFaceViewControl.view setHidden:!isBeatyFace];
    [self.beatySkinViewControl.view setHidden:isBeatyFace];
}

#pragma mark - AlivcLiveBeautifySettingsViewControllerDelegate
- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeLevel:(NSInteger)level{
    switch (viewController.currentStyle) {
        case AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Base:
        {
            //基础美颜
            [_beautyFaceDataManager_normal saveBeautyLevel:level];
            if (self.delegate && [self.delegate respondsToSelector:@selector(alivcRecordBeautyDidChangeBaseBeautyLevel:)]) {
                [self.delegate alivcRecordBeautyDidChangeBaseBeautyLevel:level];
            }
            NSLog(@"基础美颜");
        }
            break;
        case AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Advanced:
        {
            [self.beautyFaceDataManager_advanced saveBeautyLevel:level];
            //更新详细参数的界面
            NSArray *dics = @[[_beautyFaceDataManager_advanced SkinPolishingDic],[_beautyFaceDataManager_advanced SkinWhiteningDic],[_beautyFaceDataManager_advanced SkinShiningDic]];
            [viewController updateDetailItems:dics];
        }
            break;
        case AlivcBeautySettingViewStyle_ShortVideo_BeautySkin:
        {
            //美肌
            NSLog(@"美肌");
            [_beautySkinDataManager saveBeautyLevel:level];
            //更新详细参数的界面
            NSArray *dics = @[[_beautySkinDataManager EyeWideningDic],[_beautySkinDataManager FaceSlimmingDic]];
            [viewController updateDetailItems:dics];
        }
            break;
            
        default:
            break;
    }
    [self settingBeautyParams];
}

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeValue:(NSDictionary *)info{
    switch (viewController.currentStyle) {
        case AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Base:NSLog(@"#Wrong:基础美颜不应该有自定义效果");break;
        case AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Advanced:
        {
            //高级美颜
            [_beautyFaceDataManager_advanced saveParamWithInfo:info];
//            NSLog(@"高级美颜改变值,美白:%d,磨皮：%d，红润：%d",params.beautyWhite,params.beautyBuffing,params.beautyRuddy);
        }
            break;
        case AlivcBeautySettingViewStyle_ShortVideo_BeautySkin:
        {
            //美肌
            NSLog(@"美肌");
            [_beautySkinDataManager saveParamWithInfo:info];
        }
            break;
            
        default:
            break;
    }
    [self settingBeautyParams];
}

- (void)settingsViewController:(AlivcLiveBeautifySettingsViewController *)viewController didChangeUIStyle:(AlivcBeautySettingViewStyle)uiStyle{
    self.currentBeautyType = uiStyle;
    //设置档位
    NSInteger level = (uiStyle == AlivcBeautySettingViewStyle_ShortVideo_BeautyFace_Base ?[self.beautyFaceDataManager_normal getBeautyLevel]:[self.beautyFaceDataManager_advanced getBeautyLevel]);
    [_beatyFaceViewControl updateLevel:level];
    [_beatyFaceViewControl setUIStyle:uiStyle];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:uiStyle forKey:@"shortVideo_beautyType"];
    [defaults synchronize];
    [self settingBeautyParams];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alivcRecordBeautyDidChangeBeautyType:)]) {
        [self.delegate alivcRecordBeautyDidChangeBeautyType:uiStyle];
    }
}

- (void)settingsViewControllerDidSelectHowToGet:(AlivcLiveBeautifySettingsViewController *)viewController{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alivcRecordBeautyDidSelectedGetFaceUnityLink)]) {
        [self.delegate alivcRecordBeautyDidSelectedGetFaceUnityLink];
    }
}

- (void)dealloc {
    NSLog(@"beautyView dealloc");
}


@end
