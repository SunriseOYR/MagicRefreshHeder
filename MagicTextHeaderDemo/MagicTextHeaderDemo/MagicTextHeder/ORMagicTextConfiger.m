
//
//  ORMagicTextConfiger.m
//  ORST_Test
//
//  Created by 欧阳荣 on 2018/5/7.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

#import "ORMagicTextConfiger.h"

@implementation ORMagicTextConfiger {
    UIBezierPath *_textPath;
    UIFont *_textFont;
}

+ (instancetype)congigerWithText:(NSString *)text {
    ORMagicTextConfiger *configer = [self new];
    configer.text = text;
    return configer;
}

- (UIBezierPath *)or_pathForTextWith:(UIFont *)font
{
    if (_text.length == 0) {
        return [UIBezierPath bezierPath];
    }
    
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)ctFont, kCTFontAttributeName, nil];
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:_text attributes:attribute];
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex index = 0; index < CFArrayGetCount(runArray); index ++) {
        CTRunRef run = CFArrayGetValueAtIndex(runArray, index);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex j = 0; j < CTRunGetGlyphCount(run); j ++) {
            CFRange range = CFRangeMake(j, 1);
            
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, range, &glyph);
            CTRunGetPositions(run, range, &position);
            
            
            CGPathRef path = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(pathRef, &t, path);
            CGPathRelease(path);
            
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:pathRef]];
    
    CGPathRelease(pathRef);
    CFRelease(ctFont);
    
    
    return path;
}


- (UIBezierPath *)textPath {
    if (!_textPath) {
        _textPath = [self or_pathForTextWith:self.font];
    }
    return _textPath;
}

- (void)setFont:(UIFont *)font {
    _textFont = font;
    _textPath = [self or_pathForTextWith:font];
}

- (UIFont *)font {
    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:30 * [UIScreen mainScreen].bounds.size.width / 375.0];
    }
    return _textFont;
}

- (void)setText:(NSString *)text {
    _text = text;
    _textPath = [self or_pathForTextWith:self.font];
}

@end

@implementation ORMagicLayerAnimation

+ (CAAnimation *)strokeEndAnimationWithDuration:(NSTimeInterval)duration begintime:(NSTimeInterval)begintime {
    
    if (duration <= 0) {
        duration = 5;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.repeatCount = HUGE;
    animation.beginTime = CACurrentMediaTime() + begintime;
    return animation;
}

+ (CAAnimation *)locationsAnimationWithDuration:(NSTimeInterval)duration {
    
    if (duration <= 0) {
        duration = 2.5;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = @[@0, @0, @0.25];
    animation.toValue = @[@0.75, @1, @1];
    animation.duration = duration;
    animation.repeatCount = HUGE;
    return animation;
}

+ (CAAnimation *)positionAnimationWithDuration:(NSTimeInterval)duration path:(CGPathRef)path {
    
    if (duration <= 0) {
        duration = 5;
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = duration;
    animation.path = path;
    animation.repeatCount = HUGE;
    animation.calculationMode = kCAAnimationPaced;
    return animation;
}

@end

