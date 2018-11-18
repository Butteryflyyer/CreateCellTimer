//
//  BestManager.m
//  CellTimer
//
//  Created by 信昊 on 2018/11/18.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import "BestManager.h"

@implementation BestManager{
    dispatch_source_t _timer;
    NSDateFormatter *dateFormatter;
    
    NSInteger               _timeLess;//时间差
    UITableView         *_myTableView;
    NSArray                *_dataList;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLess];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLess) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (instancetype)initWith:(UITableView *)tableView :(NSArray *)dataList {
    self = [super init];
    if (self) {
        _myTableView = tableView;
        _dataList = dataList;
        [self setupLess];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLess) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)setupLess {
    
        _timeLess = 0;

        if (_dataList) {
            [self destoryTimer];
            [self timeDown:_myTableView :_dataList];
        }
    
}

- (void)timeDown:(UITableView*)tableView :(NSArray*)dataList {
    
    _myTableView = tableView;
    _dataList = dataList;
    if (_timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray  *cells = tableView.visibleCells; //取出屏幕可见ceLl
                
                for (UITableViewCell * cell in cells) {
                    
                    NSDate * sjDate = [NSDate date];   //手机时间
                    NSInteger sjInteger = [sjDate timeIntervalSince1970];  // 手机当前时间戳
                    NSString* tempEndTime;
                    if ([dataList[0] isKindOfClass:[NSArray class]]) {
                        NSInteger section = cell.tag / 1000;
                        NSInteger row = cell.tag % 1000;
                        tempEndTime = dataList[section][row];
                    }else {
                        
                        tempEndTime = dataList[cell.tag];
                    }
                    
                    for (UIView * labText in cell.contentView.subviews) {
                        if (labText.tag == 1314) {
                            UILabel * textLabel = (UILabel *)labText;
                            NSInteger endTime = tempEndTime.longLongValue + _timeLess;
                            
                            textLabel.text = [self getNowTimeWithString:endTime :sjInteger];
                        }
                    }
   
                }
            });
        });
        dispatch_resume(_timer); // 启动定时器
    }
    
}

/// 滑动过快的时候不会闪
- (NSString *)timeDown :(NSIndexPath *)indexPath{
    NSDate * sjDate = [NSDate date];   //手机时间
    NSInteger sjInteger = [sjDate timeIntervalSince1970];  // 手机当前时间戳
    NSString* tempEndTime;
    if ([_dataList[0] isKindOfClass:[NSArray class]]) {
        
        tempEndTime = _dataList[indexPath.section][indexPath.row];
    }else {
        
        tempEndTime = _dataList[indexPath.row];
    }
    
    NSInteger endTime = tempEndTime.longLongValue + _timeLess;
    
    return [self getNowTimeWithString:endTime :sjInteger];
    
}

// 传入结束时间 | 计算与当前时间的差值
-(NSString *)getNowTimeWithString:(NSInteger )aTimeString :(NSInteger)startTime{
    
    NSTimeInterval timeInterval = aTimeString - startTime;
    //    NSLog(@"%f",timeInterval);
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    
    
    if (_isPlusTime) {
        ///////////////////新增
        if (hours>=0&&minutes>=0&&seconds>=0) {
            return @"活动未开始！";
        }
        hours = -hours;
        minutes = -minutes;
        seconds = - seconds;
        ///////////////////新增
    }else {
        if (hours<=0&&minutes<=0&&seconds<=0) {
            return @"活动已经结束！";
        }
    }
    
    
    if (days) {
        //        return [NSString stringWithFormat:@"%@天 %@小时 %@分 %@秒", dayStr,hoursStr, minutesStr,secondsStr];
        return [NSString stringWithFormat:@"%zd天 %zd小时 %zd分 %zd秒", days,hours,minutes,seconds];
    }
    //    return [NSString stringWithFormat:@"%@小时 %@分 %@秒",hoursStr , minutesStr,secondsStr];
    return [NSString stringWithFormat:@"%zd小时 %zd分 %zd秒",hours , minutes,seconds];
}



/// 回传时间的变化
-(void)timeDownWithtimeBlock:(void (^)())timeBlock{
    if (_timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                timeBlock(); // 回传时间的变化
            });
        });
        dispatch_resume(_timer); // 启动定时器
    }
}

/**
 *  主动销毁定时器
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
    
}


@end
