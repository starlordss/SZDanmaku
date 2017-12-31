//
//  SZDanmakuManager.m
//  SZDanmaku
//
//  Created by Zahi on 2017/12/26.
//  Copyright © 2017年 Zahi. All rights reserved.
//

#import "SZDanmakuManager.h"


@interface SZDanmakuManager ()
/**弹幕的数据来源*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/**弹幕使用过程中的数据变量**/
@property (nonatomic, strong) NSMutableArray *danmakuComments;
/**存储弹幕view的数据变量**/
@property (nonatomic, strong) NSMutableArray *bulletViews;
/**是否停止移动*/
@property (nonatomic, assign, getter = isStopAnimation) BOOL stopAnimation;

@end

@implementation SZDanmakuManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stopAnimation = YES;
    }
    return self;
}

- (void)start {
    if (!self.isStopAnimation) return;
    self.stopAnimation = NO;
    [self.danmakuComments removeAllObjects];
    [self.danmakuComments addObjectsFromArray:self.dataSource];
    [self initDanmakuComment];
}

- (void)initDanmakuComment {
    NSMutableArray *trajectorys = @[@0, @1, @2].mutableCopy;
    
    for (int i = 0; i < 3; i++) {
        if (self.danmakuComments.count > 0) {
            // 通过随机数获取弹幕的轨迹
            NSInteger idx = arc4random()%trajectorys.count;
            int trajectory = [trajectorys[idx] intValue];
            [trajectorys removeObjectAtIndex:idx];
            NSLog(@"--->%d",trajectory);
            // 从弹幕数组中逐一取出弹幕内容
            NSString *comment = self.danmakuComments.firstObject;
            [self.danmakuComments removeObjectAtIndex:0];
            // 创建弹幕视图
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory {
    if (self.isStopAnimation) return;
    SZBulletView *view = [[SZBulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) _self = self;
    view.moveStatusHandler = ^(SZBulletViewStatus status) {
        if (self.isStopAnimation) return;
        switch (status) {
            case SZBulletViewStatusStart: {
                // 弹幕开始进入屏幕，将view加入到数组中
                [_self.bulletViews addObject:weakView];
                break;
            }
                
            case SZBulletViewStatusEnter: {
                // 弹幕完全进入屏幕，判断是否还有其他内容，如果有则在弹幕轨迹中创建一个弹幕
                NSString *comment = [_self nextComment];
                if (comment) {
                    [_self createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case SZBulletViewStatusEnd: {
                // 弹幕完全在屏幕外
                if ([_self.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [_self.bulletViews removeObject:weakView];
                }
                if (_self.bulletViews.count == 0) {
                    // 屏幕没有弹幕了
                    [_self start];
                }
                break;
            }
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextComment {
    if (self.bulletViews.count == 0) return nil;
    NSString *comment = self.danmakuComments.firstObject;
    if (comment) {
        [self.bulletViews removeObjectAtIndex:0];
    }
    return comment;
}

- (void)stop {
    if (self.isStopAnimation) return;
    self.stopAnimation = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(SZBulletView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~~~~",
                                                       @"弹幕2~~~~~",
                                                       @"弹幕3~~~~~~~~~~~",
                                                       @"弹幕4~~~~~~~~~",
                                                       @"弹幕5~~~~~~~~~~~~~~~",
                                                       @"弹幕6~~~~~~~~~~~",
                                                       @"弹幕7~~~~~~~~~",
                                                       @"弹幕8~~~~~~~~~~~~~~~~~",
                                                       @"弹幕9~~~~~~~~~~~",
                                                       @"弹幕10~~~~~~~~~",
                                                       @"弹幕11~~~~~",
                                                       @"弹幕12~~~~~~~~~~~"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletViews {
    if (_bulletViews == nil) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

- (NSMutableArray *)danmakuComments {
    if (_danmakuComments == nil) {
        _danmakuComments = [NSMutableArray array];
    }
    return _danmakuComments;
}

@end
