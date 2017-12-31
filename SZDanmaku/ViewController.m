//
//  ViewController.m
//  SZDanmaku
//
//  Created by Zahi on 2017/12/25.
//  Copyright © 2017年 Zahi. All rights reserved.
//

#import "ViewController.h"
#import "SZDanmakuManager.h"

@interface ViewController ()
/**弹幕管理者**/
@property (nonatomic, strong) SZDanmakuManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.darkGrayColor;
    
    self.manager = [SZDanmakuManager new];
    __weak typeof(self) _self = self;
    self.manager.generateViewBlock = ^(SZBulletView *bulletView) {
        [_self addBulletView:bulletView];
    };
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    startBtn.frame = CGRectMake(0, 0, 100, 40);
    startBtn.center = CGPointMake(self.view.center.x / 2, 88);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(clickStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    stopBtn.frame = CGRectMake(0, 0, 100, 40);
    stopBtn.center = CGPointMake(self.view.center.x / 2 * 3, 88);
    [stopBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [stopBtn addTarget:self action:@selector(clickStopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
}

- (void)clickStartButton:(UIButton *)btn {
    
    [self.manager start];
}
- (void)clickStopButton {
    [self.manager stop];
}
- (void)addBulletView:(SZBulletView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.trajectory * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}
@end
