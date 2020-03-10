//
//  AlivcShortVideoProgress.m
//  AliyunVideoClient_Entrance
//
//  Created by wanghao on 2018/12/11.
//  Copyright © 2018年 wanghao. All rights reserved.
//

#import "AlivcShortVideoProgress.h"
#import "UIColor+AlivcHelper.h"



//ProgressView宽度与当前设备宽度比
#define AlivcShortVideoProgressViewWidthRatio  0.66
//ProgressView宽高比
#define AlivcShortVideoProgressViewWidthHeightRatio 0.76
//进度圆环的大小与ProgressView的高度比
#define AlivcShortVideoProgressViewRoundSizeRatio 0.46
//dismissBtn与contentView的高度比
#define AlivcShortVideoProgressDismissBtnSizeRatio 0.22



@interface AlivcShortVideoProgress()

//进度条Layer
@property(nonatomic, strong)CAShapeLayer *progressLayer;
//进度显示lab
@property(nonatomic, strong)UILabel *textLab;
//主要内容显示view
@property(nonatomic, strong)UIView *contentView;
//关闭按钮
@property(nonatomic, strong)UIButton *dismissBtn;
//背景禁止点击遮罩View
@property(nonatomic, strong)UIView *hudView;

@end

@implementation AlivcShortVideoProgress

-(id)init{
    //根据设备屏幕尺寸自适应大小
    CGFloat frame_w = ScreenWidth * AlivcShortVideoProgressViewWidthRatio;
    CGFloat frame_y = [UIApplication sharedApplication].keyWindow.center.y -70;
    self =[super initWithFrame:CGRectMake((ScreenWidth-frame_w)/2, frame_y, frame_w, frame_w * AlivcShortVideoProgressViewWidthHeightRatio)];
    if (self) {
        //默认值设置
        _roundWidth = 4;
        _progressValue =0;
        self.backgroundColor =[UIColor clearColor];
        _roundBackgroundColor =[UIColor colorWithHexString:@"#979797"];
        _roundProgressColor =[UIColor colorWithHexString:@"#ffffff"];
        [self drawSubviews];
    }
    return self;
}

-(void)drawSubviews{
    _contentView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)- 45)];
    _contentView.backgroundColor =[UIColor colorWithHexString:@"#373D41" alpha:0.5];
    _contentView.layer.cornerRadius = 4;
    [self addSubview:_contentView];
    
    
    _textLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentView.frame)/3, 40)];
    _textLab.text = @"";
    _textLab.textColor =[UIColor whiteColor];
    _textLab.textAlignment =NSTextAlignmentCenter;
    _textLab.font =[UIFont systemFontOfSize:16];
    [_contentView addSubview:_textLab];
    _textLab.center = CGPointMake(CGRectGetWidth(_contentView.frame)/2, CGRectGetHeight(_contentView.frame)/2);
    [self drawRoundLayer];
    
    CGFloat frame_w =CGRectGetHeight(_contentView.frame)*AlivcShortVideoProgressDismissBtnSizeRatio;
    _dismissBtn =[[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - frame_w)/2, CGRectGetMaxY(_contentView.frame)+10, frame_w, frame_w)];
    _dismissBtn.layer.cornerRadius = frame_w/2;
    [_dismissBtn setImage:[AlivcImage imageNamed:@"shortVideo_solution_close"] forState:UIControlStateNormal];
    [_dismissBtn addTarget:self action:@selector(dismissBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dismissBtn];
}

//画圆
-(void)drawRoundLayer{
    CGFloat radius = (CGRectGetHeight(_contentView.frame)*AlivcShortVideoProgressViewRoundSizeRatio)/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(_contentView.frame)/2, CGRectGetHeight(_contentView.frame)/2) radius:radius startAngle:-M_PI_2 endAngle:(M_PI*2 - M_PI_2) clockwise:YES];
    //背景圆环
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.path = path.CGPath;
    bgLayer.strokeColor =_roundBackgroundColor.CGColor;
    bgLayer.lineWidth = _roundWidth;
    bgLayer.fillColor = [UIColor clearColor].CGColor;
    [_contentView.layer insertSublayer:bgLayer atIndex:0];
    //进度条圆环
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.path = path.CGPath;
    _progressLayer.strokeColor =_roundProgressColor.CGColor;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0.0;
    _progressLayer.lineWidth = _roundWidth;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    //加动画
    //    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //    pathAnima.duration = 0.2f;
    //    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    pathAnima.fillMode = kCAFillModeForwards;
    //    pathAnima.removedOnCompletion = NO;
    //    [_progressLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    [_contentView.layer insertSublayer:_progressLayer above:bgLayer];
}
//刷新进度值
-(void)refreshProgress:(int)progress{
    _progressValue = progress;
    [_textLab setText:[NSString stringWithFormat:@"%d%%",progress]];
    self.progressLayer.strokeEnd = (float)progress/100;
}

-(void)showInView:(UIView *)superView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [superView addSubview:self];
        [superView addSubview:self.hudView];
        [superView bringSubviewToFront:self];
    });
}
-(void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshProgress:0];
        [self.hudView removeFromSuperview];
        [self removeFromSuperview];
    });
}

- (void)dismissBtnTouched:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shortVideoProgressView:dismissButtonTouched:)]) {
        [self.delegate shortVideoProgressView:self dismissButtonTouched:button];
    }
}



-(UIView *)hudView{
    if (!_hudView) {
        _hudView =[[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    }
    return _hudView;
}


+ (AlivcShortVideoProgress *)showInView:(UIView *)view delegate:(id <AlivcShortVideoProgressDelegate>)delegate; {
    AlivcShortVideoProgress *progressView = [self progressForView:view];
    if (progressView) {
        progressView.delegate = delegate;
        return progressView;
    }else{
        AlivcShortVideoProgress *progressView_s =[[AlivcShortVideoProgress alloc]init];
        [progressView_s showInView:view];
        progressView_s.delegate = delegate;
        return progressView_s;
    }
}

+ (BOOL)hideProgressForView:(UIView *)view{
    AlivcShortVideoProgress *progressView = [self progressForView:view];
    if (progressView != nil) {
        [progressView performSelector:@selector(hide) withObject:nil afterDelay:0.2];
        return YES;
    }
    return NO;
}
+ (void)refreshProgress:(int)progress inView:(UIView *)view{
    AlivcShortVideoProgress *progressView = [self progressForView:view];
    [progressView refreshProgress:progress];
}

+ (AlivcShortVideoProgress *)progressForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (AlivcShortVideoProgress *)subview;
        }
    }
    return nil;
}


@end
