//
//  AlivcShortVideoMenuView.m
//  AliyunVideoClient_Entrance
//
//  Created by wanghao on 2018/12/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoMenuView.h"
#import "UIView+AlivcHelper.h"

#define CPV_LineView_Height     1   //分割线高度


@interface AlivcShortVideoMenuView()

@property(nonatomic, assign, readonly)CGRect initFrame;//初始化的frame，动画隐藏view后再显示的时候需要用到
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UIView *bottomView;
@property(nonatomic, strong)UIView *topLine;        //上方分割线
@property(nonatomic, strong)UIView *contentView;    //中间内容View
@property(nonatomic, strong)UIView *headerView;     //顶部View

@property(nonatomic, strong)UIButton *downloadBtn;
@property(nonatomic, strong)UIButton *deleteBtn;
@end

@implementation AlivcShortVideoMenuView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews{
//    [self addVisualEffect];
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.headerView];
    [self.bottomView addSubview:self.topLine];
    [self.bottomView addSubview:self.contentView];
    [self.contentView addSubview:self.downloadBtn];
    
//    self.downloadBtn.center = self.contentView.center;
    
}

#pragma mark - Functions

-(void)showInView:(UIView *)superView animation:(BOOL)animation completion:(void (^ _Nullable)(BOOL))completion{
    [self removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window) {
        [window addSubview:self];
    }else{
        [superView addSubview:self];
    }
    __weak typeof(self)weakSelf = self;
    self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, ScreenHeight, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = _initFrame;
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }else{
        self.bottomView.frame = _initFrame;
    }
}

-(void)hiddenAnimation:(BOOL)animation completion:(void (^ _Nullable)(BOOL))completion{
    __weak typeof(self)weakSelf = self;
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, ScreenHeight, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
            [weakSelf removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

- (void)addDeleteButton{
    [self.contentView addSubview:self.deleteBtn];
    CGFloat cy = self.contentView.frame.size.height / 2;
    CGFloat cdonx = self.contentView.frame.size.width / 4 * 1;
    CGFloat cdelx = self.contentView.frame.size.width / 4 * 3;
    self.downloadBtn.center = CGPointMake(cdonx, cy);
    self.deleteBtn.center = CGPointMake(cdelx, cy);
    
    self.deleteBtn.hidden = NO;
}

- (void)hideDeleteButton{
    self.deleteBtn.hidden = YES;
    self.downloadBtn.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2);
}


#pragma mark - GET

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLine.frame), CGRectGetWidth(self.bottomView.frame), CGRectGetHeight(self.bottomView.bounds) - CGRectGetHeight(self.topLine.bounds) - CGRectGetHeight(self.headerView.bounds))];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        _headerView.backgroundColor =[UIColor clearColor];
        [_headerView addSubview:self.cancelBtn];
        [_headerView addSubview:self.titleLab];
    }
    return _headerView;
}

-(UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.bottomView.frame), CPV_LineView_Height)];
        _topLine.backgroundColor = AlivcOxRGBA(0xc3c5c6,0.5);
    }
    return _topLine;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.headerView.frame), CGRectGetHeight(self.headerView.frame))];
        [_cancelBtn setImage:[AlivcImage imageNamed:@"shortVideo_edit_close"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab =[[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.headerView.bounds)-150)/2, 0, 150, CGRectGetHeight(self.headerView.bounds))];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor =[UIColor whiteColor];
        _titleLab.text = NSLocalizedString(@"分享到" , nil);
    }
    return _titleLab;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _initFrame = CGRectMake(0, CGRectGetHeight(self.bounds)-200, ScreenWidth, 200);
        _bottomView =[[UIView alloc]initWithFrame:_initFrame];
        [_bottomView addVisualEffect];
    }
    return _bottomView;
}

-(UIButton *)downloadBtn{
    if (!_downloadBtn) {
        _downloadBtn =[[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)-48)/2, (CGRectGetHeight(self.contentView.frame)-48)/2, 48, 48)];
        [_downloadBtn setTitle:NSLocalizedString(@"保存本地" , nil) forState:UIControlStateNormal];
        _downloadBtn.titleLabel.font =[UIFont systemFontOfSize:10];
        [_downloadBtn setTitleEdgeInsets:UIEdgeInsetsMake(60, -48, 0, 0)];
        [_downloadBtn setImage:[AlivcImage imageNamed:@"shortVideo_solution_download"] forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downloadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn =[[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.contentView.frame)-48)/2, (CGRectGetHeight(self.contentView.frame)-48)/2, 48, 48)];
        [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font =[UIFont systemFontOfSize:10];
        [_deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(60, -48, 0, 0)];
        [_deleteBtn setImage:[AlivcImage imageNamed:@"shortVideo_solution_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

-(void)btnAction:(UIButton *)btn{
    __weak typeof(self)weakSelf = self;
    [self hiddenAnimation:YES completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

-(void)downloadBtnAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alivcShortVideoMenuViewDownloadAction)]) {
        [self.delegate alivcShortVideoMenuViewDownloadAction];
    }
    [self btnAction:nil];
}

-(void)deleteBtnAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alivcShortVideoMenuViewDeleteAction)]) {
        [self.delegate alivcShortVideoMenuViewDeleteAction];
    }
    [self btnAction:nil];
}

@end
