
//
//  SZBulletView.m
//  SZDanmaku
//
//  Created by Zahi on 2017/12/26.
//  Copyright © 2017年 Zahi. All rights reserved.
//

#import "SZBulletView.h"

#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/ 255.0f green:arc4random_uniform(256)/ 255.0f blue:arc4random_uniform(256)/ 255.0f alpha:1.0f]

#define Padding 10
#define IconWidthOrHeight 30

@interface SZBulletView ()
/**评论内容标签**/
@property (nonatomic, strong) UILabel *commentLbl;
/**头像**/
@property (nonatomic, strong) UIImageView *iconView;
@end;

@implementation SZBulletView

- (instancetype)initWithComment:(NSString *)comment {
    self = [super init];
    if (self) {
        self.backgroundColor = RandomColor;
        CGFloat width = [comment sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        // 弹幕视图的bounds
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + IconWidthOrHeight, 30);
        self.commentLbl.text = comment;
        // 内容的frame
        self.commentLbl.frame = CGRectMake(Padding + IconWidthOrHeight, 0, width, 30);
        [self addSubview:self.commentLbl];
        [self addSubview:self.iconView];
    }
    return self;
}
/**开始动画*/
- (void)startAnimation {
    // 屏幕宽度
    CGFloat scrW =[UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.f;
    // 弹幕移动的距离
    CGFloat distance = scrW + CGRectGetWidth(self.bounds);
    
    // 弹幕开始
    if (self.moveStatusHandler) {
        self.moveStatusHandler(SZBulletViewStatusStart);
    }
    CGFloat speed = distance / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    // 进入屏幕执行
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];

    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // 移动
                         frame.origin.x -= distance;
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (self.moveStatusHandler) {
                             self.moveStatusHandler(SZBulletViewStatusEnd);
                         }
                     }];
    
}

- (void)enterScreen {
    if (self.moveStatusHandler) {
        self.moveStatusHandler(SZBulletViewStatusEnter);
    }
}
/**结束动画*/
- (void)stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

#pragma mark  - GETTER
- (UILabel *)commentLbl
{
    if (_commentLbl == nil) {
        _commentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLbl.textAlignment = NSTextAlignmentCenter;
        _commentLbl.font = [UIFont systemFontOfSize:14];
        _commentLbl.textColor = [UIColor whiteColor];
    }
    return _commentLbl;
}

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [UIImageView new];
        _iconView.clipsToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.frame = CGRectMake(-Padding, -Padding * 0.5, IconWidthOrHeight + Padding, IconWidthOrHeight + Padding);
        _iconView.layer.cornerRadius = (IconWidthOrHeight + Padding) * 0.5;
        _iconView.layer.borderColor = [UIColor orangeColor].CGColor;
        _iconView.image = [UIImage imageNamed:@"1"];
    }
    return _iconView;
}

@end
