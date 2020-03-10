//
//  AlivcShortVideoPlayCollectionViewDataSource.h
//  AliyunVideoClient_Entrance
//
//  Created by 孙震 on 2019/4/28.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AlivcShortVideoCoverCell;
@class AlivcQuVideoModel;
@class AlivcShortVideoBasicVideoModel;

typedef void(^CellConfig)(AlivcShortVideoCoverCell * _Nullable cell,NSIndexPath * _Nullable indexPath);

NS_ASSUME_NONNULL_BEGIN

@interface AlivcShortVideoPlayCollectionViewDataSource : NSObject<UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<AlivcShortVideoBasicVideoModel *> *videoList;

- (instancetype)initWithCellID:(NSString *)cellID cellConfig:(CellConfig)cellConfig;

- (AlivcQuVideoModel *)videoModelWithIndexPath:(NSIndexPath *)indexPath;

- (void)removeVideoAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
