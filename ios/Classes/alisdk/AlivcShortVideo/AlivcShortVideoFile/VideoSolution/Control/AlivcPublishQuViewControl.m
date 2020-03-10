//
//  AlivcPublishViewControlViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/12/26.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcPublishQuViewControl.h"
#import <AliyunVideoSDKPro/AliyunPublishManager.h>
#import "AVC_ShortVideo_Config.h"
#import "AlivcQuVideoServerManager.h"
#import "AliVideoClientUser.h"
#import "MBProgressHUD+AlivcHelper.h"
#import "AlivcShortVideoPublishManager.h"
#import "AlivcDefine.h"
#import "AliyunMediaConfig.h"


@interface AlivcPublishQuViewControl () <UITextFieldDelegate>

//返回按钮
@property(nonatomic, strong) UIButton *backButton;

//发布按钮
@property(nonatomic, strong) UIButton *publishButton;
//baan-重拍按钮
@property(nonatomic, strong) UIButton *retryButton;

//视频描述
@property(nonatomic, strong) UITextField *titleView;


//总的容器视图
@property(nonatomic, strong) UIView *containerView;

//播放相关
@property(nonatomic, strong) UIView *movieView;
@property(nonatomic, strong) UIImageView *coverImageView;
@property(nonatomic, assign) CGRect originFrame;

//编辑播放器
@property(nonatomic, strong) AliyunEditor *editor;
@property(nonatomic, strong) id<AliyunIPlayer> player;
@property(nonatomic, assign) BOOL isPlaying; //是否在播放中

@property(nonatomic, assign) CGRect playFrame; //播放frame

@property (nonatomic, strong) UIView *lineView;

@end

@implementation AlivcPublishQuViewControl

#pragma mark - System & Init
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configBaseUI];
    [self addNotification];
    [self initSDKAbout];
    
    //baan-隐藏textfield
    self.titleView.hidden = true;
    self.titleView.userInteractionEnabled = false;
    self.lineView.hidden = true;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)dealloc{
    [self.editor stopEdit];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**
 初始化播放资源 - 默认先隐藏起来
 */
- (void)initSDKAbout {
    
    // editor
    self.editor = [[AliyunEditor alloc] initWithPath:_taskPath
                                             preview:self.movieView];
    self.editor.delegate = (id)self;
    // player
    self.player = [self.editor getPlayer];
    
    [self.editor startEdit];
    
    self.movieView.frame = self.originFrame;
    
    _isPlaying = NO;
    
    [self.player stop];
}

- (void)startPlay{
    int returnValue = [self.player play];
    NSLog(@"短视频编辑播放器测试:调用了play接口");
    if (returnValue == 0) {
        NSLog(@"短视频编辑播放器测试:play返回0成功");
    }
}


- (void)addNotification{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)note {
    CGRect end = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration =
    [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat containerHeight = StatusBarHeight + 44 + ScreenWidth + 52 + 22;
    
    CGFloat offset = ScreenHeight - CGRectGetHeight(end) - containerHeight;
    if (offset < 0) {
        [UIView animateWithDuration:duration
                         animations:^{
                             _containerView.frame =
                             CGRectMake(0, offset, ScreenWidth, ScreenHeight);
                         }];
    }
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGFloat duration =
    [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                     animations:^{
                         _containerView.frame =
                         CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                     }];
}


#pragma mark - Getter

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"avcBackIcon"]
                     forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"avcBackIcon"]
                     forState:UIControlStateSelected];
        [_backButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateSelected];
        [_backButton setBackgroundColor:[UIColor clearColor]];
        [_backButton addTarget:self
                        action:@selector(back)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishButton.backgroundColor = [UIColor colorWithHexString:@"FC4347"];
        CGFloat width = 60;
        CGFloat height = 28;
        _publishButton.frame = CGRectMake(0, 0, width, height);
        [_publishButton setTitle:NSLocalizedString(@"发布" , nil) forState:UIControlStateNormal];
        _publishButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _publishButton.layer.cornerRadius =  2;
        _publishButton.clipsToBounds = YES;
        [_publishButton addTarget:self
                           action:@selector(publish)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishButton;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryButton.backgroundColor = [UIColor colorWithHexString:@"FC4347"];
        CGFloat width = 60;
        CGFloat height = 28;
        _retryButton.frame = CGRectMake(0, 0, width, height);
        [_retryButton setTitle:NSLocalizedString(@"重拍" , nil) forState:UIControlStateNormal];
        _retryButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _retryButton.layer.cornerRadius =  2;
        _retryButton.clipsToBounds = YES;
        [_retryButton addTarget:self
                           action:@selector(retry)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}


- (void)configBaseUI {
    self.containerView = [[UIView alloc]
                          initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.containerView];
    
    //top
    [self.view addSubview:self.backButton];
    CGFloat centerY = SafeTop + 8;
    if (IS_IPHONEX) {
        centerY = SafeTop + 26;
    }
    [self.backButton sizeToFit];
    self.backButton.center = CGPointMake(20, centerY + 22);
    
    [self.view addSubview:self.publishButton];
    self.publishButton.center =
    CGPointMake(ScreenWidth - 8 - self.publishButton.frame.size.width / 2,
                self.backButton.center.y);
    
    [self.view addSubview:self.retryButton];
    self.retryButton.center =
    CGPointMake(self.publishButton.frame.size.width / 2 + 8,
                self.backButton.center.y);
    
    //imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageWidth = ScreenWidth / 5 * 3;
    CGFloat imageHeight = 0;
    if (self.coverImage) {
        imageHeight =
        imageWidth * (self.coverImage.size.height / self.coverImage.size.width);
    }
    if (imageHeight > ScreenHeight / 5 * 3) {
        imageHeight = ScreenHeight / 5 * 3;
    }
    imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    self.movieView = [[UIView alloc]initWithFrame:imageView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.coverImage;
    [self.containerView addSubview:self.movieView];
    [self.movieView addSubview:imageView];
    self.movieView.center = CGPointMake(ScreenWidth / 2,CGRectGetMaxY(self.backButton.frame) + 8 + imageHeight / 2);
    self.originFrame = self.movieView.frame;
    self.playFrame = CGRectMake(0, 0, ScreenWidth,  ScreenWidth * _config.outputSize.height / _config.outputSize.width);
    
    //tap Gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tap)];
    [self.movieView addGestureRecognizer:tap];
    self.coverImageView = imageView;
    
    // bottom
    self.titleView = [[UITextField alloc]
                      initWithFrame:CGRectMake(20, CGRectGetMaxY(self.movieView.frame) + 16,
                                               ScreenWidth - 40, 36)];
    self.titleView.attributedPlaceholder = [[NSAttributedString alloc]
                                            initWithString:NSLocalizedString(@"添加视频描述20字以内" , nil)
                                            attributes:@{
                                                         NSForegroundColorAttributeName : rgba(188, 190, 197, 1)
                                                         }];
    self.titleView.tintColor = [AliyunIConfig config].timelineTintColor;
    ;
    self.titleView.textColor = [UIColor whiteColor];
    [self.titleView setFont:[UIFont systemFontOfSize:14]];
    self.titleView.returnKeyType = UIReturnKeyDone;
    self.titleView.delegate = self;
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.titleView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleView.frame),
                                             ScreenWidth - 40, 1)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"00C1DE"];
    [self.containerView addSubview:_lineView];
    
    [self.containerView bringSubviewToFront:self.movieView];
    
    
}

