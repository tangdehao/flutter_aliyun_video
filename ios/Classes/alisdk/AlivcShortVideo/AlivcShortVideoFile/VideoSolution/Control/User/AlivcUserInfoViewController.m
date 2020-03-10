//
//  AlivcUserInfoViewController.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/5/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcUserInfoViewController.h"
#import "AlivcNicknameEditViewController.h"
#import "AlivcUserInfoManager.h"
#import "AlivcProfile.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+AlivcHelper.h"
#import "AlivcQuUserManager.h"
#import "NSData+AlivcHelper.h"
#import "AlivcDefine.h"
#import <AliyunVideoSDKPro/AliyunVideoSDKInfo.h>
#import <AliyunPlayer/AliPlayer.h>

@interface AlivcUserInfoViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeAvatorButton;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIButton *changeUserButton;
@property (weak, nonatomic) IBOutlet UIImageView *avaterBackImageView;
@property (weak, nonatomic) IBOutlet UIView *gridentView;

@property (weak, nonatomic) IBOutlet UIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end

@implementation AlivcUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [@"User Setting" localString];
    self.containView.backgroundColor = [UIColor clearColor];
    self.avatorImageView.layer.cornerRadius = self.avatorImageView.frame.size.width / 2;
    self.avatorImageView.clipsToBounds = true;
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.changeAvatorButton.layer.cornerRadius = self.changeAvatorButton.frame.size.width / 2;
    self.changeAvatorButton.clipsToBounds = true;
    [self.changeUserButton setBackgroundColor:[UIColor colorWithHexString:@"#373d41"]];
    [self.changeUserButton setTitle:[@"Switch User" localString] forState:UIControlStateNormal];
    [self.changeUserButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"user_pic_0%d",arc4random() % 4 + 1]];
    self.avaterBackImageView.image = image;
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[(id)[UIColor colorWithHexString:@"#1e222d" alpha:0].CGColor,
                     (id)[UIColor colorWithHexString:@"#1d212c" alpha:0.53].CGColor,
                     (id)[UIColor colorWithHexString:@"#1e222d" alpha:1].CGColor];
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = self.view.bounds;
    [self.gridentView.layer addSublayer:layer];
    
    switch (self.type) {
        case AlivcUserVCTypeLive:
            if (![AlivcProfile shareInstance].userId) {
                [self changeUser];
            }else{
                 [self loadUserData];
            }
            break;
        case AlivcUserVCTypeQuVideo:
            [self loadUserData];
            //注册通知
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishEndFlow) name:AlivcNotificationPublishFlowEnd object:nil];
            break;
        case AlivcUserVCTypeVersion:
        {
            self.title = [@"设置" localString];
            
            [self loadSDKInfo];
        }
        default:
            break;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)returnAction{
    [super returnAction];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AlivcNotificationShowUploadProgress" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)loadUserData{
   
    if (self.type == AlivcUserVCTypeQuVideo) {
        [self.avatorImageView setImage:nil];
        if ([AliVideoClientUser shared].avatarImage) {
            [self.avatorImageView setImage:[AliVideoClientUser shared].avatarImage];
        }else{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSURL *url = [NSURL URLWithString:[AliVideoClientUser shared].avatarUrlString];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.avatorImageView setImage:image];
                });
            });
        }
        
        
        if ([AliVideoClientUser shared].nickName) {
            self.nameLabel.text = [AliVideoClientUser shared].nickName;
            [self.nameLabel adjustsFontSizeToFitWidth];
        }
        
        if ([AliVideoClientUser shared].userID) {
            self.idLabel.text = [AliVideoClientUser shared].userID;
        }
        
    }else{
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:[AlivcProfile shareInstance].avatarUrlString] placeholderImage:[UIImage imageNamed:@"test_avator_boy"]];
        self.nameLabel.text = [AlivcProfile shareInstance].nickname;
        self.idLabel.text = [AlivcProfile shareInstance].userId;
    }
}

