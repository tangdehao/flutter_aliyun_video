//
//  AlivcShortVideoPersonalViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2019/1/8.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "AlivcShortVideoPersonalViewController.h"


#import "AlivcQuVideoModel.h"
#import "MBProgressHUD+AlivcHelper.h"

#import "AlivcShortVideoCCell.h"
#import "AlivcQuHeaderReusableView.h"

#import "AliVideoClientUser.h"

#import "AlivcQuVideoServerManager.h"

#import "AlivcAlertView.h"

#import "NSString+AlivcHelper.h"

#import "AlivcShortVideoElasticView.h"

#import "AlivcShortVideoRoute.h"

#import "AlivcShortVideoTabBar.h"

#import "AlivcUserInfoViewController.h"

#import "AlivcDefine.h"

#import "AlivcShortVideoPublishManager.h"

#import "AliyunReachability.h"

#import <MJRefresh/MJRefresh.h>

#import "AlivcShortVideoPlayViewController.h"

static NSInteger kPageCountPerQuerry = 9;//每次请求查询的个数

@interface AlivcShortVideoPersonalViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate,AlivcShortVideoElasticViewDelegate,AlivcQuHeaderReusableViewDelegate>

/**
 列表视图
 */
@property (strong, nonatomic) UICollectionView *collectionView;

/**
 头部视图
 */
@property (strong, nonatomic) AlivcQuHeaderReusableView *headerView;

/**
 播放数据源列表
 */
@property (nonatomic, strong) NSMutableArray <AlivcQuVideoModel *>*videoList;

/**
 临时存储要删除的视频
 */
@property (nonatomic, strong) AlivcQuVideoModel *shouldDeleteModel;

/**
 渐变图层
 */
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

/**
 弹层视图
 */
@property (nonatomic, strong) AlivcShortVideoElasticView *elasticView;

/**
 下拉刷新
 */
@property (nonatomic, strong) UIRefreshControl *refreshControl;

/**
 设置按钮
 */
@property (nonatomic, strong) UIButton *settingButton;

/**
 网络监听
 */
@property (nonatomic, strong) AliyunReachability *reachability;


@end

static NSString *kCellIdentifier = @"AlivcShortVideoPersonalIdentifier";
static NSString *kHeaderIndetifier = @"AlivcQuHeaderReusableView";
static CGFloat device = 8;//间距
static CGFloat beside = 16; //边距
static CGFloat kHeaderHeight = 320; //头部视图总的高度 要和xib对应起来
static CGFloat kHeaderUserHeitht = 260; //头部视图个人信息的高度 要和xib对应起来

@implementation AlivcShortVideoPersonalViewController

