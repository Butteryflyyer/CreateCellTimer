//
//  ViewController.m
//  CellTimer
//
//  Created by 信昊 on 2018/11/15.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import "ViewController.h"

static  NSString  * const indexPathKey =@"indexPath";
static  NSString  * const showTimeKey =@"showTime";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSTimer *timer; /// 定时器
@property (nonatomic, strong) NSMutableArray *times; /// 时间数组
@property (nonatomic, strong) NSMutableArray *showTimes; /// 显示倒计时数组
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _times = [NSMutableArray array];
    
    _showTimes = [NSMutableArray array];
    
    
    //模拟倒计时数据
    
    for (int i=0; i<20; i++) {
        
        NSInteger time = (arc4random() % 1000) + 100;
        
        [_times addObject:[NSString stringWithFormat:@"%ld",time]];
        
        NSDictionary *timedic = @{indexPathKey:[NSString stringWithFormat:@"%i",i],
                                  showTimeKey: [NSString stringWithFormat:@"%ld",time]};
        
        [_showTimes addObject:timedic];
    }
    
    _myTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _myTableView.delegate=self;
    
    _myTableView.dataSource=self;
    
    _myTableView.rowHeight=80.0f;
    
    [self.view addSubview:_myTableView];
    
    
    // 创建定时器
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdown) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _showTimes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID =@"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text= [NSString stringWithFormat:@"活动结束还剩下：%@ 秒", _times[indexPath.row]];
    
    return cell;
    
}

- (void)countdown{
    
    NSInteger time;
    
    for (int i = 0; i < _showTimes.count; i++) {
        
        time = [_showTimes[i][showTimeKey] integerValue];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_showTimes [i][indexPathKey] integerValue] inSection:0];
        
        UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
        
        if (time > 0) {
            cell.textLabel.text =[NSString stringWithFormat:@"活动结束还剩下：%ld 秒", time];
            time --;
            NSDictionary *dic = @{indexPathKey: [NSString stringWithFormat:@"%d",i],
                                  showTimeKey: [NSString stringWithFormat:@"%ld",time]};
            
            [_showTimes replaceObjectAtIndex:i withObject:dic];
            
        }else {
            
            cell.textLabel.text = [NSString stringWithFormat:@"活动已结束"];
            
        }
        
    }
    
}
//销毁定时器
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        
    }
}



@end