#pragma mark - Action
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//发布
- (void)publish {
    AliyunUploadSVideoInfo *info = [AliyunUploadSVideoInfo new];
//    info.desc = self.titleView.text;
//    if (info.desc) {
//        NSInteger charLen = info.desc.length;
//        if (charLen > 19) {
//            [MBProgressHUD showMessage:NSLocalizedString(@"视频描述过长,应小于20个字符" , nil) inView:self.view];
//            return;
//        }
//    }
    
    [[AlivcShortVideoPublishManager shared] setVideoPath:self.taskPath
                                             videoConfig:self.config];
    [[AlivcShortVideoPublishManager shared] setCoverImag:self.coverImage
                                               videoInfo:info];
    AlivcShortVideoPublishManager *manager = [AlivcShortVideoPublishManager shared];
//    manager.mixVideoPath = [NSString stringWithFormat:@"%@.mp4", self.taskPath];
    manager.mixVideoPath = self.videoPath;
    [self.navigationController popToRootViewControllerAnimated:false];
//    [self popToPlayVC];
}


//重拍
- (void)retry {
    [self.navigationController popToRootViewControllerAnimated:false];
}

- (void)popToPlayVC{

    Class viewControllerClass = NSClassFromString(@"AlivcShortVideoQuHomeTabBarController");
    BOOL haveFind = NO;
    if (viewControllerClass) {
        for (UIViewController *itemVC in self.navigationController.viewControllers) {
            NSString *classString = NSStringFromClass([itemVC class]);
            if ([classString isEqualToString:@"AlivcShortVideoQuHomeTabBarController"]) {
                [self.navigationController popToViewController:itemVC animated:YES];
                //派发通知
                haveFind = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationVideoStartPublish object:nil];
                break;
            }
        }
    }
    if (!haveFind) {
        [MBProgressHUD showMessage:NSLocalizedString(@"请从趣视频入口，点击中间圆圈按钮进入编辑模块" , nil) inView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *targetVC = [[viewControllerClass alloc]init];
            [self.navigationController pushViewController:targetVC animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationVideoStartPublish object:nil];
        });
    }
}

