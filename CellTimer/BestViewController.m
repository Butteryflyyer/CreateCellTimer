//
//  BestViewController.m
//  CellTimer
//
//  Created by 信昊 on 2018/11/18.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import "BestViewController.h"
#import "BestManager.h"
#import "BestCell.h"
@interface BestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *dataList;


@end

@implementation BestViewController{
    BestManager *bestTimerManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BestCell" bundle:nil] forCellReuseIdentifier:@"BestCell"];
    
    
    
    bestTimerManager = [[BestManager alloc] initWith:self.tableView :self.dataList];

    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BestCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BestCell"];
    
    /// 3.绑定tag
    cell.tag = indexPath.row;
    cell.timeLabel.tag = 1314;
//    cell.timeLabel.text = [bestTimerManager timeDown:indexPath];
//    if (_isPlusTime) {
//        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.subTitleLabel.textColor = [UIColor whiteColor];
//        cell.contentView.backgroundColor = [UIColor blackColor];
//    }
    
//    cell.subTitleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    /*
     NSDate * datenow = [NSDate date];
     NSString*timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
     NSTimeZone*zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
     NSInteger interval = [zone secondsFromGMTForDate:datenow];
     NSDate*localeDate = [datenow dateByAddingTimeInterval:interval];
     NSString*timeSpp = [NSString stringWithFormat:@"%f", [localeDate timeIntervalSince1970]];
     NSLog(@"%@",timeSp);
     NSLog(@"%@",timeSpp);
     */
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


///  假数据
- (NSArray *)dataList {
  
        
        NSMutableArray * nmArr;
        if (_dataList == nil) {
            _dataList = [NSArray array];
            
            nmArr = [NSMutableArray array];
            NSArray *arr = [NSArray array];
            NSDate * datenow = [NSDate date];
            NSString*timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            NSInteger nowInteger = [timeSp integerValue];
            for (int i = 0; i < 50; i ++) {
                NSString *str = [NSString stringWithFormat:@"%zd",arc4random()%100000 + nowInteger];
                NSString *str1 = [NSString stringWithFormat:@"%zd",arc4random()%1000 + nowInteger];
                NSString *str2 = [NSString stringWithFormat:@"%zd",arc4random()%100 + nowInteger];
                arr = @[str,str1,str2];
                [nmArr addObjectsFromArray:arr];
            }
            _dataList = nmArr.copy;
        }
        return _dataList;
    
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
