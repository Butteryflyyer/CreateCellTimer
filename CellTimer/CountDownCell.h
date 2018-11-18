//
//  CountDownCell.h
//  CellTimer
//
//  Created by 信昊 on 2018/11/15.
//  Copyright © 2018年 信昊. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CountDownCell : UITableViewCell
{
@private
    UILabel *label;
    
    NSTimer *coundTimer;   //计时器
    NSInteger currentTime; //计时时间，秒
}

///开始计时
- (void)coundDownStart:(NSInteger)time;

///释放计时器
- (void)releaseTimer;

///获取计时器，便于释放计时器
- (NSTimer *)getCellTimer;

@end