- (void)tap{
    if (_isPlaying == YES) {
        [self backToOriginalStatus];
    }else{
        [self enterPalyStatus];
    }
}

#pragma mark - Private Method

static CGFloat knimationTime = 0.6;
/**
 进入播放模式
 */
- (void)enterPalyStatus{
    [self someViewHide:YES];
    //动画
    CGRect targetFrame = self.playFrame;
    
    [UIView animateWithDuration:knimationTime animations:^{
        self.movieView.frame = targetFrame;
        self.coverImageView.frame = self.movieView.bounds;
//        if (targetFrame.size.width > targetFrame.size.height || targetFrame.size.width == targetFrame.size.height) {
            self.movieView.center = self.view.center;
//        }
    } completion:^(BOOL finished) {
        self.coverImageView.hidden = YES;
                //开始播放
        [self startPlay];
        _isPlaying = YES;
    }];
}

/**
 返回编辑视频描述的模式
 */
- (void)backToOriginalStatus{
    //停止播放
    [self.player stop];
    _isPlaying = NO;
    [self someViewHide:NO];
    //动画
    [UIView animateWithDuration:knimationTime animations:^{
        self.movieView.frame = self.originFrame;
        self.coverImageView.frame = self.movieView.bounds;
    } completion:^(BOOL finished) {
        
        self.coverImageView.hidden = NO;
        self.movieView.backgroundColor = [UIColor clearColor];
        
    }];
}

- (void)someViewHide:(BOOL)isHide{
    
    self.publishButton.hidden = isHide;
    self.backButton.hidden = isHide;
    self.titleView.hidden = isHide;
    self.lineView.hidden = isHide;
    self.retryButton.hidden = isHide;

}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@", textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSLog(@"%@", textField.text);
    return YES;
}


#pragma mark - AliyunIPlayerCallback

- (void)playerDidStart {
    NSLog(@"play start");
}

- (void)playerDidEnd {
    NSLog(@"pplayer DidEnd");
    [self.player replay];
}

/**
 播放进度
 
 @param playSec 播放时间
 @param streamSec 播放流时间
 */
- (void)playProgress:(double)playSec streamProgress:(double)streamSec{
    CGFloat pro = playSec / streamSec;
    NSLog(@"发布界面播放进度%.2f",pro);
}
/**
 播放异常
 
 @param errorCode 错误码
 状态错误 ALIVC_FRAMEWORK_MEDIA_POOL_WRONG_STATE
 DEMUXER重复创建 ALIVC_FRAMEWORK_DEMUXER_INIT_MULTI_TIMES
 DEMUXER打开失败 ALIVC_FRAMEWORK_DEMUXER_OPEN_FILE_FAILED
 DEMUXER获取流信息失败 ALIVC_FRAMEWORK_DEMUXER_FIND_STREAM_INFO_FAILED
 解码器创建失败 ALIVC_FRAMEWORK_AUDIO_DECODER_CREATE_DECODER_FAILED
 解码器状态错误 ALIVC_FRAMEWORK_AUDIO_DECODER_ERROR_STATE
 解码器输入错误 ALIVC_FRAMEWORK_AUDIO_DECODER_ERROR_INPUT
 解码器参数SPSPPS为空 ALIVC_FRAMEWORK_VIDEO_DECODER_SPS_PPS_NULL,
 解码H264参数创建失败 ALIVC_FRAMEWORK_VIDEO_DECODER_CREATE_H264_PARAM_SET_FAILED
 解码HEVC参数创建失败 ALIVC_FRAMEWORK_VIDEO_DECODER_CREATE_HEVC_PARAM_SET_FAILED
 缓存数据已满 ALIVC_FRAMEWORK_MEDIA_POOL_CACHE_DATA_SIZE_OVERFLOW
 解码器内部返回错误码
 */
- (void)playError:(int)errorCode{
    NSLog(@"发布界面播放错误%ld",(long)errorCode);
}

#pragma mark - Notification
- (void)applicationDidBecomeActive {
    
    if (_isPlaying) {
        [self.player play];
    }else{
        //因为SDK的bug，这边延时调用stop
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player stop];
        });
        
    }
}

- (void)applicationWillResignActive {
    if (_isPlaying) {
        //SDK内部自己会处理
    }
}
@end
