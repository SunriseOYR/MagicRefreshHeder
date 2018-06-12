//
//  ORRefreshMagicTextHeader.h
//  ORST_Test
//
//  Created by 欧阳荣 on 2018/5/7.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

#import <MJRefresh.h>
#import "ORMagicTextLayer.h"

@interface ORRefreshMagicTextHeader : MJRefreshHeader

@property (nonatomic, assign) ORloadingStyle loadStyle;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *tintColor;


- (void)endRefreshingWithoutAnimation;



@end
