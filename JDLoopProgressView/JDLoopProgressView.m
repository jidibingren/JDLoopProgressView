//
//  JDLoopProgressView.m
//  Example
//
//  Created by SC on 16/7/28.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "JDLoopProgressView.h"

#define JDLPV_SELF_WIDTH CGRectGetWidth(self.bounds)
#define JDLPV_SELF_HEIGHT CGRectGetHeight(self.bounds)
#define JDLPV_DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@interface JDLoopProgressView ()

@property (strong, nonatomic) CAShapeLayer *colorMaskLayer; // 渐变色遮罩
@property (strong, nonatomic) CAShapeLayer *colorLayer; // 渐变色
@property (strong, nonatomic) CAShapeLayer *blueMaskLayer; // 蓝色背景遮罩

@end

@implementation JDLoopProgressView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupLoopProgressView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupLoopProgressView];
    }
    
    return self;
}

- (void)setupLoopProgressView{
    
    _lineWidth = 20;
    _startAngle = (M_PI * (-90) / 180.0);
    _endAngle = (M_PI * (270) / 180.0);
    _backgroundLineWidth = 30;
    _backgroundLineColor = [UIColor blueColor];
    _colorsArray = @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor],[UIColor purpleColor],];
    
    [self setupCenterLabel];
    [self setupBlueMaskLayer];
    [self setupColorLayer];
    [self setupColorMaskLayer];
}

- (void)setupCenterLabel{
    
    _centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2 - self.radius, CGRectGetHeight(self.bounds)/2 - self.radius, self.radius*2, self.radius*2)];
    _centerLabel.textColor = [UIColor colorWithRed:0x89/255. green:0x89/255. blue:0x89/255. alpha:1];
    _centerLabel.textAlignment = NSTextAlignmentCenter;
    _centerLabel.numberOfLines = 0;
    _centerLabel.font = [UIFont systemFontOfSize:100];
    _centerLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_centerLabel];
}

- (void)setCenterText{
    if (!self.centerText) {
        self.centerLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.persentage];
    }
}

- (void)resetLoopProgressView{
    
    [self.blueMaskLayer removeFromSuperlayer];
    [self.colorLayer removeFromSuperlayer];
    [self.colorMaskLayer removeFromSuperlayer];
    
    
    [self setupBlueMaskLayer];
    [self setupColorLayer];
    [self setupColorMaskLayer];
    
}


/**
 *  设置整个蓝色view的遮罩
 */
- (void)setupBlueMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
//    layer.fillColor = [UIColor blueColor].CGColor;
    layer.strokeColor = _backgroundLineColor.CGColor;
    layer.lineWidth = _backgroundLineWidth;
    [self.layer addSublayer:layer];
    //    self.layer.mask = layer;
    self.blueMaskLayer = layer;
}

/**
 *  设置渐变色，渐变色由左右两个部分组成，左边部分由黄到绿，右边部分由黄到红
 */
