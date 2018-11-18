//
//  TableCountdownVC.m
//  CellTimer
//
//  Created by 信昊 on 2018/11/15.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import "TableCountdownVC.h"
#import "CountDownCell.h"

@interface TableCountdownVC()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *mainArray;

@property (nonatomic, strong) NSMutableArray *timerArray; //存储timer数组，便于释放计时器
@property (nonatomic, strong) NSTimer *mainTimer;         //计时器，控制计时间隔

@property (nonatomic, assign) NSTimeInterval sourceTime;  //时间初始点，与currtentTime的时间差为变化时间间隔
@property (nonatomic, assign) NSTimeInterval currtentTime;//时间变化后时点，与sourceTime的时间差为变化时间间隔

@end



@implementation TableCountdownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
    
    [self setlocalData];
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self killTimer];
}

- (void)dealloc
{
    self.mainTimer = nil;
    NSLog(@"timer %@", self.mainTimer);
}

#pragma mark -创建视图

- (void)setUI
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.mainTableView.backgroundColor = [UIColor lightTextColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
}

#pragma mark -数据

- (void)setlocalData
{
    if (self.mainArray)
    {
        [self.mainArray removeAllObjects];
    }
    else
    {
        self.mainArray = [NSMutableArray array];
    }
    
    NSDate *date = [NSDate date];
    self.currtentTime = [date timeIntervalSinceReferenceDate];
    self.sourceTime = self.currtentTime;
    for (int i = 0; i < 1000; i++)
    {
        NSInteger time = arc4random() % (int)self.currtentTime + 1000;
        NSNumber *timeNumber = [NSNumber numberWithInteger:time];
        [self.mainArray addObject:timeNumber];
    }
    
    if (!self.timerArray)
    {
        self.timerArray = [NSMutableArray array];
    }
    else
    {
        [self killTimer];
    }
    
    if (self.mainTimer)
    {
        [self.mainTimer invalidate];
        self.mainTimer = nil;
    }
//    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(coundDown:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.mainTimer forMode:NSRunLoopCommonModes];
//    [self.timerArray addObject:self.mainTimer];
}

- (void)killTimer
{
    if (self.timerArray)
    {
        for (NSTimer *subTimer in self.timerArray)
        {
            if (subTimer)
            {
                [subTimer invalidate];
            }
        }
        
        [self.timerArray removeAllObjects];
    }
}

#pragma mark -响应事件

- (void)buttonClick:(UIButton *)button
{
    [self setlocalData];
    [self.mainTableView reloadData];
}

- (void)coundDown:(NSTimer *)timer
{
    self.currtentTime--;
    [self.mainTableView reloadData];
}

#pragma mark -列表视图

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const reuseCell = @"reuseCell";
    CountDownCell *cell = (CountDownCell *)[tableView dequeueReusableCellWithIdentifier:reuseCell];
    if (!cell)
    {
        cell = [[CountDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell];
    }
    
    NSNumber *timeNumber = [self.mainArray objectAtIndex:indexPath.row];
    NSInteger time = timeNumber.integerValue;
    time = time - (self.sourceTime - self.currtentTime);
    [cell coundDownStart:time];
    
    NSTimer *cellTimer = [cell getCellTimer];
    [self.timerArray addObject:cellTimer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
