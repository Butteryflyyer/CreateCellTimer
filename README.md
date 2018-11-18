# CreateCellTimer
多个cell时间倒计时，最佳实现方法探索
![image.png](https://upload-images.jianshu.io/upload_images/2440780-c5926799b93b3534.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##最近想起来以前看一个项目时的需求，是一个商品页的倒计时功能，当然是每个cell上都有一个倒计时。于是进行了一番探索。目的在于找到最恰当的方法，耗性能最低的方法来实现这个需求。
如果相对nstimer有更多了解可以看我之前整理的这篇文章，[ios』来自NSTimer的坑 ，告别循环， 最全的方法总结](https://www.jianshu.com/p/76de8b963353)

##第一种方法
我觉得这是最容易想到的方法，也是耗性能最高的方法。每个cell上搞一个时间计时器nstimer，当然是有复用的，但是这也会创建1个以上的nstimer。
暴露下面的方法给外界调用，我们会发现，虽然并不会每个cell都会去创建nstimer，但是也确实会创建一个以上的数量。
```
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
```
有创建就会有释放,在页面将要消失的时候，我们拿到cell中nstimer所在的数组，然后全部释放掉，就可以。
```
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
```

##第二种方法
上面一个种方法是利用cell的复用，创建了nstimer，数量是多个的，现在我们要考虑的肯定是想办法只用一个nstimer来实现这个需求。
我们用这里创建一个时间计时器，然后每秒钟都去遍历，这个数据源时间，然后根据NSIndexPath拿到所有的cell，挨个赋值。这也是一种实现方式。
```
- (void)countdown{
    
    NSInteger time;
    
    for (int i = 0; i < _showTimes.count; i++) {
        
        time = [_showTimes[i][showTimeKey] integerValue];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_showTimes [i][indexPathKey] integerValue] inSection:0];
        
        UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
        
        if (time > 0) {
            cell.textLabel.text =[NSString stringWithFormat:@"活动结束还剩下：%ld 秒", time];
            time --;
            NSDictionary *dic = @{indexPathKey: [NSString stringWithFormat:@"%d",I],
                                  showTimeKey: [NSString stringWithFormat:@"%ld",time]};
            
            [_showTimes replaceObjectAtIndex:i withObject:dic];
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"活动已结束"];   
        }   
    }  
}
```
##最好的方法，第三种方法。
上面虽然是创建了一个时间计时器，但是还不够，因为每次都会去遍历这个时间数组，如果这个数据源很大的话，效果肯定也不理想。
所以我们可以这样，同样，创建一个计时器，然后去遍历这个tableView中目前可见的cell，拿到这些cell，然后分别赋值。
拿出可见cell的api
```
NSArray  *cells = tableView.visibleCells; //取出屏幕可见cell   
```
这里我们采用了gcd的形式。
为何要采取gcd的形式呢？
想一下，nstimer依赖于什么，runloop是吧，我们需要注意要启动runloop，而且还需要注意mode的种类，用commonmodel，防止在滑动tableView的时候，timer停止。
还有，我们还需要注意之前说的，nstimer防止循环引用的问题。
还有，NSTimer的创建与撤销必须在同一个线程操作。~

合理利用了cell.tag值跟cell.timeLabel的tag值来区分

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BestCell"];
    
    /// 3.绑定tag
    cell.tag = indexPath.row;
    cell.timeLabel.tag = 1314;
    return cell;
}
```
```
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
```
取消计时器的话,调用cancel方法就可以了，是不是很easy。
```
/**
 *  主动销毁定时器
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
```