- (void)setupColorLayer {
    
    self.colorLayer = [CAShapeLayer layer];
    self.colorLayer.frame = self.bounds;
    [self.layer addSublayer:self.colorLayer];
    
    
    NSArray *rightColorList;
    NSArray *leftColorList;
    
    if (_colorsArray) {
        
        NSInteger countOfColor=_colorsArray.count;
        NSMutableArray<UIColor*>* tempColorsArray = [NSMutableArray arrayWithArray:_colorsArray];
        
        if (countOfColor > 0) {
            
            NSInteger startIndex = 0;
            
            startIndex = _startAngle/(2*M_PI)*countOfColor + countOfColor/4.0;
            if (_startAngle < 0) {
                startIndex = (_startAngle+2*M_PI)/(2*M_PI)*countOfColor + countOfColor/4.0;
            }
            if (startIndex % (countOfColor) != 0) {
                [tempColorsArray removeAllObjects];
                for (NSInteger i = 0; i < countOfColor; i++) {
                    [tempColorsArray addObject:_colorsArray[(i + (countOfColor - startIndex % countOfColor) )% countOfColor]];
                }
            }
            
            if (countOfColor < 2) {
                [tempColorsArray addObjectsFromArray:_colorsArray];
                countOfColor = tempColorsArray.count;
            }
            
            
            
            NSMutableArray *rightTempArray=[NSMutableArray array];
            NSMutableArray *leftTempArray=[NSMutableArray array];
            
            for(NSInteger number = 0; number < countOfColor; number++)
            {
                UIColor *color = tempColorsArray[number%countOfColor];
                if (number < countOfColor/2) {
                    
                    [leftTempArray addObject:(__bridge id)color.CGColor];
                }else{
                    
                    [rightTempArray addObject:(__bridge id)color.CGColor];
                }
            }
            
            if (countOfColor % 2 == 0) {
                [rightTempArray addObject:leftTempArray[0]];
                [leftTempArray addObject:rightTempArray[0]];
            }else{
                
                [leftTempArray addObject:rightTempArray[0]];
                [rightTempArray addObject:leftTempArray[0]];
            }
            
            if (self.clockWiseType == JDClockWiseYes) {
                rightColorList=[NSArray arrayWithArray:leftTempArray];
                leftColorList=[NSArray arrayWithArray:rightTempArray];

            }else{
                
                rightColorList=[NSArray arrayWithArray:rightTempArray];
                leftColorList=[NSArray arrayWithArray:leftTempArray];

            }
            
        }
        
    }
    
    
    if (!leftColorList) {
        leftColorList=@[(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
    }
    
    if (!rightColorList) {
        rightColorList=@[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
    }
    
    
    NSArray *leftLocations = [_customLeftLocations copy];
    NSArray *rightLocations = [_customRightLocations copy];
    
    if (!rightLocations) {
        NSMutableArray *temp=[NSMutableArray array];
        
        for (NSInteger count = rightColorList.count,i = 0; i < count-1; i++) {
            double angle = M_PI/(count-1)*i;
            [temp addObject:@(0.5-cos(angle)/2)];
        }
        rightLocations = [NSArray arrayWithArray:temp];
    }
    
    if (!leftLocations) {
        NSMutableArray *temp=[NSMutableArray array];
        
        for (NSInteger count = leftColorList.count,i = 0; i < count-1; i++) {
            double angle = M_PI/(count-1)*i;
            [temp addObject:@(0.5-cos(angle)/2)];
        }
        leftLocations = [NSArray arrayWithArray:temp];
    }
    
    CGFloat sideLength = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CAGradientLayer *leftLayer=[CAGradientLayer layer];
    leftLayer.frame=CGRectMake((CGRectGetWidth(self.bounds)-sideLength)/2, (CGRectGetHeight(self.bounds)-sideLength)/2, sideLength/2.f, sideLength);
    
    
    CAGradientLayer *rightLayer=[CAGradientLayer layer];
    rightLayer.frame=CGRectMake(CGRectGetWidth(self.bounds)/2, (CGRectGetHeight(self.bounds)-sideLength)/2, sideLength/2.f, sideLength);
    
    
    
    [leftLayer setLocations:leftLocations];
    [leftLayer setColors:leftColorList];
    
    
    [rightLayer setLocations:rightLocations];
    [rightLayer setColors:rightColorList];
    
    if (self.clockWiseType == JDClockWiseYes) {
        
        [leftLayer setStartPoint:CGPointMake(0.5, 1)];
        [leftLayer setEndPoint:CGPointMake(0.5, 0)];
        
        [rightLayer setStartPoint:CGPointMake(0.5, 0)];
        [rightLayer setEndPoint:CGPointMake(0.5, 1)];
    }else {
        
        [leftLayer setStartPoint:CGPointMake(0.5, 0)];
        [leftLayer setEndPoint:CGPointMake(0.5, 1)];
        
        [rightLayer setStartPoint:CGPointMake(0.5, 1)];
        [rightLayer setEndPoint:CGPointMake(0.5, 0)];
    }

    [self.colorLayer addSublayer:leftLayer];
    [self.colorLayer addSublayer:rightLayer];
}

/**
 *  设置渐变色的遮罩
 */
- (void)setupColorMaskLayer {
    
    CAShapeLayer *layer = [self generateMaskLayer];
    layer.lineWidth = [self lineWidth] + 0.5; // 渐变遮罩线宽较大，防止蓝色遮罩有边露出来
    self.colorLayer.mask = layer;
    self.colorMaskLayer = layer;
}

/**
 *  生成一个圆环形的遮罩层
 *  因为蓝色遮罩与渐变遮罩的配置都相同，所以封装出来
 *
 *  @return 环形遮罩
 */
- (CAShapeLayer *)generateMaskLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的2/5，起始角度是从-240°到60°
    
    UIBezierPath *path = nil;

    CGPoint point = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    
    if ([self clockWiseType] == JDClockWiseYes) {
        path = [UIBezierPath bezierPathWithArcCenter:point radius:self.radius startAngle:[self startAngle] endAngle:[self endAngle] clockwise:YES];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:point radius:self.radius startAngle:[self endAngle] endAngle:[self startAngle] clockwise:NO];
    }
    
    layer.lineWidth = [self lineWidth];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    layer.lineCap = kCALineCapRound; // 设置线为圆角
    return layer;
}

/**
 *  在修改百分比的时候，修改彩色遮罩的大小
 *
 *  @param persentage 百分比
 */
- (void)setPersentage:(CGFloat)persentage {
    
    _persentage = persentage;
    self.colorMaskLayer.strokeEnd = persentage;
    
    [self setCenterText];
    
    if (self.persentageChanged) {
        self.persentageChanged(_persentage);
    }
}

#pragma mark - getters and setters

- (void)setLineWidth:(CGFloat)lineWidth{

    if (_lineWidth != lineWidth) {
        _lineWidth = lineWidth;
        [self resetLoopProgressView];
    }
}

-(void)setBackgroundLineWidth:(CGFloat)backgroundLineWidth{
    
    if (_backgroundLineWidth != backgroundLineWidth) {
        _backgroundLineWidth = backgroundLineWidth;
        [self resetLoopProgressView];
    }
}

-(void)setBackgroundLineColor:(UIColor *)backgroundLineColor{
    
    if (_backgroundLineColor != backgroundLineColor) {
        _backgroundLineColor = backgroundLineColor;
        [self resetLoopProgressView];
    }
}

-(void)setStartAngle:(CGFloat)startAngle{
    
    if (_startAngle != startAngle) {
        _startAngle = (M_PI * (startAngle) / 180.0);
        [self resetLoopProgressView];
    }
}

-(void)setEndAngle:(CGFloat)endAngle{
    
    if (_endAngle != endAngle) {
        _endAngle = (M_PI * (endAngle) / 180.0);
        [self resetLoopProgressView];
    }
}

-(void)setColorsArray:(NSArray<UIColor *> *)colorsArray{
    
    _colorsArray = colorsArray;
    
    [self resetLoopProgressView];
    
}

-(void)setClockWiseType:(JDClockWiseType)clockWiseType{
    
    if (_clockWiseType != clockWiseType) {
        _clockWiseType = clockWiseType;
        [self resetLoopProgressView];
    }
}

- (CGFloat)radius{
    
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - MAX(self.lineWidth, self.backgroundLineWidth)/2;
    
    return radius;
}

@end
