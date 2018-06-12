//
//  ORTextLayer.h
//  ORST_Test
//
//  Created by 欧阳荣 on 2018/5/7.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//



#import "ORMagicTextLayer.h"
#import "ORMagicTextConfiger.h"

static NSString *const kShapeAnimationKey =  @"kShapeAnimationKey";
static NSString *const kGradientAnimationKey =  @"kGradientAnimationKey";
static NSString *const kDrawAnimationKey =  @"kDrawAnimationKey";


@interface ORMagicTextLayer ()

@property (nonatomic, strong) CAShapeLayer * shapeLayer;
@property (nonatomic, strong) CAShapeLayer * maskShapeLayer;

@property (nonatomic, strong) CAGradientLayer * loadGradientLayer;

@property (nonatomic, strong) CALayer * loadShapeLayer;
@property (nonatomic, strong) CAShapeLayer * firstLoadLayer;
@property (nonatomic, strong) CAShapeLayer * lastLoadLayer;

@property (nonatomic, strong) CALayer *drawLayer;

@property (nonatomic, strong) ORMagicTextConfiger *configer;

@end

@implementation ORMagicTextLayer {
    ORloadingStyle _currentStyle;
    BOOL _loading;
    BOOL _isChangeFont;
}

+ (instancetype)layerWithText:(NSString *)text rect:(CGRect)rect {
    
    return [[self alloc] initWithText:text rect:rect];
}


- (instancetype)initWithText:(NSString *)text rect:(CGRect)rect {
    
    if (self = [super init]) {
        
        self.frame = rect;
        self.backgroundColor = [UIColor clearColor].CGColor;
        
        _tintColor = [UIColor redColor];
        _maskColor = [UIColor whiteColor];
        _loadingStyle = ORloadingStyleDraw;
        _loading = NO;
        _isChangeFont = NO;
        
        _configer = [ORMagicTextConfiger congigerWithText:text];
        
        [self _or_initializeLayer];
    }
    return self;
}

- (void)_or_initializeLayer {
    
    CAShapeLayer *layer= [self _or_shapeLayer];
    
    [self maskShapeLayer];
    [self firstLoadLayer];
    [self lastLoadLayer];
    [self addSublayer:layer];

    _shapeLayer = layer;
}

- (CAShapeLayer *)_or_shapeLayer {

    CAShapeLayer *layer = [CAShapeLayer layer];
    
    UIBezierPath *path = _configer.textPath;
    
    layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    layer.bounds = CGPathGetBoundingBox(path.CGPath);
    
    layer.geometryFlipped = YES;
    layer.path = path.CGPath;
    
    layer.strokeColor = _tintColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2.0;
    layer.lineJoin = kCALineJoinBevel;
    return layer;
}

- (CAShapeLayer *)_or_shapeLayerWithStrokColor:(UIColor *)strokColor {
    CAShapeLayer *layer = [self _or_shapeLayer];
    layer.strokeColor = strokColor.CGColor;
    return layer;
}

- (void)_or_shapeLayer:(CAShapeLayer *)layer changePath:(CGPathRef)path {
    layer.path = path;
    layer.bounds = CGPathGetBoundingBox(path);
}

- (CGRect)_or_gradientBounds {
    
    CGFloat width = _shapeLayer.bounds.size.width + 60;
    CGFloat x = (self.bounds.size.width - width) / 2.0;
    return CGRectMake(x, 0, width, self.bounds.size.height);
}

- (void)_or_updatePath {
    
    if (_loading) {
        _isChangeFont =  YES;
        return;
    }
    
    _isChangeFont = NO;
    
    [self _or_shapeLayer:_shapeLayer changePath:_configer.textPath.CGPath];
    [self _or_shapeLayer:_maskShapeLayer changePath:_configer.textPath.CGPath];
    [self _or_shapeLayer:_firstLoadLayer changePath:_configer.textPath.CGPath];
    [self _or_shapeLayer:_lastLoadLayer changePath:_configer.textPath.CGPath];
    
    self.loadGradientLayer.bounds = [self _or_gradientBounds];
}

#pragma mark -- public
- (void)startLoadAnimation {
    
    if (_loading) {
        return;
    }
    
    _loading = YES;
    _currentStyle = _loadingStyle;
    
    if (_loadingStyle == ORloadingStyleShape) {
        
        self.loadShapeLayer.hidden = NO;
        self.loadShapeLayer.mask = self.maskShapeLayer;
        [self.firstLoadLayer addAnimation:[ORMagicLayerAnimation strokeEndAnimationWithDuration:5.0 begintime:0.1] forKey:kShapeAnimationKey];
        [self.lastLoadLayer addAnimation:[ORMagicLayerAnimation strokeEndAnimationWithDuration:5.0 begintime:0.3] forKey:kShapeAnimationKey];
    }else if (_loadingStyle == ORloadingStyleGradient) {
        
        self.loadGradientLayer.mask = self.maskShapeLayer;
        self.loadGradientLayer.hidden = NO;
        [self.loadGradientLayer addAnimation:[ORMagicLayerAnimation locationsAnimationWithDuration:2.5] forKey:kGradientAnimationKey];
    }else {
        
        self.drawLayer.hidden = NO;
        [self.drawLayer addAnimation:[ORMagicLayerAnimation positionAnimationWithDuration:[self drawDuration] path:_configer.textPath.CGPath] forKey:kDrawAnimationKey];
        [self.shapeLayer addAnimation:[ORMagicLayerAnimation strokeEndAnimationWithDuration:[self drawDuration] begintime:0] forKey:kShapeAnimationKey];
    }
}