#pragma mark - Getter
- (AlivcShortVideoElasticView *)elasticView{
    if (!_elasticView) {
        _elasticView = [[AlivcShortVideoElasticView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _elasticView.delegate = self;
    }
    return _elasticView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        CGRect frame = CGRectMake(beside, 0, ScreenWidth - beside * 2, ScreenHeight);
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:[self alivcFlowLayoutWithCollectionViewWidth:frame.size.width]];
        [_collectionView registerClass:[AlivcShortVideoCCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        //headerView
        [_collectionView registerNib:[UINib nibWithNibName:@"AlivcQuHeaderReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIndetifier];
        //下拉刷新
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
        [_collectionView addSubview:_refreshControl];
        //上拉加载
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _collectionView;
}

/**
 布局定义

 @return 一行3个排列的瀑布流布局
 */
- (UICollectionViewFlowLayout *)alivcFlowLayoutWithCollectionViewWidth:(CGFloat )width{
    
    CGFloat itemWidth = (width - device * 2) / 3;
    CGFloat itemHeight = itemWidth / 9 * 16;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = device;
    layout.minimumInteritemSpacing = device;
    layout.sectionHeadersPinToVisibleBounds = NO;
    return layout;
}

/**
 渐变色定义

 @return 渐变色
 */
- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.headerView.myVideoView.bounds;
        layer.startPoint = CGPointMake(0, 1);
        layer.endPoint = CGPointMake(1, 1);
        UIColor *leftColor = [UIColor colorWithRed:53/255.0 green:29/255.0 blue:105/255.0 alpha:1];
        UIColor *rightColor = [UIColor colorWithRed:28/255.0 green:33/255.0 blue:44/255.0 alpha:1];
        layer.colors = @[(__bridge id)leftColor.CGColor,(__bridge id)rightColor.CGColor];
        layer.locations = @[@(0.5f),@(1.0f)];
        _gradientLayer = layer;
    }
    return _gradientLayer;
    
}


#pragma mark - System Method & Init Method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.headerView) {
        [self configHeaderView:self.headerView user:[AliVideoClientUser shared]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.headerView && self.headerView.myVideoView.superview != self.view) {
        //第一次进来修正下视图
        [self.headerView fixSize];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoHaveDeleted:) name:AlivcNotificationDeleveVideoSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterMask) name:AlivcNotificationQuPlay_EnterMask object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitMask) name:AlivcNotificationQuPlay_QutiMask object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUserSuccess) name:AlivcNotificationChangeUserSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishSuccess) name:AlivcNotificationVideoPublishSuccess object:nil];
    self.reachability = [AliyunReachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged)
                                                 name:AliyunPVReachabilityChangedNotification
                                               object:nil];
}

- (void)configBaseData{
    [self.collectionView.mj_footer resetNoMoreData];
    //先查询kPageCountPerQuerry条
    [AlivcQuVideoServerManager quServerGetPersonalVideoListWithToken:[AliVideoClientUser shared].token pageIndex:1 pageSize:kPageCountPerQuerry lastEndVideoId:nil success:^(NSArray<AlivcQuVideoModel *> * _Nonnull videoList,NSInteger allVideoCount) {
        if (_refreshControl) {
            [_refreshControl endRefreshing];
        }
        if (videoList) {
            self.videoList = [[NSMutableArray alloc]initWithArray:videoList];
        }else{
            self.videoList = [[NSMutableArray alloc]init];
        }
        [self.collectionView reloadData];
        self.headerView.myVideoCountLabel.text = [NSString stringWithFormat:@"%ld",(long)allVideoCount];
        
    } failure:^(NSString * _Nonnull errorString) {
        //
        if (_refreshControl) {
            [_refreshControl endRefreshing];
        }
        [MBProgressHUD showMessage:errorString inView:self.view];
    }];
}

- (void)loadMoreData{
    NSLog(@"加载更多的数据");
    AlivcQuVideoModel *lastModel = self.videoList.lastObject;
    if (lastModel.ID) {
        [AlivcQuVideoServerManager quServerGetPersonalVideoListWithToken:[AliVideoClientUser shared].token pageIndex:1 pageSize:kPageCountPerQuerry lastEndVideoId:lastModel.ID success:^(NSArray<AlivcQuVideoModel *> * _Nonnull videoList,NSInteger allVideoCount) {
            if (videoList.count < kPageCountPerQuerry) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_footer endRefreshing];
            }
            
            if (videoList.count) {
                [self.videoList addObjectsFromArray:videoList];
                [self.collectionView reloadData];
                self.headerView.myVideoCountLabel.text = [NSString stringWithFormat:@"%ld",(long)allVideoCount];
            }
        } failure:^(NSString * _Nonnull errorString) {
            //
            [self.collectionView.mj_footer endRefreshing];
            [MBProgressHUD showMessage:errorString inView:self.view];
        }];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }
   
}



