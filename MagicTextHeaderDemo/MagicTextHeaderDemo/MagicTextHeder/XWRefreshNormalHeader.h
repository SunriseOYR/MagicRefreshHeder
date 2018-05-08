//
//  XWRefreshNormalHeader.h
//  XWCurrencyExchange
//
//  Created by YouLoft_MacMini on 16/2/3.
//  Copyright © 2016年 wazrx. All rights reserved.
//

#import <MJRefresh.h>
#import "ORMagicTextLayer.h"

@interface XWRefreshNormalHeader : MJRefreshHeader

@property (nonatomic, assign) ORloadingStyle loadStyle;

@property (nonatomic, strong) UIFont *font;


- (void)endRefreshingWithoutAnimation;



@end
