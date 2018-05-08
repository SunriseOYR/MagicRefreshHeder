//
//  ORTextLayer.h
//  ORST_Test
//
//  Created by 欧阳荣 on 2018/5/7.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    ORloadingStyleShape,
    ORloadingStyleGradient,
    ORloadingStyleDraw
} ORloadingStyle;

@interface ORMagicTextLayer : CALayer


+ (instancetype)layerWithText:(NSString *)text rect:(CGRect)rect;


@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) ORloadingStyle loadingStyle;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, copy) UIColor *maskColor;
/*
 * ORloadingStyleDraw 时生效
 */
@property (nonatomic, strong) UIImage *drawImage;


- (void)startLoadAnimation;
- (void)stopLoadAnimation;

@end