- (void)configBaseUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[self.view bounds]];
    imageView.image = [AlivcImage imageNamed:@"alivc_shortVideo_myVideo_bg"];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[AlivcImage imageNamed:@"alivc_quVideo_setting"] forState:UIControlStateNormal];
    [settingButton setImage:[AlivcImage imageNamed:@"alivc_quVideo_setting"] forState:UIControlStateSelected];
    [settingButton sizeToFit];
    settingButton.center = CGPointMake(ScreenWidth - 12 - settingButton.frame.size.width / 2, SafeTop + 22);
    [settingButton addTarget:self action:@selector(settingButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    self.settingButton = settingButton;
}

#pragma mark - Method Define
- (void)addMyVideoViewToSelfView{
    if (self.headerView.myVideoView.superview != self.view) {
        [self.headerView.myVideoView removeFromSuperview];
        CGRect frame = self.headerView.myVideoView.frame;
        frame.origin.y = 0;
        frame.origin.x = beside;
        self.headerView.myVideoView.frame = frame;
        [self.view addSubview:self.headerView.myVideoView];
        
        UIView *bgView = [[UIView alloc]initWithFrame:self.headerView.myVideoBgView.bounds];
        [bgView.layer addSublayer:self.gradientLayer];
        [self.headerView.myVideoBgView addSubview:bgView];
        [self.headerView.myVideoBgView sendSubviewToBack:bgView];
        //            [self.headerView.myVideoView layoutSubviews];
    }
}

- (void)addMyVideoViewToHeaderView{
    if (self.headerView.myVideoView.superview == self.view) {
        [self.headerView.myVideoView removeFromSuperview];
        CGRect frame = self.headerView.myVideoView.frame;
        frame.origin.y = kHeaderUserHeitht;
        frame.origin.x = 0;
        self.headerView.myVideoView.frame = frame;
        [self.headerView addSubview:self.headerView.myVideoView];
        [self.headerView.myVideoView setBackgroundColor:[UIColor clearColor]];
        
        [self.gradientLayer removeFromSuperlayer];
    }
}


#pragma mark - Response

- (void)nickButtonTouched{
    AlivcUserInfoViewController *targetVC = [[AlivcUserInfoViewController alloc]init];
    targetVC.type = AlivcUserVCTypeQuVideo;
    if ([AlivcShortVideoPublishManager shared].currentStatus == AlivcPublishStatusPublishing) {
        targetVC.isPublishing = YES;
    }else{
        targetVC.isPublishing = NO;
    }
    [self.navigationController pushViewController:targetVC animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AlivcNotificationHideUploadProgress" object:nil];
}

- (void)settingButtonTouched{
    AlivcUserInfoViewController *targetVC = [[AlivcUserInfoViewController alloc]init];
    targetVC.type = AlivcUserVCTypeVersion;
    [self.navigationController pushViewController:targetVC animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AlivcNotificationHideUploadProgress" object:nil];
}

- (void)refreshData{
    [self configBaseData];
}

#pragma mark - System Delegate
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.videoList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlivcShortVideoCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
//    if (!cell) {
//        NSLog(@"异常");
//    }
    if (indexPath.row < self.videoList.count) {
        [cell configUIWithModel:self.videoList[indexPath.row]];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if(!self.headerView){
            self.headerView = (AlivcQuHeaderReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderIndetifier forIndexPath:indexPath];
            self.headerView.backgroundColor = [UIColor clearColor];
            [self configHeaderView:self.headerView user:[AliVideoClientUser shared]];
            self.headerView.customDelegate = self;
        }
        return self.headerView;
    }
    return nil;
}

- (void)configHeaderView:(AlivcQuHeaderReusableView *)view user:(AliVideoClientUser *)user{
    if (!user) {
        return;
    }
    if (user.avatarImage) {
        view.avatarImageView.image = user.avatarImage;
    }else if(user.avatarUrlString){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURL *url = [NSURL URLWithString:user.avatarUrlString];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *coverImage = [UIImage imageWithData:imageData];
            if (coverImage) {
                user.avatarImage = coverImage;
                dispatch_async(dispatch_get_main_queue(), ^{
                    view.avatarImageView.image = user.avatarImage;
                });
            }
        });
    }
    if (user.userID) {
        view.userIdLabel.text = user.userID;
    }
    if (user.nickName) {
        NSString *nickString = [NSString stringWithFormat:@"%@>",user.nickName];
        [view.nickNameButton setTitle:nickString forState:UIControlStateNormal];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, kHeaderHeight);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AlivcQuVideoModel *selectedModel = self.videoList[indexPath.row];
    switch (selectedModel.ensorStatus) {
        case AlivcQuVideoAbstractionStatus_On:
            [self showAlertViewWithString:NSLocalizedString(@"视频正在审核中,无法查看" , nil) withTag:0];
            break;
        case AlivcQuVideoAbstractionStatus_Fail:
            _shouldDeleteModel = selectedModel;
            [self showAlertViewWithString:NSLocalizedString(@"抱歉,该视频未通过审核,已不存在" , nil) withTag:101];
            break;
        case AlivcQuVideoAbstractionStatus_Success:{
            NSMutableArray *canPlayVideoList = [[NSMutableArray alloc]init];
            for (AlivcQuVideoModel *model in self.videoList) {
                if (model.ensorStatus == AlivcQuVideoAbstractionStatus_Success) {
                    [canPlayVideoList addObject:model];
                }
            }
            if (canPlayVideoList.count) {
                NSInteger startIndex = 0;
                if (canPlayVideoList.count == self.videoList.count) {
                    startIndex = indexPath.row;
                }else{
                    for (AlivcQuVideoModel *itemModel in canPlayVideoList) {
                        if ([itemModel.videoId isEqualToString:selectedModel.videoId]) {
                            startIndex = [canPlayVideoList indexOfObject:itemModel];
                            break;
                        }
                    }
                }
                [self hideUploadProgressView];
//                AlivcShortVideoPlayViewControler *targetVC = [[AlivcShortVideoPlayViewControler alloc]init];
//                [targetVC setPlayVideoList:canPlayVideoList startPlayIndex:startIndex];
                AlivcShortVideoPlayViewController *targetVC = [[AlivcShortVideoPlayViewController alloc] initWithVideoList:canPlayVideoList startPlayIndex:startIndex];
                [self.navigationController pushViewController:targetVC animated:YES];
            }
           
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%.2f",offset.y);
    if (offset.y > kHeaderUserHeitht) {
        //划出的myVideo视图的相对原点小于于0的一瞬间把myVideo视图加进来
        [self addMyVideoViewToSelfView];
        [self.view bringSubviewToFront:self.settingButton];
    }else{
        //划进来的myVideo视图的相对的原点大于0的一瞬间移除myVideo视图
        [self addMyVideoViewToHeaderView];
    }

}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
   
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101 && _shouldDeleteModel) {
        [AlivcQuVideoServerManager quServerDeletePersonalVideoWithToken:[AliVideoClientUser shared].token videoId:_shouldDeleteModel.videoId userId:[AliVideoClientUser shared].userID success:^{
            NSDictionary *dic = @{AlivcNotificationDeleveVideoSuccess:_shouldDeleteModel};
            [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationDeleveVideoSuccess object:nil userInfo:dic];
            _shouldDeleteModel = nil;
        } failure:^(NSString * _Nonnull errorString) {
            //
        }];
    }
}

