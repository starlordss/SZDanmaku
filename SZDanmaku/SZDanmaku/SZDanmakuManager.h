//
//  SZDanmakuManager.h
//  SZDanmaku
//
//  Created by Zahi on 2017/12/26.
//  Copyright © 2017年 Zahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZBulletView.h"
@interface SZDanmakuManager : UIView
/**生成弹幕视图的回调*/
@property (nonatomic, copy) void(^generateViewBlock)(SZBulletView *bulletView);
- (void)start;

- (void)stop;

@end
