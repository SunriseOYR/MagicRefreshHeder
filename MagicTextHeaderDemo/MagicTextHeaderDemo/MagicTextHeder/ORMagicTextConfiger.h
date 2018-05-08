//
//  ORMagicTextConfiger.h
//  ORST_Test
//
//  Created by 欧阳荣 on 2018/5/7.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface ORMagicTextConfiger : NSObject

@property (nonatomic, copy) UIFont *font;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong, readonly) UIBezierPath *textPath;

+ (instancetype)congigerWithText:(NSString *)text;

//- (CAShapeLayer *)shapeLayer

@end

@interface ORMagicLayerAnimation : NSObject

+ (CAAnimation *)strokeEndAnimationWithDuration:(NSTimeInterval)duration begintime:(NSTimeInterval)begintime;
+ (CAAnimation *)locationsAnimationWithDuration:(NSTimeInterval)duration;
+ (CAAnimation *)positionAnimationWithDuration:(NSTimeInterval)duration path:(CGPathRef)path;

@end
