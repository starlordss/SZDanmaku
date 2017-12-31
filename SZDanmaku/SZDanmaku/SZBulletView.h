//
//  SZBulletView.h
//  SZDanmaku
//
//  Created by Zahi on 2017/12/26.
//  Copyright © 2017年 Zahi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SZBulletViewStatus) {
    SZBulletViewStatusStart,
    SZBulletViewStatusEnter,
    SZBulletViewStatusEnd,
};

@interface SZBulletView : UIView


/**弹道*/
@property (nonatomic, assign) int trajectory;
/**弹幕状态的回调*/
@property (nonatomic, copy) void(^moveStatusHandler)(SZBulletViewStatus status);

/**
 初始化弹幕

 @param comment 评论内容
 @return SZBulletView
 */
- (instancetype)initWithComment:(NSString *)comment;
/**开始动画*/
- (void)startAnimation;
/**结束动画*/
- (void)stopAnimation;

@end
