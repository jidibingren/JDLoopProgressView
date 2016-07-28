//
//  JDLoopProgressView.h
//  Example
//
//  Created by SC on 16/7/28.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, JDClockWiseType) {
    JDClockWiseYes,
    JDClockWiseNo
};

@interface JDLoopProgressView : UIView

// 起始颜色
@property (nonatomic, strong) UIColor *startColor;

// 中间颜色
@property (nonatomic, strong) UIColor *centerColor;

// 结束颜色
@property (nonatomic, strong) UIColor *endColor;

// 结束颜色
@property (nonatomic, strong) NSArray<UIColor*> *colorsArray;

// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;

// 线宽
@property (assign, nonatomic) CGFloat lineWidth;

// 背景线宽
@property (assign, nonatomic) CGFloat backgroundLineWidth;

// 背景线色
@property (nonatomic, strong) UIColor *backgroundLineColor;

// 起始角度（根据顺时针计算，逆时针则是结束角度）
@property (assign, nonatomic) CGFloat startAngle;

// 结束角度（根据顺时针计算，逆时针则是起始角度）
@property (assign, nonatomic) CGFloat endAngle;

// 进度条起始方向（YES为顺时针，NO为逆时针）
@property (assign, nonatomic) JDClockWiseType clockWiseType;

@property(nonatomic,copy)NSArray<NSNumber *> *customLeftLocations;

@property(nonatomic,copy)NSArray<NSNumber *> *customRightLocations;

@property (assign, nonatomic) CGFloat persentage;

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) NSAttributedString *centerText;

@property (nonatomic, strong) void (^persentageChanged)(CGFloat value);

@end
