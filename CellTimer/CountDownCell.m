//
//  CountDownCell.m
//  CellTimer
//
//  Created by 信昊 on 2018/11/15.
//  Copyright © 2018年 信昊. All rights reserved.
//


#import "CountDownCell.h"

@interface CountDownCell ()

@end

@implementation CountDownCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.frame.size.width - 10.0 * 2, self.frame.size.height)];
        [self addSubview:label];
    }
    return self;
}

- (void)dealloc
{
    coundTimer = nil;
    NSLog(@"cell timer %@", coundTimer);
}

//开始计时
- (void)coundDownStart:(NSInteger)time
{
    currentTime = time;
    [self show];
    if (!coundTimer)
    {
        coundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(coundDown:) userInfo:nil repeats:YES];

        [[NSRunLoop currentRunLoop]addTimer:coundTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)coundDown:(NSTimer *)timer
{
    currentTime--;
    [self show];
}

- (void)show
{
    NSInteger day = currentTime / (24 * 60 * 60);
    NSInteger hour = (currentTime % (24 * 60 * 60)) / (60 * 60);
    NSInteger minute = ((currentTime % (24 * 60 * 60)) % (60 * 60)) / 60;
    NSInteger second = ((currentTime % (24 * 60 * 60)) % (60 * 60)) % 60;
    NSString *time = [NSString stringWithFormat:@"%d天%d时%d分钟%d秒", day, hour, minute, second];
    NSString *timeStr = [NSString stringWithFormat:@"倒计时：%@", time];
    label.text = timeStr;
}

//释放计时器
- (void)releaseTimer
{
    if (coundTimer)
    {
        if ([coundTimer isValid])
        {
            [coundTimer invalidate];
            coundTimer = nil;
        }
    }
}

///获取计时器
- (NSTimer *)getCellTimer
{
    return coundTimer;
}

@end