#pragma mark - Custom Delegate
#pragma mark - AlivcShortVideoElasticViewDelegate

/**
 视频拍摄按钮点击回调
 
 @param elasticView 对应的UI容器视图
 @param button 拍摄按钮
 */
- (void)shortVideoElasticView:(AlivcShortVideoElasticView *)elasticView shootButtonTouched:(UIButton *)button{
    if (![self judgeIsPublishing]) {
        AliyunMediaConfig *defauleMedia = [AliyunMediaConfig defaultConfig];
        defauleMedia.minDuration = 2;
        defauleMedia.maxDuration = 15;
        [[AlivcShortVideoRoute shared]registerMediaConfig:defauleMedia];
        UIViewController *record = [[AlivcShortVideoRoute shared] alivcViewControllerWithType:AlivcViewControlRecord];
        [self.navigationController pushViewController:record animated:YES];
    }
    
}


/**
 视频编辑按钮点击回调
 
 @param elasticView 对应的UI容器视图
 @param button 视频编辑按钮
 */
- (void)shortVideoElasticView:(AlivcShortVideoElasticView *)elasticView editButtonTouched:(UIButton *)button{
    if (![self judgeIsPublishing]) {
        AliyunMediaConfig *defauleMedia = [AliyunMediaConfig defaultConfig];
        [[AlivcShortVideoRoute shared]registerHasRecordMusic:NO];
        [[AlivcShortVideoRoute shared]registerMediaConfig:defauleMedia];
        UIViewController *editVideoSelectVC = [[AlivcShortVideoRoute shared]alivcViewControllerWithType:AlivcViewControlEditVideoSelect];
        [editVideoSelectVC setValue:@1 forKey:@"isOriginal"];
        [self.navigationController pushViewController:editVideoSelectVC animated:YES];
    }
    
}

