//
//  BestManager.h
//  CellTimer
//
//  Created by 信昊 on 2018/11/18.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BestManager : NSObject

- (void)destoryTimer;

///每秒走一次，回调block
- (void)timeDown:(UITableView*)tableView :(NSArray*)dataList;

/// 滑动过快的时候时间不会闪  (tableViewcell数据源方法里实现即可)
- (NSString *)timeDown :(NSIndexPath *)indexPath;

- (instancetype)initWith :(UITableView*)tableView :(NSArray*)dataList;

@property (nonatomic,assign)BOOL isPlusTime;

@end

NS_ASSUME_NONNULL_END