- (void)stopLoadAnimation {
    
    _loading = NO;
    
    if (_currentStyle == ORloadingStyleShape) {
        
        self.loadShapeLayer.hidden = YES;
        [self.firstLoadLayer removeAnimationForKey:kShapeAnimationKey];
        [self.lastLoadLayer removeAnimationForKey:kShapeAnimationKey];
    }else if (_currentStyle == ORloadingStyleGradient) {
        
        self.loadGradientLayer.hidden = YES;
        [self.loadGradientLayer removeAnimationForKey:kGradientAnimationKey];
    }else {
        
        self.drawLayer.hidden = YES;
        [self.drawLayer removeAnimationForKey:kDrawAnimationKey];
        [self.shapeLayer removeAnimationForKey:kShapeAnimationKey];
    }
}

#pragma mark -- setter && getter

- (void)setProgress:(CGFloat)progress {
    
    CGFloat newRatio = fmax(0, progress - self.ratio);
    
    CGFloat max = 1.0 - self.ratio;
    CGFloat rr = newRatio / max;
    
    
    CGFloat ratio = fmin(rr, 1.0f);
    
    _shapeLayer.strokeEnd = ratio;
    
    if (_isChangeFont && newRatio <= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _or_updatePath];
        });
    }
    
}

- (void)setTintColor:(UIColor *)tintColor {
    
    _tintColor = tintColor;
    
    _shapeLayer.strokeColor = tintColor.CGColor;
    _maskShapeLayer.strokeColor = tintColor.CGColor;
    _lastLoadLayer.strokeColor = tintColor.CGColor;
}

- (void)setFont:(UIFont *)font {
    
    _configer.font = font;
    
    [self _or_updatePath];
}

- (void)setText:(NSString *)text {
    _configer.text = text;
    [self _or_updatePath];
}

- (NSString *)text {
    return _configer.text;
}


- (UIFont *)font {
    return _configer.font;
}


- (CALayer *)loadGradientLayer {
    
    if (!_loadGradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        gradientLayer.bounds = [self _or_gradientBounds];
        gradientLayer.colors = @[
                                 (__bridge id)_tintColor.CGColor,
                                 (__bridge id)_maskColor.CGColor,
                                 (__bridge id)_tintColor.CGColor,
                                 ];
        gradientLayer.locations = @[@0.25,@0.5,@0.75];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.hidden = YES;

        gradientLayer.mask = self.maskShapeLayer;

        [self addSublayer:gradientLayer];
        _loadGradientLayer = gradientLayer;
    }
    return _loadGradientLayer;
}

- (CALayer *)loadShapeLayer {
    if (!_loadShapeLayer) {
        
        _loadShapeLayer = [CALayer layer];
        _loadShapeLayer.frame = self.bounds;
        _loadShapeLayer.backgroundColor = _tintColor.CGColor;
        _loadShapeLayer.hidden = YES;

        [_loadShapeLayer addSublayer:self.firstLoadLayer];
        [_loadShapeLayer addSublayer:self.lastLoadLayer];
        _loadShapeLayer.mask = self.maskShapeLayer;
        
        [self addSublayer:_loadShapeLayer];
    }
    return _loadShapeLayer;
}

- (CAShapeLayer *)firstLoadLayer {
    if (!_firstLoadLayer) {
        _firstLoadLayer = [self _or_shapeLayerWithStrokColor:_maskColor];
    }
    return _firstLoadLayer;
}

- (CAShapeLayer *)lastLoadLayer {
    if (!_lastLoadLayer) {
        _lastLoadLayer = [self _or_shapeLayerWithStrokColor:_tintColor];
    }
    return _lastLoadLayer;
}

- (CAShapeLayer *)maskShapeLayer {
    if (!_maskShapeLayer) {
        _maskShapeLayer = [self _or_shapeLayer];
    }
    return _maskShapeLayer;
}

- (CALayer *)drawLayer {
    if (!_drawLayer) {
        _drawLayer = [CALayer layer];
        _drawLayer.bounds = CGRectMake(0, 0, 16, 16);
        _drawLayer.contents = CFBridgingRelease([UIImage imageNamed:@"draw"].CGImage);
        _drawLayer.anchorPoint = CGPointZero;
        _drawLayer.hidden = YES;
        [self.shapeLayer addSublayer:_drawLayer];
    }
    return _drawLayer;
}

- (CGFloat)ratio {
    CGRect bounds = CGPathGetBoundingBox(_configer.textPath.CGPath);
    return (self.bounds.size.height - bounds.size.height) / 2.0 / self.bounds.size.height;
}

- (NSTimeInterval)drawDuration {
    return self.text.length ;
}

@end