/**
 判断当前视频发布的状态
 
 @return 是否在发布中
 */
- (BOOL)judgeIsPublishing{
    if ([AlivcShortVideoPublishManager shared].currentStatus == AlivcPublishStatusPublishing) {
        [MBProgressHUD showMessage:NSLocalizedString(@"视频还在处理中" , nil) inView:self.view];
        return YES;
    }else{
        return NO;
    }
}



#pragma mark - Private Method
- (void)showAlertViewWithString:(NSString *)showString withTag:(NSInteger )tag{
    AlivcAlertView *alertView = [[AlivcAlertView alloc]initWithAlivcTitle:nil message:showString delegate:self cancelButtonTitle:nil confirmButtonTitle:[@"确定" localString]];
    [alertView setStyle:AlivcAlertViewStyleWhite];
    alertView.tag = tag;
    alertView.delegate = self;
    [alertView showInView:self.view];
}

/**
 隐藏上传视图，如果有的话
 */
- (void)hideUploadProgressView{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AlivcNotificationHideUploadProgress" object:nil];
    
}
#pragma mark - Notification Response
- (void)enterMask{
    //UI 变化
    [self.elasticView enterEditStatus:YES inView:self.view];
}

- (void)quitMask{
    //UI 变化
    [self.elasticView enterEditStatus:NO inView:self.view];
    
}

- (void)changeUserSuccess{
    [self configBaseData];
    [self configHeaderView:self.headerView user:[AliVideoClientUser shared]];
}

- (void)publishSuccess{
    [self configBaseData];
    [MBProgressHUD showMessage:NSLocalizedString(@"发布成功，已进入审核通道" , nil) inView:self.view];
}

//网络状态判定
- (void)reachabilityChanged{
    AliyunPVNetworkStatus status = [self.reachability currentReachabilityStatus];
    switch (status) {
        case AliyunPVNetworkStatusNotReachable:
            [MBProgressHUD showMessage:NSLocalizedString(@"请检查网络连接!" , nil) inView:self.view];
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
            if (self.videoList.count == 0) {
                [self configBaseData];
                [self configHeaderView:self.headerView user:[AliVideoClientUser shared]];
            }
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            [MBProgressHUD showMessage:NSLocalizedString(@"当前为4G网络,请注意流量消耗!" , nil) inView:self.view];
            if (self.videoList.count == 0) {
                [self configBaseData];
                [self configHeaderView:self.headerView user:[AliVideoClientUser shared]];
            }
        }
            break;
        default:
            break;
    }
}

//视频已经删除的通知
- (void)videoHaveDeleted:(NSNotification *)noti{
    [self configBaseData];
}

#pragma mark - 旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
