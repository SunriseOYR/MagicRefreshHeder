//
//  ViewController.m
//  MagicTextHeaderDemo
//
//  Created by 欧阳荣 on 2018/5/8.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh.h>
#import "ORRefreshMagicTextHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header endRefreshing];
//        });
//    }];
    
    ORRefreshMagicTextHeader *header = [ORRefreshMagicTextHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    header.text = @"MGT";
    header.font = [UIFont fontWithName:@"FZXingKai-S04S" size:30];
    header.tintColor = [UIColor purpleColor];
    
    header.loadStyle = ORloadingStyleShape;
    
    self.tableView.mj_header = header;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
