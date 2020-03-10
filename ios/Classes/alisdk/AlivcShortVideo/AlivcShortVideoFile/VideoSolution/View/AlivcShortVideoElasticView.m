//
//  AlivcShortVideoElasticView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/16.
//  Copyright © 2019年 Alibaba. All rights reserved.
//  拍摄编辑的弹层view

#import "AlivcShortVideoElasticView.h"


static CGFloat maskButtonContainWidth = 60; //弹层button容器视图的宽
static CGFloat maskButtonContainHeight = 80; //弹层button容器视图的高

@interface AlivcShortVideoElasticView()
/**
 点击中间按钮弹出的蒙版
 */
@property (nonatomic, strong) UIView *maskView;


/**
 弹层模式下的拍摄按钮
 */
@property (nonatomic, strong) UIButton *maskShootButton;

/**
 弹层模式下的拍摄容器视图
 */
@property (nonatomic, strong) UIView *maskShootView;


/**
 弹层模式下的编辑
 */
@property (nonatomic, strong) UIButton *maskEditButton;

/**
 弹层模式下的编辑容器视图
 */
@property (nonatomic, strong) UIView *maskEditView;

@end

@implementation AlivcShortVideoElasticView

#pragma mark - Getter

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }
    return _maskView;
}

- (UIButton *)maskShootButton{
    if (!_maskShootButton) {
        _maskShootButton = [[UIButton alloc]init];
        [_maskShootButton setImage:[AlivcImage imageNamed:@"alivc_svHome_shoot"] forState:UIControlStateNormal];
        [_maskShootButton setImage:[AlivcImage imageNamed:@"alivc_svHome_shoot"] forState:UIControlStateSelected];
        [_maskShootButton addTarget:self action:@selector(maskShoot:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskShootButton;
}

- (UIView *)maskShootView{
    if (!_maskShootView) {
        
        _maskShootView = [[UIView alloc]init];
        _maskShootView.frame = CGRectMake(0, 0, maskButtonContainWidth, maskButtonContainHeight);
        UILabel *label = [[UILabel alloc]init];
        label.text = NSLocalizedString(@"视频拍摄", nil);
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.font = [UIFont systemFontOfSize:15];
        [_maskShootView addSubview:label];
        label.center = CGPointMake(maskButtonContainWidth/2, 4 + label.frame.size.height / 2);
        
        [_maskShootView addSubview:self.maskShootButton];
        self.maskShootButton.frame = CGRectMake(0, 0, maskButtonContainWidth, maskButtonContainHeight);
        self.maskShootButton.imageEdgeInsets = UIEdgeInsetsMake(label.frame.size.height + 8, 0, 0, 0);
    }
    return _maskShootView;
}


- (UIButton *)maskEditButton{
    if (!_maskEditButton) {
        _maskEditButton = [[UIButton alloc]init];
        [_maskEditButton setImage:[AlivcImage imageNamed:@"alivc_svHome_edit"] forState:UIControlStateNormal];
        [_maskEditButton setImage:[AlivcImage imageNamed:@"alivc_svHome_edit"] forState:UIControlStateSelected];
        [_maskEditButton addTarget:self action:@selector(maskEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskEditButton;
}

- (UIView *)maskEditView{
    if (!_maskEditView) {
        
        _maskEditView = [[UIView alloc]init];
        _maskEditView.frame = CGRectMake(0, 0, maskButtonContainWidth, maskButtonContainHeight);
        UILabel *label = [[UILabel alloc]init];
        label.text = NSLocalizedString(@"视频编辑", nil);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        [_maskEditView addSubview:label];
        label.center = CGPointMake(maskButtonContainWidth/2, 4 + label.frame.size.height / 2);
        
        [_maskEditView addSubview:self.maskEditButton];
        self.maskEditButton.frame = CGRectMake(0, 0, maskButtonContainWidth, maskButtonContainHeight);
        self.maskEditButton.imageEdgeInsets = UIEdgeInsetsMake(label.frame.size.height + 8, 0, 0, 0);
    }
    return _maskEditView;
}


#pragma mark -  init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 拍摄视频
 */
- (void)maskShoot:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoElasticView:shootButtonTouched:)]) {
        [self.delegate shortVideoElasticView:self shootButtonTouched:button];
    }
}


/**
 编辑视频
 */
- (void)maskEdit:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoElasticView:editButtonTouched:)]) {
        [self.delegate shortVideoElasticView:self editButtonTouched:button];
    }
}


#pragma mark - UIChange
/**
 进入弹层状态，拍摄还是编辑
 */
-(void)enterShootOrEdit{
    

    
    [self addSubview:self.maskView];
    CGPoint mainCenter = CGPointMake(ScreenWidth / 2, ScreenHeight - 30);
    
    CGFloat beside = 16; //按钮右边距距离中心的距离;
    
    //记录目标大小
    CGRect targetShootFrame = CGRectMake(0, 0, maskButtonContainWidth, maskButtonContainHeight);
    CGFloat targetY = mainCenter.y - 42 - targetShootFrame.size.height - SafeAreaBottom;
    targetShootFrame.origin = CGPointMake(ScreenWidth / 2 - beside - targetShootFrame.size.width, targetY);
    
    CGRect targetEditFrame = CGRectMake(0, 0, maskButtonContainWidth, maskButtonContainWidth);
    targetEditFrame.origin = CGPointMake(ScreenWidth / 2 + beside, targetY);
    
    //设置初始状态
    self.maskShootView.frame = CGRectMake(0, 0, 1, 1);
    self.maskShootView.center = mainCenter;
    
    self.maskEditView.frame = CGRectMake(0, 0, 1, 1);
    self.maskEditView.center = mainCenter;
    
    [self.maskView addSubview:self.maskShootView];
    [self.maskView addSubview:self.maskEditView];
    self.maskView.alpha = 0;
    
    [UIView animateWithDuration:0.26 animations:^{
        self.maskShootView.frame = targetShootFrame;
        self.maskEditView.frame = targetEditFrame;
        self.maskView.alpha = 1;
    } completion:^(BOOL finished) {
        //        if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoMaskView:homeButtonTouched:)]) {
        //            [self.delegate shortVideoMaskView:self homeButtonTouched:self.homeButton];
        //        }
    }];
    
}

/**
 退出弹层状态，
 */
- (void)quitShootOrEdit{
    
    CGPoint mainCenter = CGPointMake(ScreenWidth / 2, ScreenHeight - 30);
    CGRect targetFrame = CGRectMake(mainCenter.x, mainCenter.y, 1, 1);
    
    [UIView animateWithDuration:0.26 animations:^{
        self.maskShootView.frame = targetFrame;
        self.maskEditView.frame = targetFrame;
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.maskShootView removeFromSuperview];
            [self.maskEditView removeFromSuperview];
            [self.maskView removeFromSuperview];
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoMaskView:homeButtonTouched:)]) {
            //                [self.delegate shortVideoMaskView:self homeButtonTouched:self.homeButton];
            //            }
        }
    }];
}


- (void)enterEditStatus:(BOOL)editStatus inView:(UIView *)containView{
    
    if (editStatus) {
        [containView addSubview:self];
        [self enterShootOrEdit];
    }else{
        [self quitShootOrEdit];
        [self removeFromSuperview];
    }
}
@end
