//
//  ViewController.m
//  Example
//
//  Created by SC on 16/7/28.
//  Copyright © 2016年 SDJY. All rights reserved.
//

#import "ViewController.h"
#import "JDLoopProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JDLoopProgressView *loopView = [[JDLoopProgressView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
    loopView.backgroundLineWidth = 2;
//    loopView.colorsArray = @[[UIColor orangeColor]];
    loopView.lineWidth = 5;
//    loopView.startAngle = -90;
//    loopView.endAngle = 270;
    loopView.startAngle = 0;
    loopView.endAngle = 360;
    loopView.persentage = 0.5;
    loopView.centerLabel.text = @"75%";
    [self.view addSubview:loopView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