- (void)loadSDKInfo{
    self.changeUserButton.hidden = YES;
    self.rightImageView.hidden = YES;
    self.changeAvatorButton.hidden = YES;
    self.idLabel.hidden = YES;
    self.nameLabel.hidden = YES;
    self.nickNameButton.userInteractionEnabled = NO;
    
    UILabel *versionLabel = [[UILabel alloc]init];
    NSString *versionString = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"%@【V%@】",NSLocalizedString(@"趣视频版本号", nil),versionString];
    versionLabel.textColor = [UIColor whiteColor];
    versionLabel.font = [UIFont systemFontOfSize:18];
    [versionLabel sizeToFit];
    [self.view addSubview:versionLabel];
    versionLabel.center = CGPointMake(ScreenWidth / 2 , ScreenHeight / 2 + 10);
    
    
    NSString *shortVideoSDKVersionString = [AliyunVideoSDKInfo version];
    NSString *playSDKVersionString = [AliPlayer getSDKVersion];
    
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.textColor = [UIColor groupTableViewBackgroundColor];
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.numberOfLines = 3;
    infoLabel.frame = CGRectMake(0, 0, ScreenWidth / 2 + 50, 50);
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:infoLabel];
    
    NSString *allVersionString = [NSString stringWithFormat:@"%@【V%@】/ %@【V%@】",NSLocalizedString(@"包含短视频SDK 版本号", nil),shortVideoSDKVersionString,NSLocalizedString(@"播放器SDK 版本号", nil),playSDKVersionString];
    infoLabel.text = allVersionString;
    infoLabel.center = CGPointMake(ScreenWidth / 2, CGRectGetMaxY(versionLabel.frame) + 40);
    
    self.avatorImageView.image = [UIImage imageNamed:@"alivcIcon"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeAvator:(id)sender {
    
}

- (IBAction)changeName:(id)sender {
    AlivcNicknameEditViewController *targetVC = [[AlivcNicknameEditViewController alloc]init];
    if (self.type == AlivcUserVCTypeLive) {
        targetVC.isQuVideo = NO;
    }else{
        targetVC.isQuVideo = YES;
    }
    __weak typeof(self)weakSelf = self;
    [targetVC setUpdateNickNameCompltion:^(NSString *errorStr) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) return;
        if (errorStr) {
            [MBProgressHUD showMessage:[@"网络错误" localString] inView:strongSelf.view];
        }else{
            [strongSelf loadUserData];
        }
    }];
    [self.navigationController pushViewController:targetVC animated:true];
}

- (IBAction)changeUser:(id)sender {
    NSLog(@"更换用户");
    if (self.type == AlivcUserVCTypeQuVideo) {
        if (_isPublishing) {
            [MBProgressHUD showMessage:NSLocalizedString(@"当前有视频正在发布中,无法更换用户", nil) inView:self.view];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"警告⚠️", nil) message:NSLocalizedString(@"更换用户后你所有的个人视频与信息将丢失,请谨慎操作!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消" , nil) otherButtonTitles:NSLocalizedString(@"更换", nil), nil];
            [alertView show];
        }
    }else{
        [self changeUser];
    }
    
}


- (void)changeUser{
    __weak typeof(self)weakSelf = self;
    [AlivcUserInfoManager randomAUserSuccess:^(AlivcLiveUser * _Nonnull liveUser) {
        AlivcProfile *profile = [AlivcProfile shareInstance];
        profile.userId = liveUser.userId;
        profile.avatarUrlString = liveUser.avatarUrlString;
        profile.nickname = liveUser.nickname;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf)return;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf loadUserData];
            [MBProgressHUD showMessage:[@"change_new_user" localString] inView:strongSelf.view];
        });
        
    } failure:^(NSString * _Nonnull errDes) {

        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf)return;
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD showMessage:[@"网络错误" localString] inView:strongSelf.view];
        });
    }];
}

- (void)changeQuUser{
    [AlivcQuUserManager randomAUserSuccess:^{
        NSData *data = [NSData dataWithObject:[AliVideoClientUser shared]];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:AlivcUserLocalPath];
        [self loadUserData];
        [MBProgressHUD showMessage:[@"change_new_user" localString] inView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:AlivcNotificationChangeUserSuccess object:nil];
    } failure:^(NSString * _Nonnull errDes) {
        [MBProgressHUD showMessage:[@"网络错误" localString] inView:self.view];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self changeQuUser];
    }
}

- (void)publishEndFlow{
    _isPublishing = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
